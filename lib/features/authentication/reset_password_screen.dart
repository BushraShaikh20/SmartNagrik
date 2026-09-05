import 'package:flutter/material.dart';
import '../../core/constants/route_constants.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_password_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() => _isLoading = false);
      if (mounted) {
        Navigator.pushReplacementNamed(context, RouteConstants.resetSuccess);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Reset Password'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Set New Password', style: AppTextStyles.displayMedium),
                const SizedBox(height: 8),
                Text(
                  'Your new password must be at least 6 characters long.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 36),

                AppPasswordField(
                  label: 'New Password',
                  hintText: 'Enter new password',
                  controller: _passwordController,
                  validator: Validators.password,
                ),
                const SizedBox(height: 20),

                AppPasswordField(
                  label: 'Confirm Password',
                  hintText: 'Re-enter new password',
                  controller: _confirmController,
                  validator: (val) => Validators.confirmPassword(val, _passwordController.text),
                ),
                const SizedBox(height: 36),

                AppButton(
                  text: 'Reset Password',
                  isLoading: _isLoading,
                  onPressed: _resetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
