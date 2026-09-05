import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../models/emergency_model.dart';

class MyEmergencyScreen extends StatelessWidget {
  final EmergencyModel? emergency;
  const MyEmergencyScreen({super.key, this.emergency});

  @override
  Widget build(BuildContext context) {
    final firestore = context.watch<FirestoreService>();
    final active = emergency ??
        (firestore.emergencies.isNotEmpty ? firestore.emergencies.first : null);

    if (active == null) {
      return Scaffold(
        appBar: const AppAppBar(title: 'My Emergency'),
        body: const Center(child: Text('No active emergency SOS.')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'My Emergency'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Red Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.emergencyGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emergency.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.emergency_rounded,
                        color: Colors.white, size: 40),
                    const SizedBox(height: 10),
                    const Text('Emergency Active',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${active.type.label} Emergency',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatusInfo(
                            label: 'Nearby Users Notified',
                            value: '${active.usersNotifiedCount}'),
                        Container(width: 1, height: 28, color: Colors.white24),
                        _StatusInfo(
                            label: 'Help Offered',
                            value: '${active.responses.length}'),
                        Container(width: 1, height: 28, color: Colors.white24),
                        _StatusInfo(
                            label: 'Location Sharing',
                            value:
                                active.isLocationSharingActive ? 'ON' : 'OFF'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons: Update Emergency & Close Emergency
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Update SOS',
                      backgroundColor: AppColors.secondary,
                      onPressed: () => SnackbarUtils.showInfo(context,
                          'Broadcast updated with latest GPS location.'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: 'Close SOS',
                      backgroundColor: AppColors.emergencyDark,
                      onPressed: () {
                        firestore.closeEmergency(active.id);
                        SnackbarUtils.showSuccess(
                            context, 'Emergency marked as resolved.');
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Help Offered Responses List
              Text('Helpers Responded (${active.responses.length})',
                  style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),

              if (active.responses.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Text(
                        'Notified 8 nearby users. Waiting for responses...',
                        style: TextStyle(color: AppColors.textMuted)),
                  ),
                )
              else
                ...active.responses.map((resp) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(resp.helperName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              const Text('Just now',
                                  style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(resp.message,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary)),
                          if (resp.helperPhone != null) ...[
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.phone,
                                    size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(resp.helperPhone!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                        fontSize: 13)),
                              ],
                            ),
                          ],
                        ],
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusInfo extends StatelessWidget {
  final String label;
  final String value;
  const _StatusInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}
