import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/task_status.dart';
import '../../core/services/firestore_service.dart';
import '../../core/services/report_pdf_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../models/location_model.dart';
import '../../models/task_model.dart';

class TaskDetailsScreen extends StatelessWidget {
  final TaskModel? task;
  const TaskDetailsScreen({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    final firestore = context.watch<FirestoreService>();
    final currentTask = task != null
        ? firestore.tasks.firstWhere((t) => t.id == task!.id, orElse: () => task!)
        : (firestore.tasks.isNotEmpty
            ? firestore.tasks.first
            : TaskModel(
                id: 'TSK_DEMO',
                reportId: 'REP_DEMO',
                officerId: 'officer_01',
                officerName: 'Rajesh Patil',
                title: 'Road Repair Task',
                description: 'Municipal road repair and patch work.',
                location: const LocationModel(
                    latitude: 21.1458, longitude: 79.0882, address: 'Civil Lines, Nagpur'),
                issueImages: const [],
                status: TaskStatus.assigned,
                assignedAt: DateTime.now(),
                dueDate: DateTime.now().add(const Duration(days: 2)),
              ));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'Task Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined, color: AppColors.primary),
            tooltip: 'Print Task Certificate (PDF)',
            onPressed: () => ReportPdfService.printTaskCompletion(
              context: context,
              task: currentTask,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.primary),
            tooltip: 'Share Task PDF',
            onPressed: () => ReportPdfService.shareTaskCompletion(
              context: context,
              task: currentTask,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        Text('#${currentTask.reportId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark)),
                        Text(currentTask.status.label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(currentTask.title, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 6),
                    Text(currentTask.description, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 18, color: AppColors.textMuted),
                        const SizedBox(width: 6),
                        Expanded(child: Text(currentTask.location.address, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textMuted),
                        const SizedBox(width: 6),
                        Text('Assigned on: ${AppDateUtils.formatDateTime(currentTask.assignedAt)}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text('Issue Photos', style: AppTextStyles.titleSmall),
              const SizedBox(height: 10),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
                  child: Icon(Icons.image_outlined, size: 40, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 32),

              if (currentTask.status == TaskStatus.assigned) ...[
                AppButton(
                  text: 'Start Work',
                  backgroundColor: AppColors.primary,
                  icon: Icons.play_arrow_rounded,
                  onPressed: () {
                    Navigator.pushNamed(context, RouteConstants.workProgress, arguments: currentTask);
                  },
                ),
              ] else if (currentTask.status == TaskStatus.inProgress) ...[
                AppButton(
                  text: 'Update Work Progress',
                  backgroundColor: AppColors.secondary,
                  icon: Icons.edit_note_rounded,
                  onPressed: () {
                    Navigator.pushNamed(context, RouteConstants.workProgress, arguments: currentTask);
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Complete & Close Task',
                  backgroundColor: AppColors.primary,
                  icon: Icons.check_circle_rounded,
                  onPressed: () {
                    Navigator.pushNamed(context, RouteConstants.completeTask, arguments: currentTask);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
