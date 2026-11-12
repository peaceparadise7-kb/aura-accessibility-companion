import 'package:equatable/equatable.dart';
import 'package:aura_mobile/core/enums/ar_tracking_state.dart';

/// Base class for all normalized AR events emitted by ARCore and ARKit.
abstract class NormalizedAREvent extends Equatable {
  final int timestampMs;
  final String sessionId;

  const NormalizedAREvent({
    required this.timestampMs,
    required this.sessionId,
  });

  @override
  List<Object?> get props => [timestampMs, sessionId];
}

/// Emitted when AR tracking state or quality changes.
class ARTrackingStateChangedEvent extends NormalizedAREvent {
  final ARTrackingState state;
  final ARTrackingReason reason;

  const ARTrackingStateChangedEvent({
    required super.timestampMs,
    required super.sessionId,
    required this.state,
    this.reason = ARTrackingReason.none,
  });

  @override
  List<Object?> get props => [...super.props, state, reason];
}

/// Emitted when a physical plane (e.g. appliance front panel) is detected.
class ARPlaneDetectedEvent extends NormalizedAREvent {
  final String planeId;
  final String alignment; // 'vertical', 'horizontal'
  final double extentX;
  final double extentZ;

  const ARPlaneDetectedEvent({
    required super.timestampMs,
    required super.sessionId,
    required this.planeId,
    required this.alignment,
    required this.extentX,
    required this.extentZ,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        planeId,
        alignment,
        extentX,
        extentZ,
      ];
}

/// Emitted when an AR anchor is added or updated.
class ARAnchorUpdatedEvent extends NormalizedAREvent {
  final String anchorId;
  final List<double> matrix4x4;

  const ARAnchorUpdatedEvent({
    required super.timestampMs,
    required super.sessionId,
    required this.anchorId,
    required this.matrix4x4,
  });

  @override
  List<Object?> get props => [...super.props, anchorId, matrix4x4];
}

/// Emitted when a native AR session encounters an error.
class ARErrorEvent extends NormalizedAREvent {
  final String errorCode;
  final String errorMessage;

  const ARErrorEvent({
    required super.timestampMs,
    required super.sessionId,
    required this.errorCode,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [...super.props, errorCode, errorMessage];
}
