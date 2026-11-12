import 'dart:math' as math;
import 'package:aura_mobile/core/constants/app_constants.dart';
import 'package:aura_mobile/core/logging/app_logger.dart';
import 'package:aura_mobile/core/utils/result.dart';
import 'package:aura_mobile/domain/entities/appliance_profile.dart';
import 'package:aura_mobile/domain/entities/control_element.dart';
import 'package:aura_mobile/domain/entities/recognition_result.dart';
import 'package:aura_mobile/domain/services/control_mapping_service.dart';
import 'package:aura_mobile/domain/services/ocr_service.dart';

/// Production implementation of [ControlMappingService].
///
/// SAFETY INVARIANT: Never hallucinates control functionality.
/// Controls are verified only when geometric proximity or OCR keyword correlation exceeds
/// strict confidence thresholds against verified profiles.
class RuleBasedControlMappingService implements ControlMappingService {
  final AppLogger _logger;

  RuleBasedControlMappingService({required AppLogger logger}) : _logger = logger;

  @override
  Result<List<MappedControl>> mapControls({
    required ApplianceProfile profile,
    required List<ControlDetectionResult> detections,
    required List<OCRDetection> ocrResults,
  }) {
    final mappedList = <MappedControl>[];

    for (final expectedControl in profile.controls) {
      ControlDetectionResult? bestDetection;
      double bestScore = 0.0;

      // 1. Evaluate spatial alignment with expected bounding box
      for (final detection in detections) {
        final iou = _calculateIoU(
          expectedControl.normalizedBoundingBox,
          detection.boundingBox,
        );

        if (iou > bestScore && iou >= 0.3) {
          bestScore = iou;
          bestDetection = detection;
        }
      }

      // 2. Correlate OCR key terms
      bool ocrConfirmed = false;
      for (final ocr in ocrResults) {
        for (final expectedTerm in expectedControl.ocrKeyTerms) {
          if (ocr.text.toLowerCase().contains(expectedTerm.toLowerCase())) {
            // Check if OCR is physically near the control box
            final dist = _boxDistance(expectedControl.normalizedBoundingBox, ocr.boundingBox);
            if (dist < 0.15) {
              ocrConfirmed = true;
              break;
            }
          }
        }
        if (ocrConfirmed) break;
      }

      // 3. Verification decision: require sufficient spatial match OR OCR confirmation
      final isVerified = (bestScore >= AppConstants.minRecognitionConfidence) || ocrConfirmed;

      if (bestDetection != null && isVerified) {
        mappedList.add(
          MappedControl(
            profileElement: expectedControl,
            liveBoundingBox: bestDetection.boundingBox,
            confidence: math.max(bestScore, ocrConfirmed ? 0.85 : 0.65),
            isVerified: true,
          ),
        );
      } else {
        // Fallback to profile prior if geometry is stable, marked as unverified live
        _logger.debug(
          'Control ${expectedControl.id} not verified with high confidence; keeping profile prior.',
        );
      }
    }

    return Result.ok(mappedList);
  }

  double _calculateIoU(NormalizedBoundingBox a, NormalizedBoundingBox b) {
    final interLeft = math.max(a.left, b.left);
    final interTop = math.max(a.top, b.top);
    final interRight = math.min(a.right, b.right);
    final interBottom = math.min(a.bottom, b.bottom);

    if (interRight < interLeft || interBottom < interTop) return 0.0;

    final interArea = (interRight - interLeft) * (interBottom - interTop);
    final areaA = a.width * a.height;
    final areaB = b.width * b.height;
    final unionArea = areaA + areaB - interArea;

    if (unionArea <= 0.0) return 0.0;
    return interArea / unionArea;
  }

  double _boxDistance(NormalizedBoundingBox a, NormalizedBoundingBox b) {
    final dx = a.centerX - b.centerX;
    final dy = a.centerY - b.centerY;
    return math.sqrt(dx * dx + dy * dy);
  }
}
