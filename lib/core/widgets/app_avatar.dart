import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final String? url;
  final String name;
  final double radius;

  const AppAvatar({
    super.key,
    this.url,
    required this.name,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryLight.withValues(alpha: 0.25),
      child: Text(
        initials.isNotEmpty ? initials : 'SN',
        style: TextStyle(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}
