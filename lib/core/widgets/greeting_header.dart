import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../constants/route_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/user_display.dart';
import 'app_avatar.dart';

class GreetingHeader extends StatelessWidget {
  final UserModel? user;
  final String? roleCaption;
  final Color accentColor;

  const GreetingHeader({
    super.key,
    required this.user,
    this.roleCaption,
    this.accentColor = AppColors.primaryDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.12),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, RouteConstants.profile),
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [accentColor, accentColor.withValues(alpha: 0.55)],
                ),
              ),
              child: AppAvatar(
                name: user.displayName,
                url: user?.photoUrl,
                radius: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${user.greetingFirstName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  roleCaption ?? user.roleCaption,
                  style: AppTextStyles.caption.copyWith(color: accentColor),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded,
                size: 26, color: AppColors.textPrimary),
            onPressed: () =>
                Navigator.pushNamed(context, RouteConstants.notifications),
          ),
        ],
      ),
    );
  }
}
