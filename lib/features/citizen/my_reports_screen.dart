import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/report_status.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_chip.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/report_model.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final firestore = context.watch<FirestoreService>();
    final user = auth.currentUser;

    var reports = firestore.reports.where((r) => r.citizenId == (user?.id ?? 'usr_rohan_101')).toList();

    if (_selectedFilter == 'Pending') {
      reports = reports.where((r) => r.status == ReportStatus.submitted || r.status == ReportStatus.communityVerified).toList();
    } else if (_selectedFilter == 'In Progress') {
      reports = reports.where((r) => r.status == ReportStatus.inProgress || r.status == ReportStatus.officerAssigned).toList();
    } else if (_selectedFilter == 'Resolved') {
      reports = reports.where((r) => r.status == ReportStatus.resolved || r.status == ReportStatus.closed || r.status == ReportStatus.citizenVerified).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'My Reports'),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: ['All', 'Pending', 'In Progress', 'Resolved'].map((tab) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: AppChip(
                      label: tab,
                      isSelected: _selectedFilter == tab,
                      onTap: () => setState(() => _selectedFilter = tab),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Report List
            Expanded(
              child: reports.isEmpty
                  ? EmptyState(
                      title: 'No reports yet',
                      description: 'Tap + to report your first civic problem in your neighborhood.',
                      buttonText: 'Report a Problem',
                      onButtonPressed: () => Navigator.pushNamed(context, RouteConstants.reportProblem),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final rep = reports[index];
                        return _ReportCard(report: rep);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.pushNamed(context, RouteConstants.reportProblem),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final ReportModel report;

  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, RouteConstants.reportDetails, arguments: report),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('#${report.id}', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark, fontSize: 14)),
                    StatusBadge(status: report.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(report.title, style: AppTextStyles.titleSmall),
                const SizedBox(height: 4),
                Text(
                  report.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        report.location.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppDateUtils.timeAgo(report.createdAt),
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
