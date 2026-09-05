import 'package:flutter/material.dart';
import '../../core/constants/route_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_outline_button.dart';
import '../../models/emergency_model.dart';

class EmergencyNearbyScreen extends StatelessWidget {
  final EmergencyModel? emergency;
  const EmergencyNearbyScreen({super.key, this.emergency});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Emergency Alert'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Urgent Alert Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.emergencyLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.emergency.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded, color: AppColors.emergency, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('⚠️ Emergency Nearby', style: TextStyle(color: AppColors.emergencyDark, fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('Someone in your vicinity urgently needs help.', style: TextStyle(color: AppColors.emergencyDark, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              Text('Type: Medical Emergency', style: AppTextStyles.titleLarge),
              const SizedBox(height: 12),

              Row(
                children: const [
                  Icon(Icons.near_me_rounded, color: AppColors.emergency, size: 20),
                  SizedBox(width: 8),
                  Text('Distance: 200 m away', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.access_time_rounded, color: AppColors.textMuted, size: 20),
                  SizedBox(width: 8),
                  Text('Reported: Just now', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Description:',
                style: AppTextStyles.labelLarge,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(14),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'Severe medical distress. Urgent ambulance or CPR trained volunteer requested at Civil Lines.',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
              ),
              const Spacer(),

              AppButton(
                text: 'Offer Help',
                backgroundColor: AppColors.primary,
                icon: Icons.volunteer_activism_rounded,
                onPressed: () {
                  Navigator.pushNamed(context, RouteConstants.offerHelp, arguments: emergency);
                },
              ),
              const SizedBox(height: 12),

              AppOutlineButton(
                text: 'View Emergency on Map',
                icon: Icons.map_outlined,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
