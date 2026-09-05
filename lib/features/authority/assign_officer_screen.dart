import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/enums/report_priority.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/report_model.dart';

class AssignOfficerScreen extends StatefulWidget {
  final ReportModel? report;
  const AssignOfficerScreen({super.key, this.report});

  @override
  State<AssignOfficerScreen> createState() => _AssignOfficerScreenState();
}

class _AssignOfficerScreenState extends State<AssignOfficerScreen> {
  String? _selectedOfficer;
  ReportPriority _selectedPriority = ReportPriority.medium;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 3));
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Default to the registered field officer in the system
    _selectedOfficer = 'Rajesh Patil (rajesh.patil@smartnagrik.gov.in)';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _handleAssign() {
    final firestore = context.read<FirestoreService>();
    final rep = widget.report ??
        (firestore.reports.isNotEmpty
            ? firestore.reports.first
            : null);

    if (rep == null) {
      SnackbarUtils.showError(context, 'No report found to assign');
      return;
    }

    if (_selectedOfficer == null) {
      SnackbarUtils.showError(context, 'Please select an officer');
      return;
    }

    final officerName = _selectedOfficer!.split(' (').first;
    firestore.assignOfficer(
      reportId: rep.id,
      officerId: 'officer_rajesh_01',
      officerName: officerName,
      priority: _selectedPriority,
      dueDate: _dueDate,
      note: _noteController.text.trim(),
    );

    SnackbarUtils.showSuccess(
        context, '$officerName assigned to Report #${rep.id} successfully!');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthService>();
    final firestore = context.watch<FirestoreService>();
    final rep = widget.report ??
        (firestore.reports.isNotEmpty ? firestore.reports.first : null);

    // Only display the actual authenticated officer(s) in system
    final availableOfficers = [
      'Rajesh Patil (rajesh.patil@smartnagrik.gov.in)',
    ];

    if (_selectedOfficer == null && availableOfficers.isNotEmpty) {
      _selectedOfficer = availableOfficers.first;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Assign Field Officer'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (rep != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('#${rep.id} • ${rep.category}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              rep.priority.label,
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(rep.title, style: AppTextStyles.titleSmall),
                      const SizedBox(height: 4),
                      Text(rep.location.address,
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              Text('Active Registered Field Officer', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),

              if (availableOfficers.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Text(
                    'No active field officer currently registered in system.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                )
              else
                AppDropdown<String>(
                  label: '',
                  hintText: 'Select Officer',
                  value: _selectedOfficer,
                  items: availableOfficers
                      .map((o) => DropdownMenuItem(
                            value: o,
                            child: Text(o,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedOfficer = val);
                  },
                ),
              const SizedBox(height: 20),

              Text('Priority Level', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              Row(
                children: ReportPriority.values.map((p) {
                  final isSelected = _selectedPriority == p;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: InkWell(
                        onTap: () => setState(() => _selectedPriority = p),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.secondary
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: isSelected
                                    ? AppColors.secondary
                                    : AppColors.border),
                          ),
                          child: Center(
                            child: Text(
                              p.label,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              Text('Due Date', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 60)),
                  );
                  if (picked != null) setState(() => _dueDate = picked);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('dd MMMM, yyyy').format(_dueDate),
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const Icon(Icons.calendar_today_rounded,
                          size: 18, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text('Assignment Instructions (Optional)',
                  style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              AppTextField(
                hintText: 'Enter specific inspection guidelines or repair notes...',
                controller: _noteController,
                maxLines: 3,
              ),
              const SizedBox(height: 36),

              AppButton(
                text: 'Assign Field Officer',
                backgroundColor: AppColors.primary,
                icon: Icons.assignment_turned_in_rounded,
                onPressed: _handleAssign,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
