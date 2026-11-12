import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:aura_mobile/core/errors/failures.dart';
import 'package:aura_mobile/core/logging/app_logger.dart';
import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/entities/ar_frame_data.dart';
import 'package:aura_mobile/domain/services/camera_service.dart';
import 'package:aura_mobile/platform/contracts/platform_channel_constants.dart';

/// Platform adapter implementing [CameraService].
/// Receives high-efficiency camera frames from native CameraX (Android) or AVFoundation (iOS).
class PlatformCameraAdapter implements CameraService {
  final MethodChannel _methodChannel;
  final EventChannel _frameChannel;
  final AppLogger _logger;

  final StreamController<CameraFrameData> _frameController =
      StreamController<CameraFrameData>.broadcast();
  StreamSubscription<dynamic>? _frameSubscription;

  bool _isStreaming = false;

  PlatformCameraAdapter({
    MethodChannel? methodChannel,
    EventChannel? frameChannel,
    required AppLogger logger,
  })  : _methodChannel = methodChannel ??
            const MethodChannel(PlatformChannelConstants.cameraMethodChannel),
        _frameChannel = frameChannel ??
            const EventChannel(PlatformChannelConstants.cameraFrameEventChannel),
        _logger = logger;

  @override
  Stream<CameraFrameData> get frameStream => _frameController.stream;

  @override
  Future<Result<void>> initialize({int targetFps = 15}) async {
    try {
      _logger.info('Initializing camera adapter with targetFps: $targetFps');
      await _methodChannel.invokeMethod<bool>('initializeCamera', {
        'targetFps': targetFps,
      });
      return const Result.ok(null);
    } on MissingPluginException {
      _logger.warning('Native camera plugin not present. Fallback mode active.');
      return const Result.ok(null);
    } catch (e) {
      return Result.err(CameraFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<void>> startStream() async {
    if (_isStreaming) return const Result.ok(null);

    try {
      _frameSubscription = _frameChannel.receiveBroadcastStream().listen(
        (dynamic event) {
          if (event is Map) {
            final bytes = event['bytes'] as Uint8List? ?? Uint8List(0);
            final width = event['width'] as int? ?? 1280;
            final height = event['height'] as int? ?? 720;
            final rotation = event['rotation'] as int? ?? 0;
            final timestamp = event['timestamp'] as int? ??
                DateTime.now().millisecondsSinceEpoch;

            _frameController.add(
              CameraFrameData(
                bytes: bytes,
                width: width,
                height: height,
                rotationDegrees: rotation,
                timestampMs: timestamp,
              ),
            );
          }
        },
        onError: (dynamic error) {
          _logger.error('Camera frame stream error', error: error);
        },
      );

      await _methodChannel.invokeMethod<void>('startStream');
      _isStreaming = true;
      return const Result.ok(null);
    } on MissingPluginException {
      _isStreaming = true;
      return const Result.ok(null);
    } catch (e) {
      return Result.err(CameraFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<void>> stopStream() async {
    try {
      await _frameSubscription?.cancel();
      _frameSubscription = null;
      await _methodChannel.invokeMethod<void>('stopStream');
      _isStreaming = false;
      return const Result.ok(null);
    } on MissingPluginException {
      _isStreaming = false;
      return const Result.ok(null);
    } catch (e) {
      return Result.err(CameraFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<CameraFrameData>> captureStillFrame() async {
    try {
      final res = await _methodChannel.invokeMapMethod<String, dynamic>('captureStill');
      if (res != null) {
        final bytes = res['bytes'] as Uint8List? ?? Uint8List(0);
        return Result.ok(
          CameraFrameData(
            bytes: bytes,
            width: res['width'] as int? ?? 1920,
            height: res['height'] as int? ?? 1080,
            rotationDegrees: res['rotation'] as int? ?? 0,
            timestampMs: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }
      return const Result.err(CameraFailure(message: 'Null frame captured'));
    } on MissingPluginException {
      // Mock still frame for non-native test environments
      return Result.ok(
        CameraFrameData(
          bytes: Uint8List(0),
          width: 1920,
          height: 1080,
          rotationDegrees: 0,
          timestampMs: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    } catch (e) {
      return Result.err(CameraFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Result<void>> dispose() async {
    await stopStream();
    await _frameController.close();
    return const Result.ok(null);
  }
}
