import 'package:equatable/equatable.dart';

/// Base class for all domain and platform failures in AURA.
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic cause;

  const Failure({
    required this.message,
    this.code,
    this.cause,
  });

  @override
  List<Object?> get props => [message, code, cause];

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

/// Camera subsystem failure (e.g., permission denied, hardware unavailable).
class CameraFailure extends Failure {
  const CameraFailure({
    required super.message,
    super.code,
    super.cause,
  });
}

/// AR session failure (e.g., ARCore/ARKit unsupported, tracking lost, session crash).
class ARSessionFailure extends Failure {
  const ARSessionFailure({
    required super.message,
    super.code,
    super.cause,
  });
}

/// Appliance recognition failure (e.g., model inference failed, low confidence).
class RecognitionFailure extends Failure {
  const RecognitionFailure({
    required super.message,
    super.code,
    super.cause,
  });
}

/// Optical Character Recognition failure.
class OCRFailure extends Failure {
  const OCRFailure({
    required super.message,
    super.code,
    super.cause,
  });
}

/// Local storage or caching failure.
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
    super.cause,
  });
}

/// Appliance profile not found in local catalog or remote repository.
class ProfileNotFoundFailure extends Failure {
  const ProfileNotFoundFailure({
    required super.message,
    super.code,
    super.cause,
  });
}

/// Network or synchronization failure.
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.cause,
  });
}

/// Accessibility service failure (e.g., TTS engine unavailable, haptic unsupported).
class AccessibilityServiceFailure extends Failure {
  const AccessibilityServiceFailure({
    required super.message,
    super.code,
    super.cause,
  });
}
