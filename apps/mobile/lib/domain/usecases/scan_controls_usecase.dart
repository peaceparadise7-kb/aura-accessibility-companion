import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/entities/appliance_profile.dart';
import 'package:aura_mobile/domain/entities/ar_frame_data.dart';
import 'package:aura_mobile/domain/services/control_mapping_service.dart';
import 'package:aura_mobile/domain/services/control_recognition_service.dart';
import 'package:aura_mobile/domain/services/ocr_service.dart';

class ScanControlsUseCase {
  final ControlRecognitionService controlRecognitionService;
  final OCRService ocrService;
  final ControlMappingService controlMappingService;

  const ScanControlsUseCase({
    required this.controlRecognitionService,
    required this.ocrService,
    required this.controlMappingService,
  });

  Future<Result<List<MappedControl>>> execute({
    required CameraFrameData frame,
    required ApplianceProfile profile,
  }) async {
    // 1. Detect physical controls
    final controlsRes = await controlRecognitionService.detectControls(
      panelFrame: frame,
      applianceProfile: profile,
    );

    if (controlsRes.isErr) {
      return Result.err(controlsRes.failureOrNull!);
    }

    // 2. Extract OCR text
    final ocrRes = await ocrService.extractText(frame.bytes);
    final ocrDetections = ocrRes.valueOrNull ?? const [];

    // 3. Map controls safely using verified profile
    return controlMappingService.mapControls(
      profile: profile,
      detections: controlsRes.valueOrNull ?? const [],
      ocrResults: ocrDetections,
    );
  }
}
