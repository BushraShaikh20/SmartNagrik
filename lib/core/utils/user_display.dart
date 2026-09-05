import '../../models/user_model.dart';
import '../enums/user_role.dart';

extension UserDisplayX on UserModel? {
  String get greetingFirstName {
    final name = this?.fullName.trim() ?? '';
    if (name.isEmpty) {
      return this?.role == UserRole.guest ? 'Guest' : 'there';
    }
    return name.split(RegExp(r'\s+')).first;
  }

  String get displayName {
    final name = this?.fullName.trim() ?? '';
    if (name.isNotEmpty) return name;
    if (this?.role == UserRole.guest) return 'Guest';
    return 'User';
  }

  String get displayEmail {
    final email = this?.email.trim() ?? '';
    return email;
  }

  String get roleCaption {
    switch (this?.role) {
      case UserRole.authority:
        return 'Municipal Authority';
      case UserRole.fieldOfficer:
        return 'Field Officer';
      case UserRole.guest:
        return 'Guest';
      case UserRole.citizen:
      default:
        return 'Citizen Reporter';
    }
  }
}
