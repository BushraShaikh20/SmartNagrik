import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_avatar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthService>().currentUser;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImagePath = picked.path);
      if (mounted) {
        SnackbarUtils.showSuccess(context, 'Profile picture updated');
      }
    }
  }

  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = context.read<AuthService>().currentUser;
      await context.read<AuthService>().updateProfile(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            photoUrl: _selectedImagePath ?? user?.photoUrl,
          );
      if (mounted) {
        SnackbarUtils.showSuccess(
            context, 'Profile details saved successfully!');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'My Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture with Tap to Change
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 108,
                          height: 108,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: _selectedImagePath != null
                              ? ClipOval(
                                  child: Image.file(
                                    File(_selectedImagePath!),
                                    width: 108,
                                    height: 108,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : AppAvatar(
                                  name: _nameController.text.isNotEmpty
                                      ? _nameController.text
                                      : (user?.fullName ?? 'User'),
                                  radius: 54,
                                ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(Icons.camera_alt_rounded,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                    label: const Text('Change Profile Picture',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 28),

                // Name Input
                Text('Full Name', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                AppTextField(
                  hintText: 'Enter your full name',
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outline_rounded,
                      color: AppColors.primary),
                  validator: (val) =>
                      Validators.requiredField(val, 'Please enter your name'),
                ),
                const SizedBox(height: 20),

                // Contact Number Input
                Text('Contact Number', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                AppTextField(
                  hintText: 'Enter your mobile number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined,
                      color: AppColors.primary),
                ),
                const SizedBox(height: 20),

                // Email Input
                Text('Email Address', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                AppTextField(
                  hintText: 'Enter your email address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: AppColors.primary),
                  validator: Validators.email,
                ),
                const SizedBox(height: 36),

                // Save Profile Button
                AppButton(
                  text: 'Save Changes',
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: _handleSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
