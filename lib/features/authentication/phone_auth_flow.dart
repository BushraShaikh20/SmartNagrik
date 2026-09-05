import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/user_role.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/otp_args.dart';

Future<void> startPhoneAuth(
  BuildContext context, {
  required UserRole role,
  OtpPurpose purpose = OtpPurpose.signIn,
  String? fullName,
}) async {
  final phone = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _PhoneSheet(),
  );
  if (phone == null || phone.isEmpty || !context.mounted) return;

  final auth = context.read<AuthService>();
  final sent = await auth.sendPhoneOtp(phone);
  if (!context.mounted) return;
  if (!sent) {
    SnackbarUtils.showError(
      context,
      auth.errorMessage ?? 'Could not send OTP. Please try again.',
    );
    return;
  }

  Navigator.pushNamed(
    context,
    RouteConstants.verifyOtp,
    arguments: OtpArgs(
      destination: auth.normalizePhone(phone),
      role: role,
      purpose: purpose,
      fullName: fullName,
    ),
  );
}

class _PhoneSheet extends StatefulWidget {
  const _PhoneSheet();

  @override
  State<_PhoneSheet> createState() => _PhoneSheetState();
}

class _PhoneSheetState extends State<_PhoneSheet> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Mobile OTP', style: AppTextStyles.titleLarge),
              const SizedBox(height: 6),
              Text(
                'Enter your 10-digit mobile number. We will send a verification code.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 20),
              AppTextField(
                label: 'Mobile Number',
                hintText: 'Enter 10-digit mobile number',
                controller: _controller,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined,
                    color: AppColors.primary, size: 20),
                validator: Validators.phone,
              ),
              const SizedBox(height: 20),
              AppButton(
                text: 'Send OTP',
                icon: Icons.sms_outlined,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.pop(context, _controller.text.trim());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
