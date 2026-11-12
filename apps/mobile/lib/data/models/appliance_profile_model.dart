import 'package:aura_mobile/core/enums/appliance_type.dart';
import 'package:aura_mobile/core/enums/control_type.dart';
import 'package:aura_mobile/domain/entities/appliance_profile.dart';
import 'package:aura_mobile/domain/entities/control_element.dart';

class ApplianceProfileModel {
  static ApplianceProfile fromJson(Map<String, dynamic> json) {
    final rawControls = (json['controls'] as List<dynamic>?) ?? [];
    final controls = rawControls.map((c) => _controlFromJson(c as Map<String, dynamic>)).toList();

    return ApplianceProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      manufacturer: json['manufacturer'] as String,
      modelNumber: json['modelNumber'] as String,
      category: ApplianceType.fromString(json['category'] as String? ?? 'other'),
      schemaVersion: json['schemaVersion'] as String? ?? '1.0.0',
      verificationStatus:
          VerificationStatus.fromString(json['verificationStatus'] as String? ?? 'verified'),
      controls: controls,
    );
  }

  static ControlElement _controlFromJson(Map<String, dynamic> json) {
    final box = json['normalizedBoundingBox'] as Map<String, dynamic>;
    final rawOcr = (json['ocrKeyTerms'] as List<dynamic>?) ?? [];

    return ControlElement(
      id: json['id'] as String,
      name: json['name'] as String,
      type: ControlType.fromString(json['type'] as String? ?? 'button'),
      normalizedBoundingBox: NormalizedBoundingBox(
        left: (box['left'] as num).toDouble(),
        top: (box['top'] as num).toDouble(),
        right: (box['right'] as num).toDouble(),
        bottom: (box['bottom'] as num).toDouble(),
      ),
      ocrKeyTerms: rawOcr.map((e) => e.toString()).toList(),
      functionDescription: json['functionDescription'] as String? ?? '',
      audioCueText: json['audioCueText'] as String? ?? '',
      tactileFeature: json['tactileFeature'] as String?,
      safetyWarning: json['safetyWarning'] as String?,
    );
  }

  static Map<String, dynamic> toJson(ApplianceProfile profile) {
    return {
      'id': profile.id,
      'name': profile.name,
      'manufacturer': profile.manufacturer,
      'modelNumber': profile.modelNumber,
      'category': profile.category.name,
      'schemaVersion': profile.schemaVersion,
      'verificationStatus': profile.verificationStatus.name,
      'controls': profile.controls.map((c) => _controlToJson(c)).toList(),
    };
  }

  static Map<String, dynamic> _controlToJson(ControlElement control) {
    return {
      'id': control.id,
      'name': control.name,
      'type': control.type.name,
      'normalizedBoundingBox': {
        'left': control.normalizedBoundingBox.left,
        'top': control.normalizedBoundingBox.top,
        'right': control.normalizedBoundingBox.right,
        'bottom': control.normalizedBoundingBox.bottom,
      },
      'ocrKeyTerms': control.ocrKeyTerms,
      'functionDescription': control.functionDescription,
      'audioCueText': control.audioCueText,
      'tactileFeature': control.tactileFeature,
      'safetyWarning': control.safetyWarning,
    };
  }
}
