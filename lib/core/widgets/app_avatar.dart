import 'dart:io';

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

  bool get _hasLocalFile {
    final path = url?.trim() ?? '';
    if (path.isEmpty) return false;
    if (path.startsWith('http://') || path.startsWith('https://')) return false;
    return File(path).existsSync();
  }

  bool get _hasNetwork {
    final path = url?.trim() ?? '';
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .map((e) => e[0])
        .take(2)
        .join()
        .toUpperCase();

    ImageProvider? image;
    if (_hasNetwork) {
      image = NetworkImage(url!);
    } else if (_hasLocalFile) {
      image = FileImage(File(url!));
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryLight.withValues(alpha: 0.25),
      backgroundImage: image,
      child: image == null
          ? Text(
              initials.isNotEmpty ? initials : 'SN',
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
                fontSize: radius * 0.72,
              ),
            )
          : null,
    );
  }
}
