import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/report_status.dart';
import '../../core/services/firestore_service.dart';
import '../../core/services/report_pdf_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_outline_button.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/report_model.dart';

class ReportDetailsScreen extends StatelessWidget {
  final ReportModel? report;
  const ReportDetailsScreen({super.key, this.report});

  @override
  Widget build(BuildContext context) {
    final firestore = context.watch<FirestoreService>();
    final currentReport = report != null
        ? firestore.reports
            .firstWhere((r) => r.id == report!.id, orElse: () => report!)
        : firestore.reports.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'Report Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined,
                color: AppColors.textPrimary, size: 22),
            onPressed: () => ReportPdfService.shareReport(context, currentReport),
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined,
                color: AppColors.textPrimary, size: 22),
            onPressed: () => ReportPdfService.printReport(context, currentReport),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ID & Status Card
              Container(
                padding: const EdgeInsets.all(18),
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
                        Text('#${currentReport.id}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryDark,
                                fontSize: 16)),
                        StatusBadge(status: currentReport.status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(currentReport.title, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 6),
                    Text(currentReport.description,
                        style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: AppColors.textMuted, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            currentReport.location.address,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            color: AppColors.textMuted, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          AppDateUtils.formatDateTime(currentReport.createdAt),
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Photos Grid
              Text('Issue Photos', style: AppTextStyles.titleSmall),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _PhotoThumbnail(title: 'Report Photo 1'),
                    const SizedBox(width: 10),
                    _PhotoThumbnail(title: 'Report Photo 2'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Timeline Preview Card
              Container(
                padding: const EdgeInsets.all(18),
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
                        Text('Status Timeline',
                            style: AppTextStyles.titleSmall),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            RouteConstants.reportTimeline,
                            arguments: currentReport,
                          ),
                          child: const Text('View Full',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _TimelineMiniStep(
                      title: 'Report Submitted',
                      time:
                          AppDateUtils.formatDateTime(currentReport.createdAt),
                      isDone: true,
                    ),
                    _TimelineMiniStep(
                      title: 'Officer Assigned',
                      time: currentReport.assignedOfficerName ?? 'Rajesh Patil',
                      isDone: currentReport.status != ReportStatus.submitted,
                    ),
                    _TimelineMiniStep(
                      title: 'Work In Progress',
                      time: currentReport.status == ReportStatus.inProgress
                          ? 'Active'
                          : 'Pending',
                      isDone: currentReport.status == ReportStatus.inProgress ||
                          currentReport.status == ReportStatus.resolved ||
                          currentReport.status == ReportStatus.closed,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Citizen Verification Action Button if resolved
              if (currentReport.status == ReportStatus.resolved) ...[
                AppButton(
                  text: 'Verify Resolution',
                  backgroundColor: AppColors.primary,
                  icon: Icons.verified_outlined,
                  onPressed: () => Navigator.pushNamed(
                      context, RouteConstants.citizenVerification,
                      arguments: currentReport),
                ),
                const SizedBox(height: 12),
              ],

              // Action Buttons: Print Report, Cancel Report
              Row(
                children: [
                  Expanded(
                    child: AppOutlineButton(
                      text: 'Print Report',
                      icon: Icons.print_outlined,
                      onPressed: () => ReportPdfService.printReport(context, currentReport),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppOutlineButton(
                      text: 'Share Report',
                      icon: Icons.share_rounded,
                      color: AppColors.secondary,
                      onPressed: () => ReportPdfService.shareReport(context, currentReport),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoThumbnail extends StatelessWidget {
  final String title;
  const _PhotoThumbnail({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image_outlined, color: AppColors.textMuted),
            const SizedBox(height: 4),
            Text(title,
                style:
                    const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _TimelineMiniStep extends StatelessWidget {
  final String title;
  final String time;
  final bool isDone;
  final bool isLast;

  const _TimelineMiniStep({
    required this.title,
    required this.time,
    required this.isDone,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                color: isDone ? AppColors.primary : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 28,
                color: isDone ? AppColors.primary : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: isDone
                          ? AppColors.textPrimary
                          : AppColors.textMuted)),
              Text(time,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textMuted)),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
