import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/settings_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/widgets/app_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _locationPermission = true;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: const AppAppBar(title: 'Settings'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Appearance & Theme', style: AppTextStyles.titleSmall),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.border),
                ),
                child: Row(
                  children: [
                    _ThemeOption(
                      title: 'Light',
                      icon: Icons.light_mode_outlined,
                      isSelected: settings.themeMode == ThemeMode.light,
                      onTap: () {
                        context.read<SettingsService>().setThemeMode(ThemeMode.light);
                        SnackbarUtils.showSuccess(context, 'Light mode applied');
                      },
                    ),
                    _ThemeOption(
                      title: 'Dark',
                      icon: Icons.dark_mode_outlined,
                      isSelected: settings.themeMode == ThemeMode.dark,
                      onTap: () {
                        context.read<SettingsService>().setThemeMode(ThemeMode.dark);
                        SnackbarUtils.showSuccess(context, 'Dark mode applied');
                      },
                    ),
                    _ThemeOption(
                      title: 'System',
                      icon: Icons.settings_brightness_outlined,
                      isSelected: settings.themeMode == ThemeMode.system,
                      onTap: () {
                        context.read<SettingsService>().setThemeMode(ThemeMode.system);
                        SnackbarUtils.showSuccess(context, 'System theme applied');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Language Preferences', style: AppTextStyles.titleSmall),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: settings.language,
                    isExpanded: true,
                    dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                    items: const [
                      DropdownMenuItem(value: 'English', child: Text('🇬🇧 English')),
                      DropdownMenuItem(value: 'Hindi', child: Text('🇮🇳 हिंदी (Hindi)')),
                      DropdownMenuItem(value: 'Marathi', child: Text('🇮🇳 मराठी (Marathi)')),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        context.read<SettingsService>().setLanguage(v);
                        SnackbarUtils.showSuccess(context, 'Language switched to $v');
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text('Permissions & Privacy', style: AppTextStyles.titleSmall),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.border),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Location Permission',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: const Text(
                          'Used for civic reporting and emergency SOS discovery',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      value: _locationPermission,
                      activeThumbColor: AppColors.primary,
                      onChanged: (v) => setState(() => _locationPermission = v),
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Push Notifications',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: const Text(
                          'Receive urgent status updates and field resolution notifications',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      value: settings.notificationsEnabled,
                      activeThumbColor: AppColors.primary,
                      onChanged: (v) {
                        context.read<SettingsService>().toggleNotifications(v);
                        SnackbarUtils.showInfo(context, v ? 'Notifications enabled' : 'Notifications disabled');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Data & Storage', style: AppTextStyles.titleSmall),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.border),
                ),
                child: ListTile(
                  title: const Text('Clear Cached Data',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: const Text(
                      '12.5 MB temporary offline map data & report images',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  trailing: TextButton(
                    onPressed: () => SnackbarUtils.showSuccess(
                        context, 'Cache cleared successfully!'),
                    child: const Text('Clear',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
