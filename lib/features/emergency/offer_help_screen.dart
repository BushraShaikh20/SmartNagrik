import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/emergency_model.dart';

class OfferHelpScreen extends StatefulWidget {
  final EmergencyModel? emergency;
  const OfferHelpScreen({super.key, this.emergency});

  @override
  State<OfferHelpScreen> createState() => _OfferHelpScreenState();
}

class _OfferHelpScreenState extends State<OfferHelpScreen> {
  final TextEditingController _msgController = TextEditingController(
    text: 'I can help, Please let me know how I can assist.',
  );
  bool _shareContact = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _sendOffer() async {
    setState(() => _isLoading = true);
    final auth = context.read<AuthService>();
    final firestore = context.read<FirestoreService>();
    final user = auth.currentUser;

    firestore.offerHelpForEmergency(
      emergencyId: widget.emergency?.id ?? 'EM1001',
      helperId: user?.id ?? 'usr_helper_01',
      helperName: user?.fullName ?? 'Rohan Sharma',
      helperPhone: _shareContact ? (user?.phone ?? '') : null,
      message: _msgController.text.trim(),
      shareContact: _shareContact,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      SnackbarUtils.showSuccess(
          context, 'Help offer sent to the person in emergency!');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Offer Help'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You are offering help for',
                  style: AppTextStyles.bodyMedium),
              const SizedBox(height: 4),
              Text('Medical Emergency',
                  style: AppTextStyles.displayMedium
                      .copyWith(color: AppColors.emergency)),
              const SizedBox(height: 28),

              Text('Message (optional)', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              AppTextField(
                hintText: 'Enter your message...',
                controller: _msgController,
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              // Share Contact Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_outlined,
                        color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Share Contact Number',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13)),
                          SizedBox(height: 2),
                          Text('Only shared if accepted by creator',
                              style: TextStyle(
                                  color: AppColors.textMuted, fontSize: 11)),
                        ],
                      ),
                    ),
                    Switch(
                      value: _shareContact,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) => setState(() => _shareContact = val),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              AppButton(
                text: 'Send Offer',
                backgroundColor: AppColors.primary,
                isLoading: _isLoading,
                onPressed: _sendOffer,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
