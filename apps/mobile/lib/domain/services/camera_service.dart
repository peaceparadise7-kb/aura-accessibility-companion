import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/entities/ar_frame_data.dart';

/// Abstract service governing device camera streams and frame captures.
/// Implementations must wrap platform-specific camera engines (e.g., CameraX on Android, AVFoundation on iOS).
abstract class CameraService {
  /// Stream of raw incoming image frames suitable for CV and OCR pipelines.
  Stream<CameraFrameData> get frameStream;

  /// Initializes camera hardware with preferred resolution and target frame rate.
  Future<Result<void>> initialize({int targetFps = 15});

  /// Starts live frame streaming.
  Future<Result<void>> startStream();

  /// Pauses or stops live frame streaming while keeping hardware initialized.
  Future<Result<void>> stopStream();

  /// Captures a single full-resolution still frame.
  Future<Result<CameraFrameData>> captureStillFrame();

  /// Releases all camera resources.
  Future<Result<void>> dispose();
}
