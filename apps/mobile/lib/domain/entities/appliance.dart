import 'package:equatable/equatable.dart';
import 'package:aura_mobile/core/enums/appliance_type.dart';

/// Core domain entity representing a recognized household appliance.
class Appliance extends Equatable {
  final String id;
  final String name;
  final String manufacturer;
  final String modelNumber;
  final ApplianceType category;

  const Appliance({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.modelNumber,
    required this.category,
  });

  @override
  List<Object?> get props => [id, name, manufacturer, modelNumber, category];
}
