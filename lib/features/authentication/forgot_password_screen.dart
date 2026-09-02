import 'package:flutter/material.dart';
import '../../core/constants/route_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() => _isLoading = false);
      if (mounted) {
        Navigator.pushNamed(context, RouteConstants.verifyOtp, arguments: _controller.text.trim());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Forgot Password'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reset Password', style: AppTextStyles.displayMedium),
                const SizedBox(height: 8),
                Text(
                  'Enter your registered email or mobile number to receive a verification OTP code.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 36),

                AppTextField(
                  label: 'Email or Mobile',
                  hintText: 'Enter email or mobile number',
                  controller: _controller,
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.textMuted, size: 20),
                  validator: Validators.emailOrPhone,
                ),
                const SizedBox(height: 36),

                AppButton(
                  text: 'Send OTP',
                  isLoading: _isLoading,
                  onPressed: _sendOtp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
