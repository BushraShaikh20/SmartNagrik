import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/user_role.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/auth_shell.dart';
import '../../models/otp_args.dart';

class VerifyOtpScreen extends StatefulWidget {
  final OtpArgs args;
  const VerifyOtpScreen({super.key, required this.args});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _resendSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendSeconds = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  String get _homeRoute {
    switch (widget.args.role) {
      case UserRole.authority:
        return RouteConstants.authorityDashboard;
      case UserRole.fieldOfficer:
        return RouteConstants.fieldOfficerDashboard;
      default:
        return RouteConstants.citizenDashboard;
    }
  }

  Future<void> _verifyOtp() async {
    if (_code.length != 6) {
      SnackbarUtils.showError(context, 'Enter the 6-digit OTP.');
      return;
    }
    final auth = context.read<AuthService>();
    final success = await auth.verifyPhoneOtp(
      smsCode: _code,
      expectedRole: widget.args.role,
      fullName: widget.args.fullName,
    );
    if (!mounted) return;
    if (!success) {
      SnackbarUtils.showError(
        context,
        auth.errorMessage ?? 'Invalid OTP. Please try again.',
      );
      return;
    }
    if (widget.args.purpose == OtpPurpose.passwordReset) {
      Navigator.pushReplacementNamed(context, RouteConstants.resetPassword);
      return;
    }
    Navigator.pushNamedAndRemoveUntil(context, _homeRoute, (r) => false);
  }

  Future<void> _resend() async {
    final auth = context.read<AuthService>();
    final sent = await auth.sendPhoneOtp(widget.args.destination);
    if (!mounted) return;
    if (sent) {
      _startTimer();
      SnackbarUtils.showSuccess(context, 'OTP sent again');
    } else {
      SnackbarUtils.showError(
        context,
        auth.errorMessage ?? 'Could not resend OTP.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Verify OTP'),
      body: AuthShell(
        title: 'Enter Verification Code',
        subtitle: '',
        icon: Icons.sms_outlined,
        accent: AppColors.primary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthHero(
                  title: 'Enter Verification Code',
                  subtitle: '',
                  icon: Icons.sms_outlined,
                  accent: AppColors.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the 6-digit OTP sent to ${widget.args.destination}',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 46,
                      height: 54,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                          if (_code.length == 6) {
                            _verifyOtp();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                Center(
                  child: _resendSeconds > 0
                      ? Text(
                          'Resend OTP in 00:${_resendSeconds.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        )
                      : GestureDetector(
                          onTap: _resend,
                          child: const Text(
                            'Resend OTP',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                        ),
                ),
                const SizedBox(height: 36),
                AppButton(
                  text: 'Verify OTP',
                  isLoading: auth.isLoading,
                  onPressed: _verifyOtp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
