import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  const AppImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: AppColors.border,
        child: Image.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => Center(
            child: Icon(Icons.image_outlined, color: AppColors.textMuted, size: (height ?? 40) * 0.5),
          ),
        ),
      ),
    );
  }
}
