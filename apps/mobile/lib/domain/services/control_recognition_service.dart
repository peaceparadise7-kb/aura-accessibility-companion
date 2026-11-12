import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/entities/appliance_profile.dart';
import 'package:aura_mobile/domain/entities/ar_frame_data.dart';
import 'package:aura_mobile/domain/entities/recognition_result.dart';

/// Abstract service governing physical control detection (buttons, dials, switches).
abstract class ControlRecognitionService {
  /// Detects physical control elements within an appliance panel frame.
  /// Uses [applianceProfile] as prior geometric and layout knowledge.
  Future<Result<List<ControlDetectionResult>>> detectControls({
    required CameraFrameData panelFrame,
    required ApplianceProfile applianceProfile,
  });
}
