import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/report_status.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_chip.dart';
import '../../core/widgets/app_search_field.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/report_model.dart';

class AllReportsAdminScreen extends StatefulWidget {
  const AllReportsAdminScreen({super.key});

  @override
  State<AllReportsAdminScreen> createState() => _AllReportsAdminScreenState();
}

class _AllReportsAdminScreenState extends State<AllReportsAdminScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final firestore = context.watch<FirestoreService>();
    var reports = firestore.reports;

    if (_selectedFilter == 'Pending') {
      reports = reports.where((r) => r.status == ReportStatus.submitted || r.status == ReportStatus.communityVerified).toList();
    } else if (_selectedFilter == 'In Progress') {
      reports = reports.where((r) => r.status == ReportStatus.inProgress || r.status == ReportStatus.officerAssigned).toList();
    } else if (_selectedFilter == 'Resolved') {
      reports = reports.where((r) => r.status == ReportStatus.resolved || r.status == ReportStatus.closed).toList();
    }

    if (_searchQuery.isNotEmpty) {
      reports = reports.where((r) =>
          r.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.category.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'All Reports (Admin)'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppSearchField(
                hintText: 'Search report ID, title, or category...',
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['All', 'Pending', 'In Progress', 'Resolved'].map((f) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: AppChip(
                    label: f,
                    isSelected: _selectedFilter == f,
                    onTap: () => setState(() => _selectedFilter = f),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: reports.isEmpty
                  ? const EmptyState(
                      title: 'No reports found',
                      description: 'No civic reports match your filter criteria.',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final rep = reports[index];
                        return _AdminReportTile(report: rep);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminReportTile extends StatelessWidget {
  final ReportModel report;
  const _AdminReportTile({required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('#${report.id} • ${report.category}', style: AppTextStyles.titleSmall),
            StatusBadge(status: report.status),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(report.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 4),
            Text('By: ${report.citizenName} • ${AppDateUtils.timeAgo(report.createdAt)}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, RouteConstants.verifyReportAdmin, arguments: report),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Verify', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, RouteConstants.assignOfficer, arguments: report),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    side: const BorderSide(color: AppColors.secondary),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Assign Officer', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
        onTap: () => Navigator.pushNamed(context, RouteConstants.reportDetails, arguments: report),
      ),
    );
  }
}
