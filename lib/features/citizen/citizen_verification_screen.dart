import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_outline_button.dart';
import '../../models/report_model.dart';

class CitizenVerificationScreen extends StatelessWidget {
  final ReportModel? report;
  const CitizenVerificationScreen({super.key, this.report});

  @override
  Widget build(BuildContext context) {
    final rep = report ?? context.watch<FirestoreService>().reports.first;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Citizen Verification'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('#${rep.id}', style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Text('Has this issue been resolved?', style: AppTextStyles.displayMedium.copyWith(fontSize: 22)),
              const SizedBox(height: 8),
              Text(
                'Please verify the resolution proof submitted by the field officer for this civic issue.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Resolution Photo Proof Preview
              Text('Resolution Photos', style: AppTextStyles.labelLarge),
              const SizedBox(height: 10),
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.image_outlined, size: 48, color: AppColors.textMuted),
                      SizedBox(height: 8),
                      Text('Work Completed Photo Proof', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Officer Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Officer Resolution Note:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryDark)),
                    const SizedBox(height: 4),
                    Text(
                      rep.resolutionNote ?? 'Pothole filled and road surface tarred smoothly.',
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              AppButton(
                text: 'Confirm Resolved',
                backgroundColor: AppColors.primary,
                icon: Icons.check_circle_outline_rounded,
                onPressed: () {
                  context.read<FirestoreService>().confirmCitizenResolution(rep.id);
                  Navigator.pushReplacementNamed(context, RouteConstants.reportClosed, arguments: rep);
                },
              ),
              const SizedBox(height: 14),

              AppOutlineButton(
                text: 'Report Still Unresolved',
                color: AppColors.emergency,
                icon: Icons.cancel_outlined,
                onPressed: () {
                  context.read<FirestoreService>().markCitizenUnresolved(rep.id, 'Issue is not fixed properly.');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'If unresolved, report will be sent back to officer for review.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
