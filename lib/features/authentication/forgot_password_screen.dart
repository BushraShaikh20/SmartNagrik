import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/user_role.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_shell.dart';
import '../../models/otp_args.dart';
import 'phone_auth_flow.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final value = _controller.text.trim();
    final auth = context.read<AuthService>();

    if (value.contains('@')) {
      final sent = await auth.sendPasswordResetEmail(value);
      if (!mounted) return;
      if (sent) {
        SnackbarUtils.showSuccess(
            context, 'Password reset email sent. Check your inbox.');
        Navigator.pop(context);
      } else {
        SnackbarUtils.showError(
          context,
          auth.errorMessage ?? 'Could not send reset email.',
        );
      }
      return;
    }

    await startPhoneAuth(
      context,
      role: UserRole.citizen,
      purpose: OtpPurpose.passwordReset,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Forgot Password'),
      body: AuthShell(
        title: 'Reset Password',
        subtitle: '',
        icon: Icons.lock_reset_rounded,
        accent: AppColors.primary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHero(
                    title: 'Reset Password',
                    subtitle:
                        'Enter your registered email to receive a reset link, or your mobile number for OTP.',
                    icon: Icons.lock_reset_rounded,
                    accent: AppColors.primary,
                  ),
                  const SizedBox(height: 36),
                  AppTextField(
                    label: 'Email or Mobile',
                    hintText: 'Enter email or mobile number',
                    controller: _controller,
                    prefixIcon: const Icon(Icons.person_outline_rounded,
                        color: AppColors.textMuted, size: 20),
                    validator: Validators.emailOrPhone,
                  ),
                  const SizedBox(height: 36),
                  AppButton(
                    text: 'Continue',
                    isLoading: auth.isLoading,
                    onPressed: _sendReset,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
