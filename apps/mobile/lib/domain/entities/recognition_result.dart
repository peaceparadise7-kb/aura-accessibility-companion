import 'package:equatable/equatable.dart';
import 'package:aura_mobile/domain/entities/control_element.dart';

/// Detected appliance classification candidate.
class ApplianceCandidate extends Equatable {
  final String profileId;
  final String label;
  final double confidence;

  const ApplianceCandidate({
    required this.profileId,
    required this.label,
    required this.confidence,
  });

  @override
  List<Object?> get props => [profileId, label, confidence];
}

/// Overall recognition result for an appliance in a camera frame.
class ApplianceRecognitionResult extends Equatable {
  final List<ApplianceCandidate> candidates;
  final NormalizedBoundingBox? panelBoundingBox;
  final int inferenceTimeMs;

  const ApplianceRecognitionResult({
    required this.candidates,
    this.panelBoundingBox,
    required this.inferenceTimeMs,
  });

  ApplianceCandidate? get topCandidate =>
      candidates.isNotEmpty ? candidates.first : null;

  @override
  List<Object?> get props => [candidates, panelBoundingBox, inferenceTimeMs];
}

/// Result of detecting physical control elements in a panel frame.
class ControlDetectionResult extends Equatable {
  final String? matchedControlId;
  final NormalizedBoundingBox boundingBox;
  final double confidence;
  final String? detectedOcrText;

  const ControlDetectionResult({
    this.matchedControlId,
    required this.boundingBox,
    required this.confidence,
    this.detectedOcrText,
  });

  @override
  List<Object?> get props => [
        matchedControlId,
        boundingBox,
        confidence,
        detectedOcrText,
      ];
}
