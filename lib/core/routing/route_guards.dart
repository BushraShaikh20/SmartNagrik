import '../enums/user_role.dart';

class RouteGuards {
  static bool canAccessAdmin(UserRole role) {
    return role == UserRole.authority;
  }

  static bool canAccessOfficer(UserRole role) {
    return role == UserRole.fieldOfficer || role == UserRole.authority;
  }

  static bool canAccessCitizen(UserRole role) {
    return role == UserRole.citizen || role == UserRole.guest;
  }
}
