import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/task_status.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_chip.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/task_model.dart';

class MyTasksScreen extends StatefulWidget {
  const MyTasksScreen({super.key});

  @override
  State<MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  String _selectedFilter = 'Assigned';

  @override
  Widget build(BuildContext context) {
    final firestore = context.watch<FirestoreService>();
    var tasks = firestore.tasks;

    if (_selectedFilter == 'Assigned') {
      tasks = tasks.where((t) => t.status == TaskStatus.assigned).toList();
    } else if (_selectedFilter == 'In Progress') {
      tasks = tasks.where((t) => t.status == TaskStatus.inProgress).toList();
    } else if (_selectedFilter == 'Completed') {
      tasks = tasks.where((t) => t.status == TaskStatus.completed).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'My Tasks'),
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: ['Assigned', 'In Progress', 'Completed'].map((f) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: AppChip(
                      label: f,
                      isSelected: _selectedFilter == f,
                      onTap: () => setState(() => _selectedFilter = f),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: tasks.isEmpty
                  ? const EmptyState(
                      title: 'No tasks found',
                      description: 'No tasks currently under this category.',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return _TaskTile(task: task);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final TaskModel task;
  const _TaskTile({required this.task});

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
            Text('#${task.reportId}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            Text(task.priority.label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 12)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(task.title, style: AppTextStyles.titleSmall),
            const SizedBox(height: 4),
            Text(task.location.address, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 8),
            Text('Due Date: ${AppDateUtils.formatDate(task.dueDate)}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
        onTap: () => Navigator.pushNamed(context, RouteConstants.taskDetails, arguments: task),
      ),
    );
  }
}
