import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/task_model.dart';

class CompleteTaskScreen extends StatefulWidget {
  final TaskModel? task;
  const CompleteTaskScreen({super.key, this.task});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  final TextEditingController _descController = TextEditingController(
    text: 'Pothole repaired successfully. Road surface cleared and leveled.',
  );
  bool _isLoading = false;

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _handleComplete() async {
    setState(() => _isLoading = true);
    final firestore = context.read<FirestoreService>();
    final task = widget.task ?? firestore.tasks.first;

    firestore.completeTask(
      reportId: task.reportId,
      completionNotes: _descController.text.trim(),
    );

    setState(() => _isLoading = false);
    if (mounted) {
      SnackbarUtils.showSuccess(
          context, 'Task completed and submitted for citizen verification!');
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestore = context.watch<FirestoreService>();
    final currentTask = widget.task ?? firestore.tasks.first;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Complete Task'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('#${currentTask.reportId}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.primaryDark)),
              const SizedBox(height: 6),
              Text('Complete & Resolve Civic Issue',
                  style: AppTextStyles.titleMedium),
              const SizedBox(height: 24),
              Text('Completion Description', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              AppTextField(
                hintText:
                    'Describe how the issue was fixed and material used...',
                controller: _descController,
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              Text('Upload Completion Proof Photos',
                  style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_photo_alternate_outlined,
                          color: AppColors.primary, size: 36),
                      SizedBox(height: 6),
                      Text('Upload After-Resolution Proof Photos',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Completion Time', style: AppTextStyles.labelLarge),
              const SizedBox(height: 6),
              Text(DateFormat('dd MMMM, yyyy - hh:mm a').format(DateTime.now()),
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 36),
              AppButton(
                text: 'Submit & Close Task',
                backgroundColor: AppColors.primary,
                icon: Icons.check_circle_rounded,
                isLoading: _isLoading,
                onPressed: _handleComplete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
