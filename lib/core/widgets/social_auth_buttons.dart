import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'google_logo.dart';

class SocialAuthButtons extends StatelessWidget {
  final VoidCallback? onGoogle;
  final VoidCallback? onPhone;
  final Color accent;

  const SocialAuthButtons({
    super.key,
    this.onGoogle,
    this.onPhone,
    this.accent = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('or continue with', style: AppTextStyles.bodySmall),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        if (onGoogle != null)
          SizedBox(
            height: 52,
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                side: const BorderSide(color: AppColors.border, width: 1.2),
                backgroundColor: Colors.white,
              ),
              onPressed: onGoogle,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GoogleLogo(size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Continue with Google',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (onPhone != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                side: BorderSide(color: accent.withValues(alpha: 0.35), width: 1.2),
                backgroundColor: accent.withValues(alpha: 0.04),
              ),
              onPressed: onPhone,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sms_outlined, color: accent, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Continue with OTP',
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
