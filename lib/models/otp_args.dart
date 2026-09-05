import '../core/enums/user_role.dart';

enum OtpPurpose { signIn, passwordReset }

class OtpArgs {
  final String destination;
  final UserRole role;
  final OtpPurpose purpose;
  final String? verificationId;
  final String? fullName;

  const OtpArgs({
    required this.destination,
    required this.role,
    this.purpose = OtpPurpose.signIn,
    this.verificationId,
    this.fullName,
  });
}
