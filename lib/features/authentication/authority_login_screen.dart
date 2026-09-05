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

class AuthorityLoginScreen extends StatefulWidget {
  const AuthorityLoginScreen({super.key});

  @override
  State<AuthorityLoginScreen> createState() => _AuthorityLoginScreenState();
}

class _AuthorityLoginScreenState extends State<AuthorityLoginScreen> {
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
    final success = await auth.loginAsAuthority(
      emailOrPhone: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) return;
    if (success) {
      SnackbarUtils.showSuccess(context, 'Signed in');
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteConstants.authorityDashboard,
        (route) => false,
      );
    } else {
      SnackbarUtils.showError(
        context,
        auth.errorMessage ?? 'Invalid email or password.',
      );
    }
  }

  Future<void> _handleGoogle() async {
    final auth = context.read<AuthService>();
    final success = await auth.loginWithGoogle(UserRole.authority);
    if (!mounted) return;
    if (!success) {
      SnackbarUtils.showError(
          context, auth.errorMessage ?? 'Google Sign-In failed.');
      return;
    }
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteConstants.authorityDashboard,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Authorization Login'),
      body: AuthShell(
        title: 'Municipal Portal',
        subtitle: '',
        icon: Icons.admin_panel_settings_rounded,
        accent: AppColors.secondary,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHero(
                    title: 'Municipal Portal',
                    subtitle:
                        'Sign in with your official credentials. Only registered authority accounts can access this dashboard.',
                    icon: Icons.admin_panel_settings_rounded,
                    accent: AppColors.secondary,
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    label: 'Official Email',
                    hintText: 'Enter your municipal email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.admin_panel_settings_outlined,
                        color: AppColors.secondary, size: 20),
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
                              activeColor: AppColors.secondary,
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
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    text: 'Access Authority Dashboard',
                    backgroundColor: AppColors.secondary,
                    isLoading: auth.isLoading,
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 24),
                  SocialAuthButtons(
                    accent: AppColors.secondary,
                    onGoogle: _handleGoogle,
                    onPhone: () =>
                        startPhoneAuth(context, role: UserRole.authority),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 14)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, RouteConstants.authorityRegister),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                              color: AppColors.secondary,
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
