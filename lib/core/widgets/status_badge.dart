import 'package:flutter/material.dart';
import '../enums/report_status.dart';
import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final ReportStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (status) {
      case ReportStatus.submitted:
        bg = AppColors.warningLight;
        text = const Color(0xFFB45309);
        break;
      case ReportStatus.communityVerified:
        bg = AppColors.infoLight;
        text = const Color(0xFF0E7490);
        break;
      case ReportStatus.officerAssigned:
        bg = AppColors.purpleLight;
        text = const Color(0xFF6D28D9);
        break;
      case ReportStatus.inProgress:
        bg = AppColors.secondaryLight;
        text = AppColors.secondary;
        break;
      case ReportStatus.resolved:
      case ReportStatus.citizenVerified:
      case ReportStatus.closed:
        bg = AppColors.primaryBackground;
        text = AppColors.primaryDark;
        break;
      case ReportStatus.rejected:
        bg = AppColors.emergencyLight;
        text = AppColors.emergencyDark;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
