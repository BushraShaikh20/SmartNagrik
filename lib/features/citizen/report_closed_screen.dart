import 'package:flutter/material.dart';
import '../../core/constants/route_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_utils.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_outline_button.dart';
import '../../models/report_model.dart';

class ReportClosedScreen extends StatelessWidget {
  final ReportModel? report;
  const ReportClosedScreen({super.key, this.report});

  @override
  Widget build(BuildContext context) {
    final repId = report?.id ?? 'SN184152';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.task_alt_rounded, size: 72, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Thank You!\nThis report has been closed.',
                textAlign: TextAlign.center,
                style: AppTextStyles.displayMedium.copyWith(height: 1.2),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Report #$repId',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Closed on ${AppDateUtils.formatDateTime(DateTime.now())}',
                style: AppTextStyles.bodySmall,
              ),
              const Spacer(),
              AppButton(
                text: 'View Report Details',
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    RouteConstants.reportDetails,
                    arguments: report,
                  );
                },
              ),
              const SizedBox(height: 12),
              AppOutlineButton(
                text: 'Back to Dashboard',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteConstants.citizenDashboard,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
