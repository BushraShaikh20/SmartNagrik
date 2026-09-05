import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../models/report_model.dart';

class ReportTimelineScreen extends StatelessWidget {
  final ReportModel? report;
  const ReportTimelineScreen({super.key, this.report});

  @override
  Widget build(BuildContext context) {
    final firestore = context.watch<FirestoreService>();
    final currentReport = report != null
        ? firestore.reports
            .firstWhere((r) => r.id == report!.id, orElse: () => report!)
        : firestore.reports.first;

    final steps = [
      {
        'title': 'Report Submitted',
        'desc': 'Civic report logged by citizen',
        'done': true
      },
      {
        'title': 'Community Verified',
        'desc': 'Verified by municipal portal',
        'done': true
      },
      {
        'title': 'Officer Assigned',
        'desc': 'Rajesh Patil assigned for on-ground work',
        'done': true
      },
      {
        'title': 'Work In Progress',
        'desc': 'Cleaning area and filling material',
        'done': true
      },
      {
        'title': 'Resolved',
        'desc': 'Officer submits completion proof photos',
        'done': currentReport.status.index >= 4
      },
      {
        'title': 'Citizen Verified',
        'desc': 'Citizen reviews and confirms resolution',
        'done': currentReport.status.index >= 5
      },
      {
        'title': 'Closed',
        'desc': 'Report successfully resolved & closed',
        'done': currentReport.status.index >= 6
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppAppBar(title: 'Timeline #${currentReport.id}'),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            final s = steps[index];
            final bool isDone = s['done'] as bool;
            final bool isLast = index == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color:
                            isDone ? AppColors.primary : Colors.grey.shade200,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isDone ? AppColors.primary : Colors.grey.shade400,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          isDone ? Icons.check : Icons.circle,
                          size: isDone ? 16 : 8,
                          color: isDone ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2.5,
                        height: 54,
                        color:
                            isDone ? AppColors.primary : Colors.grey.shade300,
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s['title'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isDone
                                ? AppColors.textPrimary
                                : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s['desc'] as String,
                          style: TextStyle(
                            color: isDone
                                ? AppColors.textSecondary
                                : AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
