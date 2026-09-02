import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/user_role.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_avatar.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'More Menu'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // User Profile Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    AppAvatar(name: user?.fullName ?? 'User', radius: 26),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.fullName ?? 'User', style: AppTextStyles.titleMedium),
                          const SizedBox(height: 2),
                          Text(user?.email ?? '', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user?.role.label ?? 'Citizen',
                        style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Menu Options Group
              _MenuGroup(
                title: 'Account & Preferences',
                items: [
                  _MenuItem(
                    title: 'My Profile',
                    icon: Icons.person_outline_rounded,
                    onTap: () => Navigator.pushNamed(context, RouteConstants.profile),
                  ),
                  _MenuItem(
                    title: 'Settings & Appearance',
                    icon: Icons.settings_outlined,
                    onTap: () => Navigator.pushNamed(context, RouteConstants.settings),
                  ),
                  _MenuItem(
                    title: 'Notifications',
                    icon: Icons.notifications_none_rounded,
                    onTap: () => Navigator.pushNamed(context, RouteConstants.notifications),
                  ),
                  _MenuItem(
                    title: 'Emergency Contacts',
                    icon: Icons.emergency_outlined,
                    onTap: () => Navigator.pushNamed(context, RouteConstants.emergencyContacts),
                  ),
                  _MenuItem(
                    title: 'Saved Locations',
                    icon: Icons.location_on_outlined,
                    onTap: () => Navigator.pushNamed(context, RouteConstants.savedLocations),
                  ),
                  _MenuItem(
                    title: 'Rewards & Badges',
                    icon: Icons.emoji_events_outlined,
                    onTap: () => Navigator.pushNamed(context, RouteConstants.rewardsBadges),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _MenuGroup(
                title: 'Role Switcher (Demo)',
                items: [
                  _MenuItem(
                    title: 'Switch to Citizen Dashboard',
                    icon: Icons.person_rounded,
                    color: AppColors.primary,
                    onTap: () {
                      auth.switchRole(UserRole.citizen);
                      Navigator.pushNamedAndRemoveUntil(context, RouteConstants.citizenDashboard, (r) => false);
                    },
                  ),
                  _MenuItem(
                    title: 'Switch to Municipal Authority',
                    icon: Icons.admin_panel_settings_rounded,
                    color: AppColors.secondary,
                    onTap: () {
                      auth.switchRole(UserRole.authority);
                      Navigator.pushNamedAndRemoveUntil(context, RouteConstants.authorityDashboard, (r) => false);
                    },
                  ),
                  _MenuItem(
                    title: 'Switch to Field Officer',
                    icon: Icons.engineering_rounded,
                    color: AppColors.purple,
                    onTap: () {
                      auth.switchRole(UserRole.fieldOfficer);
                      Navigator.pushNamedAndRemoveUntil(context, RouteConstants.fieldOfficerDashboard, (r) => false);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _MenuGroup(
                title: 'Support & Information',
                items: [
                  _MenuItem(
                    title: 'Help & Support',
                    icon: Icons.help_outline_rounded,
                    onTap: () => Navigator.pushNamed(context, RouteConstants.helpSupport),
                  ),
                  _MenuItem(
                    title: 'About Smart Nagrik',
                    icon: Icons.info_outline_rounded,
                    onTap: () => Navigator.pushNamed(context, RouteConstants.aboutUs),
                  ),
                  _MenuItem(
                    title: 'Logout',
                    icon: Icons.logout_rounded,
                    color: AppColors.emergency,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          title: const Row(
                            children: [
                              Icon(Icons.logout_rounded,
                                  color: AppColors.emergency, size: 24),
                              SizedBox(width: 10),
                              Text('Log Out?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ],
                          ),
                          content: const Text(
                            'Are you sure you want to log out from Smart Nagrik?',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 14),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.emergency,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Navigator.pop(ctx);
                                auth.logout();
                                Navigator.pushNamedAndRemoveUntil(context,
                                    RouteConstants.roleSelection, (r) => false);
                              },
                              child: const Text('Log Out'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _MenuGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14, left: 16, bottom: 6),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textMuted)),
          ),
          ...items.map((item) => ListTile(
                leading: Icon(item.icon, color: item.color ?? AppColors.textPrimary, size: 22),
                title: Text(item.title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: item.color ?? AppColors.textPrimary)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                onTap: item.onTap,
              )),
        ],
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
  });
}
