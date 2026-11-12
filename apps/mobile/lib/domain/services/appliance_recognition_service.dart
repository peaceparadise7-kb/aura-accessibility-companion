import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/entities/ar_frame_data.dart';
import 'package:aura_mobile/domain/entities/recognition_result.dart';

/// Abstract service governing appliance classification and control panel localization.
abstract class ApplianceRecognitionService {
  /// Analyzes a camera frame to detect and classify household appliances.
  Future<Result<ApplianceRecognitionResult>> recognizeAppliance(
    CameraFrameData frame,
  );
}
