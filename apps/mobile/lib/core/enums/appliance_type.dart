/// Recognized categories of household physical appliances.
enum ApplianceType {
  microwave('Microwave Oven'),
  washingMachine('Washing Machine'),
  refrigerator('Refrigerator'),
  dishwasher('Dishwasher'),
  airConditioner('Air Conditioner'),
  oven('Conventional Oven'),
  other('Other Appliance');

  final String displayName;
  const ApplianceType(this.displayName);

  static ApplianceType fromString(String value) {
    return switch (value.toLowerCase()) {
      'microwave' => ApplianceType.microwave,
      'washing_machine' || 'washingmachine' => ApplianceType.washingMachine,
      'refrigerator' || 'fridge' => ApplianceType.refrigerator,
      'dishwasher' => ApplianceType.dishwasher,
      'air_conditioner' || 'ac' => ApplianceType.airConditioner,
      'oven' => ApplianceType.oven,
      _ => ApplianceType.other,
    };
  }
}
