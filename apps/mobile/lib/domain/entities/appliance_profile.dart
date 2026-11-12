import 'package:equatable/equatable.dart';
import 'package:aura_mobile/core/enums/appliance_type.dart';
import 'package:aura_mobile/domain/entities/control_element.dart';

enum VerificationStatus {
  verified,
  communitySubmitted,
  deprecated;

  static VerificationStatus fromString(String val) {
    return switch (val.toLowerCase()) {
      'verified' => VerificationStatus.verified,
      'community_submitted' => VerificationStatus.communitySubmitted,
      'deprecated' => VerificationStatus.deprecated,
      _ => VerificationStatus.communitySubmitted,
    };
  }
}

/// Aggregate root representing a verified appliance profile containing geometry,
/// visual markers, and all physical controls.
class ApplianceProfile extends Equatable {
  final String id;
  final String name;
  final String manufacturer;
  final String modelNumber;
  final ApplianceType category;
  final String schemaVersion;
  final VerificationStatus verificationStatus;
  final List<ControlElement> controls;

  const ApplianceProfile({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.modelNumber,
    required this.category,
    required this.schemaVersion,
    required this.verificationStatus,
    required this.controls,
  });

  /// Finds a control element by its unique identifier.
  ControlElement? findControlById(String controlId) {
    for (final ctrl in controls) {
      if (ctrl.id == controlId) return ctrl;
    }
    return null;
  }

  /// Finds the closest control matching a normalized coordinate point (e.g. from AR Raycast).
  ControlElement? findControlAtPoint(double x, double y) {
    for (final ctrl in controls) {
      final box = ctrl.normalizedBoundingBox;
      if (x >= box.left && x <= box.right && y >= box.top && y <= box.bottom) {
        return ctrl;
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        manufacturer,
        modelNumber,
        category,
        schemaVersion,
        verificationStatus,
        controls,
      ];
}
