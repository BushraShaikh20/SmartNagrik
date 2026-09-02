import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/user_role.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shield_rounded,
                      color: AppColors.primary, size: 36),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text('Choose Your Role',
                    style: AppTextStyles.displayMedium),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Select how you want to use Smart Nagrik',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              const SizedBox(height: 36),

              // Citizen Card
              _RoleCard(
                title: 'Citizen',
                subtitle:
                    'Report civic issues, track real-time resolution and trigger emergency SOS.',
                icon: Icons.person_rounded,
                iconColor: AppColors.primary,
                onTap: () {
                  Navigator.pushNamed(context, RouteConstants.citizenLogin);
                },
              ),
              const SizedBox(height: 16),

              // Authorization Card
              _RoleCard(
                title: 'Authorization',
                subtitle:
                    'Municipal admin login: Review, verify, assign tasks and monitor city analytics.',
                icon: Icons.admin_panel_settings_rounded,
                iconColor: AppColors.secondary,
                onTap: () {
                  Navigator.pushNamed(context, RouteConstants.authorityLogin);
                },
              ),
              const SizedBox(height: 16),

              // Field Officer Card
              _RoleCard(
                title: 'Field Officer',
                subtitle:
                    'On-ground officer login: Resolve assigned tasks, upload work progress & photos.',
                icon: Icons.engineering_rounded,
                iconColor: AppColors.purple,
                onTap: () {
                  Navigator.pushNamed(
                      context, RouteConstants.fieldOfficerLogin);
                },
              ),

              const Spacer(),

              // Continue as Guest
              Center(
                child: TextButton(
                  onPressed: () {
                    context.read<AuthService>().switchRole(UserRole.guest);
                    Navigator.pushReplacementNamed(
                        context, RouteConstants.citizenDashboard);
                  },
                  child: const Text(
                    'Continue as Guest',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
