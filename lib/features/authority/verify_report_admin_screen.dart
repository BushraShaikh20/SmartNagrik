import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_outline_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/report_model.dart';

class VerifyReportAdminScreen extends StatefulWidget {
  final ReportModel? report;
  const VerifyReportAdminScreen({super.key, this.report});

  @override
  State<VerifyReportAdminScreen> createState() =>
      _VerifyReportAdminScreenState();
}

class _VerifyReportAdminScreenState extends State<VerifyReportAdminScreen> {
  final TextEditingController _fieldNoteController = TextEditingController();

  @override
  void dispose() {
    _fieldNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firestore = context.watch<FirestoreService>();
    final rep = widget.report != null
        ? firestore.reports.firstWhere((r) => r.id == widget.report!.id,
            orElse: () => widget.report!)
        : firestore.reports.first;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Verify Report'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('#${rep.id}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.primaryDark)),
                  StatusBadge(status: rep.status),
                ],
              ),
              const SizedBox(height: 12),
              Text(rep.title, style: AppTextStyles.titleMedium),
              const SizedBox(height: 6),
              Text(rep.description, style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              Text('Review Photos', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
                  child: Icon(Icons.image_outlined,
                      size: 44, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 20),
              Text('Location Details', style: AppTextStyles.labelLarge),
              const SizedBox(height: 6),
              Text(rep.location.address,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 24),
              Text('Admin Field Note (Optional)',
                  style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              AppTextField(
                hintText: 'Enter your verification or site inspection note...',
                controller: _fieldNoteController,
                maxLines: 3,
              ),
              const SizedBox(height: 36),
              AppButton(
                text: 'Verify & Approve Report',
                backgroundColor: AppColors.primary,
                icon: Icons.verified_outlined,
                onPressed: () {
                  context.read<FirestoreService>().verifyReportAdmin(rep.id,
                      adminNote: _fieldNoteController.text.trim());
                  SnackbarUtils.showSuccess(
                      context, 'Report verified successfully!');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              AppOutlineButton(
                text: 'Reject Report',
                color: AppColors.emergency,
                icon: Icons.cancel_outlined,
                onPressed: () {
                  context.read<FirestoreService>().rejectReportAdmin(
                      rep.id, 'Invalid report or duplicate entry.');
                  SnackbarUtils.showError(context, 'Report rejected.');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
