import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_button.dart';

class AppError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppError({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.emergency, size: 48),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              AppButton(text: 'Retry', onPressed: onRetry, width: 140, height: 40),
            ],
          ],
        ),
      ),
    );
  }
}
