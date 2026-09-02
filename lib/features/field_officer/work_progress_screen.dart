import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/task_model.dart';

class WorkProgressScreen extends StatefulWidget {
  final TaskModel? task;
  const WorkProgressScreen({super.key, this.task});

  @override
  State<WorkProgressScreen> createState() => _WorkProgressScreenState();
}

class _WorkProgressScreenState extends State<WorkProgressScreen> {
  final TextEditingController _descController = TextEditingController(
    text: 'Work done: Cleaning the area and filling material.',
  );
  final TextEditingController _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _descController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    setState(() => _isLoading = true);
    final firestore = context.read<FirestoreService>();
    final task = widget.task ?? firestore.tasks.first;

    firestore.updateTaskProgress(
      reportId: task.reportId,
      progressNotes: _descController.text.trim(),
    );

    setState(() => _isLoading = false);
    if (mounted) {
      SnackbarUtils.showSuccess(
          context, 'Progress update submitted successfully!');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestore = context.watch<FirestoreService>();
    final currentTask = widget.task ?? firestore.tasks.first;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Work Progress'),
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
              Text('Status: In Progress',
                  style: AppTextStyles.labelLarge
                      .copyWith(color: AppColors.secondary)),
              const SizedBox(height: 24),
              Text('Progress Description', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              AppTextField(
                hintText: 'Describe current on-site progress...',
                controller: _descController,
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              Text('Add Photos (In-Progress Proof)',
                  style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt_outlined,
                          color: AppColors.primary, size: 28),
                      SizedBox(height: 4),
                      Text('Upload In-Progress Site Photos',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Notes (Optional)', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              AppTextField(
                hintText: 'Enter additional notes for admin...',
                controller: _noteController,
                maxLines: 2,
              ),
              const SizedBox(height: 36),
              AppButton(
                text: 'Submit Update',
                backgroundColor: AppColors.primary,
                isLoading: _isLoading,
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
