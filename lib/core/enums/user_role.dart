enum UserRole {
  citizen('Citizen'),
  authority('Authorization'),
  fieldOfficer('Field Officer'),
  guest('Guest');

  final String label;
  const UserRole(this.label);

  static UserRole fromString(String? role) {
    switch (role?.toLowerCase()) {
      case 'authority':
      case 'authorization':
      case 'admin':
        return UserRole.authority;
      case 'fieldofficer':
      case 'field_officer':
      case 'officer':
        return UserRole.fieldOfficer;
      case 'guest':
        return UserRole.guest;
      case 'citizen':
      default:
        return UserRole.citizen;
    }
  }
}
