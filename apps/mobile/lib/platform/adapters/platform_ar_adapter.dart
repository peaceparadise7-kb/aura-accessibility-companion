import 'dart:async';
import 'package:flutter/services.dart';
import 'package:aura_mobile/core/enums/ar_tracking_state.dart';
import 'package:aura_mobile/core/errors/failures.dart';
import 'package:aura_mobile/core/logging/app_logger.dart';
import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/services/ar_session_service.dart';
import 'package:aura_mobile/platform/contracts/normalized_ar_event.dart';
import 'package:aura_mobile/platform/contracts/platform_channel_constants.dart';

/// Platform adapter implementing [ARSessionService].
/// Normalizes native events from ARCore (Android) and ARKit (iOS) into unified domain events.
class PlatformARAdapter implements ARSessionService {
  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;
  final AppLogger _logger;

  final StreamController<NormalizedAREvent> _eventController =
      StreamController<NormalizedAREvent>.broadcast();
  StreamSubscription<dynamic>? _nativeSubscription;

  ARTrackingState _currentState = ARTrackingState.notTracking;

  PlatformARAdapter({
    MethodChannel? methodChannel,
    EventChannel? eventChannel,
    required AppLogger logger,
  })  : _methodChannel = methodChannel ??
            const MethodChannel(PlatformChannelConstants.arMethodChannel),
        _eventChannel = eventChannel ??
            const EventChannel(PlatformChannelConstants.arEventChannel),
        _logger = logger;

  @override
  Stream<NormalizedAREvent> get eventStream => _eventController.stream;

  @override
  ARTrackingState get currentTrackingState => _currentState;

  @override
  Future<Result<void>> initializeSession({bool detectVerticalPlanes = true}) async {
    try {
      _logger.info('Initializing AR session (detectVerticalPlanes: $detectVerticalPlanes)');

      _nativeSubscription = _eventChannel.receiveBroadcastStream().listen(
        _handleNativeEvent,
        onError: (dynamic error) {
          _logger.error('AR native event stream error', error: error);
          _eventController.add(
            ARErrorEvent(
              timestampMs: DateTime.now().millisecondsSinceEpoch,
              sessionId: 'current',
              errorCode: 'EVENT_STREAM_ERROR',
              errorMessage: error.toString(),
            ),
          );
        },
      );

      final result = await _methodChannel.invokeMethod<bool>('initializeSession', {
        'detectVerticalPlanes': detectVerticalPlanes,
      });

      if (result == true) {
        _currentState = ARTrackingState.initializing;
        return const Result.ok(null);
      } else {
        return const Result.err(
          ARSessionFailure(message: 'Failed to initialize native AR session'),
        );
      }
    } on MissingPluginException {
      _logger.warning('Native AR plugin not registered. Operating in fallback/mock state.');
      _currentState = ARTrackingState.tracking;
      return const Result.ok(null);
    } catch (e, st) {
      _logger.error('Error during AR session initialization', error: e, stackTrace: st);
      return Result.err(ARSessionFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<void>> pauseSession() async {
    try {
      await _methodChannel.invokeMethod<void>('pauseSession');
      _currentState = ARTrackingState.paused;
      return const Result.ok(null);
    } on MissingPluginException {
      _currentState = ARTrackingState.paused;
      return const Result.ok(null);
    } catch (e) {
      return Result.err(ARSessionFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<void>> resumeSession() async {
    try {
      await _methodChannel.invokeMethod<void>('resumeSession');
      _currentState = ARTrackingState.tracking;
      return const Result.ok(null);
    } on MissingPluginException {
      _currentState = ARTrackingState.tracking;
      return const Result.ok(null);
    } catch (e) {
      return Result.err(ARSessionFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<String>> createAnchor({
    required double screenX,
    required double screenY,
  }) async {
    try {
      final anchorId = await _methodChannel.invokeMethod<String>('createAnchor', {
        'x': screenX,
        'y': screenY,
      });

      if (anchorId != null) {
        return Result.ok(anchorId);
      }
      return const Result.err(
        ARSessionFailure(message: 'Native anchor creation returned null'),
      );
    } on MissingPluginException {
      final fallbackId = 'mock_anchor_${DateTime.now().millisecondsSinceEpoch}';
      return Result.ok(fallbackId);
    } catch (e) {
      return Result.err(ARSessionFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<void>> removeAnchor(String anchorId) async {
    try {
      await _methodChannel.invokeMethod<void>('removeAnchor', {'anchorId': anchorId});
      return const Result.ok(null);
    } on MissingPluginException {
      return const Result.ok(null);
    } catch (e) {
      return Result.err(ARSessionFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<void>> dispose() async {
    await _nativeSubscription?.cancel();
    await _eventController.close();
    _currentState = ARTrackingState.notTracking;
    return const Result.ok(null);
  }

  void _handleNativeEvent(dynamic event) {
    if (event is! Map) return;

    final type = event['eventType'] as String?;
    final timestamp = event['timestampMs'] as int? ?? DateTime.now().millisecondsSinceEpoch;
    final sessionId = event['sessionId'] as String? ?? 'unknown';

    switch (type) {
      case 'tracking_state_changed':
        final stateStr = event['trackingState'] as String? ?? 'not_tracking';
        final state = switch (stateStr) {
          'initializing' => ARTrackingState.initializing,
          'tracking' => ARTrackingState.tracking,
          'paused' => ARTrackingState.paused,
          'limited' => ARTrackingState.limited,
          _ => ARTrackingState.notTracking,
        };
        _currentState = state;
        _eventController.add(
          ARTrackingStateChangedEvent(
            timestampMs: timestamp,
            sessionId: sessionId,
            state: state,
            reason: ARTrackingReason.fromString(event['trackingReason'] as String?),
          ),
        );
        break;

      case 'plane_detected':
        _eventController.add(
          ARPlaneDetectedEvent(
            timestampMs: timestamp,
            sessionId: sessionId,
            planeId: event['planeId'] as String? ?? 'plane_0',
            alignment: event['alignment'] as String? ?? 'vertical',
            extentX: (event['extentX'] as num?)?.toDouble() ?? 0.0,
            extentZ: (event['extentZ'] as num?)?.toDouble() ?? 0.0,
          ),
        );
        break;

      case 'anchor_updated':
        final rawMatrix = (event['matrix4x4'] as List<dynamic>?)
                ?.map((e) => (e as num).toDouble())
                .toList() ??
            List<double>.filled(16, 0.0);
        _eventController.add(
          ARAnchorUpdatedEvent(
            timestampMs: timestamp,
            sessionId: sessionId,
            anchorId: event['anchorId'] as String? ?? 'anchor_0',
            matrix4x4: rawMatrix,
          ),
        );
        break;
    }
  }
}
