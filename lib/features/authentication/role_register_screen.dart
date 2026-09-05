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
import '../../core/widgets/app_password_field.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_shell.dart';

class RoleRegisterScreen extends StatefulWidget {
  final UserRole role;
  const RoleRegisterScreen({super.key, required this.role});

  @override
  State<RoleRegisterScreen> createState() => _RoleRegisterScreenState();
}

class _RoleRegisterScreenState extends State<RoleRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;

  Color get _accent {
    switch (widget.role) {
      case UserRole.authority:
        return AppColors.secondary;
      case UserRole.fieldOfficer:
        return AppColors.purple;
      default:
        return AppColors.primary;
    }
  }

  String get _title {
    switch (widget.role) {
      case UserRole.authority:
        return 'Authority Register';
      case UserRole.fieldOfficer:
        return 'Officer Register';
      default:
        return 'Create Account';
    }
  }

  String get _homeRoute {
    switch (widget.role) {
      case UserRole.authority:
        return RouteConstants.authorityDashboard;
      case UserRole.fieldOfficer:
        return RouteConstants.fieldOfficerDashboard;
      default:
        return RouteConstants.citizenDashboard;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_agreeToTerms) {
      SnackbarUtils.showError(
          context, 'Please accept Terms & Conditions to proceed.');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final auth = context.read<AuthService>();
    final success = await auth.registerAccount(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      role: widget.role,
    );
    if (!mounted) return;
    if (!success) {
      SnackbarUtils.showError(
        context,
        auth.errorMessage ?? 'Could not create account.',
      );
      return;
    }
    SnackbarUtils.showSuccess(context, 'Account created successfully!');
    Navigator.pushNamedAndRemoveUntil(context, _homeRoute, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppAppBar(title: _title),
      body: AuthShell(
        title: _title,
        subtitle: '',
        icon: Icons.person_add_alt_1_rounded,
        accent: _accent,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthHero(
                    title: 'Create Account',
                    subtitle:
                        'Register with a valid email and password. You will use these details to sign in.',
                    icon: Icons.person_add_alt_1_rounded,
                    accent: _accent,
                  ),
                  const SizedBox(height: 28),
                  AppTextField(
                    label: 'Full Name',
                    hintText: 'Enter your full name',
                    controller: _nameController,
                    prefixIcon: Icon(Icons.person_outline_rounded,
                        color: _accent, size: 20),
                    validator: (val) =>
                        Validators.requiredField(val, 'Full Name is required'),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Email',
                    hintText: 'Enter your email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon:
                        Icon(Icons.email_outlined, color: _accent, size: 20),
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Mobile Number',
                    hintText: 'Enter 10-digit mobile number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon:
                        Icon(Icons.phone_outlined, color: _accent, size: 20),
                    validator: Validators.phone,
                  ),
                  const SizedBox(height: 16),
                  AppPasswordField(
                    label: 'Password',
                    hintText: 'Create password (min 6 chars)',
                    controller: _passwordController,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 16),
                  AppPasswordField(
                    label: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    controller: _confirmPasswordController,
                    validator: (val) => Validators.confirmPassword(
                        val, _passwordController.text),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _agreeToTerms,
                          activeColor: _accent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          onChanged: (val) =>
                              setState(() => _agreeToTerms = val ?? false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'I agree to Terms & Conditions and Privacy Policy',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  AppButton(
                    text: 'Register',
                    backgroundColor: _accent,
                    isLoading: auth.isLoading,
                    onPressed: _handleRegister,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? ',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 14)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: _accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
