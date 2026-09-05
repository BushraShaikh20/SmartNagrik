import 'package:flutter_test/flutter_test.dart';
import 'package:smart_nagrik/core/enums/user_role.dart';
import 'package:smart_nagrik/core/services/auth_service.dart';

void main() {
  group('AuthService Tests', () {
    test('Authentication and Role validation', () async {
      final auth = AuthService();
      expect(auth.isAuthenticated, false);

      // Invalid login fails
      final failResult = await auth.loginAsCitizen(
        emailOrPhone: 'wrong@example.com',
        password: 'wrongpassword',
      );
      expect(failResult, false);
      expect(auth.isAuthenticated, false);

      // Valid Citizen login succeeds
      final citizenSuccess = await auth.loginAsCitizen(
        emailOrPhone: 'rohan.sharma@example.com',
        password: 'password123',
      );
      expect(citizenSuccess, true);
      expect(auth.isAuthenticated, true);
      expect(auth.currentRole, UserRole.citizen);

      // Authority login
      final authoritySuccess = await auth.loginAsAuthority(
        emailOrPhone: 'admin@smartnagrik.gov.in',
        password: 'admin123',
      );
      expect(authoritySuccess, true);
      expect(auth.currentRole, UserRole.authority);

      // Field Officer login
      final officerSuccess = await auth.loginAsFieldOfficer(
        emailOrPhone: 'rajesh.patil@smartnagrik.gov.in',
        password: 'officer123',
      );
      expect(officerSuccess, true);
      expect(auth.currentRole, UserRole.fieldOfficer);
    });
  });
}
