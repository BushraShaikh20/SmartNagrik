import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_password_field.dart';
import '../../core/widgets/app_text_field.dart';

class FieldOfficerLoginScreen extends StatefulWidget {
  const FieldOfficerLoginScreen({super.key});

  @override
  State<FieldOfficerLoginScreen> createState() =>
      _FieldOfficerLoginScreenState();
}

class _FieldOfficerLoginScreenState extends State<FieldOfficerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final auth = context.read<AuthService>();
      final success = await auth.loginAsFieldOfficer(
        emailOrPhone: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        SnackbarUtils.showSuccess(context, 'Officer Authenticated: ${auth.currentUser?.fullName}');
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteConstants.fieldOfficerDashboard,
          (route) => false,
        );
      } else {
        SnackbarUtils.showError(
          context,
          auth.errorMessage ?? 'Invalid officer credentials. Please check and retry.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Field Officer Login'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Officer Portal 👷', style: AppTextStyles.displayMedium),
                const SizedBox(height: 8),
                Text(
                  'Sign in to view your assigned civic repair tasks, update on-site resolution status, and submit proof.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 32),

                AppTextField(
                  label: 'Officer ID / Email',
                  hintText: 'Enter your officer email ID',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.engineering_outlined,
                      color: AppColors.purple, size: 20),
                  validator: Validators.email,
                ),
                const SizedBox(height: 20),

                AppPasswordField(
                  label: 'Password',
                  hintText: 'Enter your officer password',
                  controller: _passwordController,
                  validator: Validators.password,
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: AppColors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) {
                              setState(() => _rememberMe = val ?? false);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Remember credentials',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, RouteConstants.forgotPassword),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.purple,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                AppButton(
                  text: 'Access Field Dashboard',
                  backgroundColor: AppColors.purple,
                  isLoading: auth.isLoading,
                  onPressed: _handleLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
