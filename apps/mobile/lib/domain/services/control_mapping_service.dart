import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/entities/appliance_profile.dart';
import 'package:aura_mobile/domain/entities/control_element.dart';
import 'package:aura_mobile/domain/entities/recognition_result.dart';
import 'package:aura_mobile/domain/services/ocr_service.dart';

/// Mapping between a detected physical button and a verified profile control element.
class MappedControl {
  final ControlElement profileElement;
  final NormalizedBoundingBox liveBoundingBox;
  final double confidence;
  final bool isVerified;

  const MappedControl({
    required this.profileElement,
    required this.liveBoundingBox,
    required this.confidence,
    required this.isVerified,
  });
}

/// Abstract service that binds live physical CV/OCR detections to verified profile definitions.
///
/// CRITICAL INVARIANT: The mapping service MUST NEVER invent or hallucinate the meaning of
/// an unidentified control. If confidence or geometric alignment falls below the verified threshold,
/// it must return unmapped or unverified, never a guessed function.
abstract class ControlMappingService {
  Result<List<MappedControl>> mapControls({
    required ApplianceProfile profile,
    required List<ControlDetectionResult> detections,
    required List<OCRDetection> ocrResults,
  });
}
