import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'Help & Support'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Frequently Asked Questions', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              _FaqTile(
                question: 'How do I report a pothole or civic issue?',
                answer: 'Tap "Report Problem" on the dashboard, select the category, provide a title/description, attach photos and choose the location on map.',
              ),
              _FaqTile(
                question: 'How does Emergency SOS work?',
                answer: 'Tapping SOS broadcasts your live GPS coordinates and emergency type to registered Smart Nagrik users and volunteers within a 2km radius.',
              ),
              _FaqTile(
                question: 'What happens after I verify a resolution?',
                answer: 'When the field officer resolves the issue, you will be prompted to verify the work proof. Once confirmed, the report is closed.',
              ),
              const SizedBox(height: 24),

              Text('Contact Official Support', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.email_outlined, color: AppColors.primary, size: 24),
                      ),
                      title: const Text('Official Support Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('workwithtanu@gmail.com', style: TextStyle(fontSize: 13, color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.send_rounded, size: 18, color: AppColors.primary),
                      onTap: () {
                        SnackbarUtils.showSuccess(context, 'Support email workwithtanu@gmail.com copied to clipboard');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              AppButton(
                text: 'Chat with AI Support Agent',
                backgroundColor: AppColors.secondary,
                icon: Icons.chat_bubble_outline_rounded,
                onPressed: () => SnackbarUtils.showInfo(context, 'Smart Nagrik AI Assistant is active to assist you.'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  const _FaqTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 14),
            child: Text(answer, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
