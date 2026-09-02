enum EmergencyType {
  medical('Medical'),
  accident('Accident'),
  fire('Fire'),
  flood('Flood'),
  crime('Crime'),
  other('Other');

  final String label;
  const EmergencyType(this.label);

  static EmergencyType fromString(String? type) {
    switch (type?.toLowerCase()) {
      case 'accident':
        return EmergencyType.accident;
      case 'fire':
        return EmergencyType.fire;
      case 'flood':
        return EmergencyType.flood;
      case 'crime':
        return EmergencyType.crime;
      case 'other':
        return EmergencyType.other;
      case 'medical':
      default:
        return EmergencyType.medical;
    }
  }
}
