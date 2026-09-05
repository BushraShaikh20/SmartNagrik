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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF042F2E),
              Color(0xFF0F766E),
              Color(0xFFECFDF5),
            ],
            stops: [0.0, 0.38, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    height: 72,
                    width: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.shield_rounded,
                        color: AppColors.primary, size: 38),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Smart Nagrik',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Choose how you want to continue',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: ListView(
                    children: [
                      _RoleCard(
                        title: 'Citizen',
                        subtitle:
                            'Report civic issues, track resolution and use emergency SOS.',
                        icon: Icons.person_rounded,
                        iconColor: AppColors.primary,
                        onTap: () {
                          Navigator.pushNamed(
                              context, RouteConstants.citizenLogin);
                        },
                      ),
                      const SizedBox(height: 14),
                      _RoleCard(
                        title: 'Authorization',
                        subtitle:
                            'Review reports, assign officers and monitor city analytics.',
                        icon: Icons.admin_panel_settings_rounded,
                        iconColor: AppColors.secondary,
                        onTap: () {
                          Navigator.pushNamed(
                              context, RouteConstants.authorityLogin);
                        },
                      ),
                      const SizedBox(height: 14),
                      _RoleCard(
                        title: 'Field Officer',
                        subtitle:
                            'Resolve assigned tasks and upload on-ground progress.',
                        icon: Icons.engineering_rounded,
                        iconColor: AppColors.purple,
                        onTap: () {
                          Navigator.pushNamed(
                              context, RouteConstants.fieldOfficerLogin);
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      await context.read<AuthService>().continueAsGuest();
                      if (!context.mounted) return;
                      Navigator.pushReplacementNamed(
                          context, RouteConstants.citizenDashboard);
                    },
                    child: const Text(
                      'Continue as Guest',
                      style: TextStyle(
                        color: Color(0xFF064E3B),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
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
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
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
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_rounded,
                    size: 20, color: iconColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
