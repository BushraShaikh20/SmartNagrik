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
import '../../core/widgets/social_auth_buttons.dart';
import 'phone_auth_flow.dart';

class CitizenLoginScreen extends StatefulWidget {
  const CitizenLoginScreen({super.key});

  @override
  State<CitizenLoginScreen> createState() => _CitizenLoginScreenState();
}

class _CitizenLoginScreenState extends State<CitizenLoginScreen> {
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

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final auth = context.read<AuthService>();
    final success = await auth.loginAsCitizen(
      emailOrPhone: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;
    if (success) {
      final name = auth.currentUser?.fullName.trim();
      SnackbarUtils.showSuccess(
        context,
        (name == null || name.isEmpty) ? 'Welcome!' : 'Welcome, $name!',
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteConstants.citizenDashboard,
        (route) => false,
      );
    } else {
      SnackbarUtils.showError(
        context,
        auth.errorMessage ?? 'Invalid email or password. Please try again.',
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    final auth = context.read<AuthService>();
    final success = await auth.loginWithGoogle(UserRole.citizen);
    if (!mounted) return;
    if (!success) {
      SnackbarUtils.showError(
        context,
        auth.errorMessage ?? 'Google Sign-In failed.',
      );
      return;
    }
    SnackbarUtils.showSuccess(context, 'Signed in with Google');
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteConstants.citizenDashboard,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Citizen Login'),
      body: AuthShell(
        title: 'Welcome back',
        subtitle: '',
        icon: Icons.person_rounded,
        accent: AppColors.primary,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHero(
                    title: 'Welcome back',
                    subtitle:
                        'Sign in with your registered email and password to continue.',
                    icon: Icons.person_rounded,
                    accent: AppColors.primary,
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    label: 'Email Address',
                    hintText: 'Enter your registered email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: AppColors.primary, size: 20),
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 20),
                  AppPasswordField(
                    label: 'Password',
                    hintText: 'Enter your password',
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
                              activeColor: AppColors.primary,
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
                            'Remember me',
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
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  AppButton(
                    text: 'Login',
                    isLoading: auth.isLoading,
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 24),
                  SocialAuthButtons(
                    onGoogle: _handleGoogleLogin,
                    onPhone: () =>
                        startPhoneAuth(context, role: UserRole.citizen),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 14)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, RouteConstants.citizenRegister),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                      ),
                    ],
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
