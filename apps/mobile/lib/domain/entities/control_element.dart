import 'package:equatable/equatable.dart';
import 'package:aura_mobile/core/enums/control_type.dart';

/// Normalized 2D bounding box coordinates relative to the appliance panel (0.0 to 1.0).
class NormalizedBoundingBox extends Equatable {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const NormalizedBoundingBox({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  })  : assert(left >= 0.0 && left <= 1.0, 'left must be within [0.0, 1.0]'),
        assert(top >= 0.0 && top <= 1.0, 'top must be within [0.0, 1.0]'),
        assert(right >= left && right <= 1.0, 'right must be >= left and <= 1.0'),
        assert(bottom >= top && bottom <= 1.0, 'bottom must be >= top and <= 1.0');

  double get width => right - left;
  double get height => bottom - top;
  double get centerX => left + width / 2.0;
  double get centerY => top + height / 2.0;

  @override
  List<Object?> get props => [left, top, right, bottom];
}

/// Core domain entity representing a physical button, dial, or switch on an appliance.
class ControlElement extends Equatable {
  final String id;
  final String name;
  final ControlType type;
  final NormalizedBoundingBox normalizedBoundingBox;
  final List<String> ocrKeyTerms;
  final String functionDescription;
  final String audioCueText;
  final String? tactileFeature;
  final String? safetyWarning;

  const ControlElement({
    required this.id,
    required this.name,
    required this.type,
    required this.normalizedBoundingBox,
    required this.functionDescription,
    required this.audioCueText,
    this.ocrKeyTerms = const [],
    this.tactileFeature,
    this.safetyWarning,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        normalizedBoundingBox,
        ocrKeyTerms,
        functionDescription,
        audioCueText,
        tactileFeature,
        safetyWarning,
      ];
}
