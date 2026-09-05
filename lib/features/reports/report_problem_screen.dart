import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../core/services/image_service.dart';
import '../../core/services/location_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/location_model.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final ImageService _imageService = ImageService();

  String _selectedCategory = 'Pothole';
  final List<String> _categories = [
    'Pothole',
    'Garbage & Sanitation',
    'Streetlight',
    'Water Leakage',
    'Drainage & Sewage',
    'Road Damage & Footpath',
    'Tree Fall / Encroachment',
    'Traffic Light & Signals',
    'Other Civic Issue',
  ];

  final List<String> _photos = [];
  LocationModel _location = const LocationModel(
    latitude: 21.1458,
    longitude: 79.0882,
    address: 'Civil Lines, Nagpur, Maharashtra 440001',
    city: 'Nagpur',
    state: 'Maharashtra',
  );
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  void _fetchLocation() async {
    final loc = await LocationService.getCurrentLocation();
    if (mounted) {
      setState(() => _location = loc);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _addFromCamera() async {
    final path = await _imageService.pickFromCamera();
    if (path != null) {
      setState(() => _photos.add(path));
    }
  }

  void _addFromGallery() async {
    final paths = await _imageService.pickMultiFromGallery();
    if (paths.isNotEmpty) {
      setState(() => _photos.addAll(paths));
    }
  }

  void _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);
      final auth = context.read<AuthService>();
      final firestore = context.read<FirestoreService>();
      final user = auth.currentUser;

      final reportId = await firestore.submitReport(
        citizenId: user?.id ?? 'usr_rohan_101',
        citizenName: user?.fullName ?? 'Rohan Sharma',
        category: _selectedCategory,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        location: _location,
        imagePaths: _photos,
      );

      setState(() => _isSubmitting = false);

      if (mounted) {
        SnackbarUtils.showSuccess(
            context, 'Report #$reportId submitted successfully!');
        final report = firestore.reports.firstWhere((r) => r.id == reportId);
        Navigator.pushReplacementNamed(context, RouteConstants.reportDetails,
            arguments: report);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Report Problem'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDropdown<String>(
                  label: 'Category',
                  hintText: 'Select Category',
                  value: _selectedCategory,
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCategory = val);
                  },
                ),
                const SizedBox(height: 18),

                AppTextField(
                  label: 'Title',
                  hintText:
                      'Enter issue title (e.g. Large pothole on main road)',
                  controller: _titleController,
                  validator: (val) =>
                      Validators.requiredField(val, 'Title is required'),
                ),
                const SizedBox(height: 18),

                AppTextField(
                  label: 'Description',
                  hintText: 'Describe the civic issue in detail...',
                  controller: _descController,
                  maxLines: 4,
                  validator: (val) =>
                      Validators.requiredField(val, 'Description is required'),
                ),
                const SizedBox(height: 20),

                // Add Photos Section
                Text('Add Photos', style: AppTextStyles.labelLarge),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _PhotoButton(
                      label: 'Camera',
                      icon: Icons.camera_alt_outlined,
                      onTap: _addFromCamera,
                    ),
                    const SizedBox(width: 12),
                    _PhotoButton(
                      label: 'Gallery',
                      icon: Icons.photo_library_outlined,
                      onTap: _addFromGallery,
                    ),
                  ],
                ),
                if (_photos.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _photos.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:
                                  const Icon(Icons.image, color: Colors.grey),
                            ),
                            Positioned(
                              top: 2,
                              right: 10,
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _photos.removeAt(index)),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.close,
                                      size: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Location Section
                Text('Location', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              color: AppColors.primary, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _location.address,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final selected = await Navigator.pushNamed(
                                  context,
                                  RouteConstants.selectLocation,
                                  arguments: _location,
                                );
                                if (selected != null &&
                                    selected is LocationModel) {
                                  setState(() => _location = selected);
                                }
                              },
                              icon: const Icon(Icons.map_outlined, size: 16),
                              label: const Text('Select on Map',
                                  style: TextStyle(fontSize: 12)),
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                AppButton(
                  text: 'Submit Report',
                  isLoading: _isSubmitting,
                  onPressed: _handleSubmit,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PhotoButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
