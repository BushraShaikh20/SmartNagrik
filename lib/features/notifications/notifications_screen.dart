import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/settings_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/widgets/app_app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    final isMasterOn = settings.masterNotifications;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'Notification Preferences'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Main Push Notification Switch
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isMasterOn
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : AppColors.border,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isMasterOn
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.03),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isMasterOn
                            ? AppColors.primaryBackground
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isMasterOn
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_off_rounded,
                        color: isMasterOn ? AppColors.primary : Colors.grey,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isMasterOn ? 'App Notifications Active' : 'App Notifications Turned Off',
                            style: AppTextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isMasterOn ? AppColors.textPrimary : AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isMasterOn
                                ? 'Global notification delivery enabled'
                                : 'Master switch muted',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isMasterOn,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) {
                        context.read<SettingsService>().setMasterNotifications(val);
                        SnackbarUtils.showSuccess(
                          context,
                          val ? 'App Notifications turned ON' : 'App Notifications turned OFF',
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Custom Channel Controls', style: AppTextStyles.titleSmall),
              const SizedBox(height: 12),

              // Individual Notification Channels Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    // Section 2: Emergency Alerts
                    SwitchListTile(
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: settings.emergencyAlerts
                              ? AppColors.emergencyLight
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.emergency_rounded,
                          color: settings.emergencyAlerts ? AppColors.emergency : Colors.grey,
                          size: 20,
                        ),
                      ),
                      title: const Text('Emergency SOS Alerts',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: const Text('Alerts from nearby citizens needing urgent help',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      value: settings.emergencyAlerts,
                      activeThumbColor: AppColors.emergency,
                      onChanged: (val) {
                        context.read<SettingsService>().setEmergencyAlerts(val);
                        SnackbarUtils.showInfo(
                          context,
                          val ? 'Emergency SOS Alerts turned ON' : 'Emergency SOS Alerts turned OFF',
                        );
                      },
                    ),
                    const Divider(height: 1),

                    // Section 3: Civic Report Status Updates
                    SwitchListTile(
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: settings.civicReportUpdates
                              ? AppColors.primaryBackground
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.assignment_outlined,
                          color: settings.civicReportUpdates ? AppColors.primary : Colors.grey,
                          size: 20,
                        ),
                      ),
                      title: const Text('Civic Report Status Updates',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: const Text('Updates when officer is assigned or issue resolved',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      value: settings.civicReportUpdates,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) {
                        context.read<SettingsService>().setCivicReportUpdates(val);
                        SnackbarUtils.showInfo(
                          context,
                          val ? 'Civic Report Updates turned ON' : 'Civic Report Updates turned OFF',
                        );
                      },
                    ),
                    const Divider(height: 1),

                    // Section 4: Sound & Vibration
                    SwitchListTile(
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: settings.soundVibration
                              ? Colors.purple.shade50
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.vibration_rounded,
                          color: settings.soundVibration ? Colors.purple : Colors.grey,
                          size: 20,
                        ),
                      ),
                      title: const Text('Sound & Vibration',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: const Text('Play chime & vibration on urgent municipal updates',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      value: settings.soundVibration,
                      activeThumbColor: Colors.purple,
                      onChanged: (val) {
                        context.read<SettingsService>().setSoundVibration(val);
                        SnackbarUtils.showInfo(
                          context,
                          val ? 'Sound & Vibration turned ON' : 'Sound & Vibration turned OFF',
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
