import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/emergency_type.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../core/services/location_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/location_model.dart';

class EmergencySosScreen extends StatefulWidget {
  const EmergencySosScreen({super.key});

  @override
  State<EmergencySosScreen> createState() => _EmergencySosScreenState();
}

class _EmergencySosScreenState extends State<EmergencySosScreen> {
  EmergencyType _selectedType = EmergencyType.medical;
  final TextEditingController _descController = TextEditingController();
  bool _shareLocation = true;
  bool _isLoading = false;
  LocationModel _currentLocation = const LocationModel(
    latitude: 21.1458,
    longitude: 79.0882,
    address: 'Civil Lines, Nagpur, Maharashtra 440001',
  );

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  void _fetchLocation() async {
    final loc = await LocationService.getCurrentLocation();
    if (mounted) {
      setState(() => _currentLocation = loc);
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _sendEmergency() async {
    setState(() => _isLoading = true);
    final auth = context.read<AuthService>();
    final firestore = context.read<FirestoreService>();
    final user = auth.currentUser;

    final id = await firestore.triggerEmergency(
      userId: user?.id ?? 'usr_rohan_101',
      userName: user?.fullName ?? 'Rohan Sharma',
      userPhone: user?.phone ?? '',
      type: _selectedType,
      description: _descController.text.trim().isEmpty ? 'Urgent help required at location.' : _descController.text.trim(),
      location: _currentLocation,
    );

    setState(() => _isLoading = false);
    if (mounted) {
      SnackbarUtils.showSuccess(context, 'Emergency broadcast sent to nearby helpers!');
      final emergency = firestore.emergencies.firstWhere((e) => e.id == id);
      Navigator.pushReplacementNamed(context, RouteConstants.myEmergency, arguments: emergency);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Emergency SOS'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What happened?', style: AppTextStyles.titleLarge),
              const SizedBox(height: 6),
              Text('Select the nature of your emergency', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 20),

              // Emergency Type Selector Grid
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.05,
                children: [
                  _EmergencyTypeCard(
                    title: 'Medical',
                    icon: Icons.medical_services_rounded,
                    color: Colors.red,
                    isSelected: _selectedType == EmergencyType.medical,
                    onTap: () => setState(() => _selectedType = EmergencyType.medical),
                  ),
                  _EmergencyTypeCard(
                    title: 'Accident',
                    icon: Icons.car_crash_rounded,
                    color: Colors.amber.shade800,
                    isSelected: _selectedType == EmergencyType.accident,
                    onTap: () => setState(() => _selectedType = EmergencyType.accident),
                  ),
                  _EmergencyTypeCard(
                    title: 'Fire',
                    icon: Icons.local_fire_department_rounded,
                    color: Colors.deepOrange,
                    isSelected: _selectedType == EmergencyType.fire,
                    onTap: () => setState(() => _selectedType = EmergencyType.fire),
                  ),
                  _EmergencyTypeCard(
                    title: 'Flood',
                    icon: Icons.flood_rounded,
                    color: Colors.blue,
                    isSelected: _selectedType == EmergencyType.flood,
                    onTap: () => setState(() => _selectedType = EmergencyType.flood),
                  ),
                  _EmergencyTypeCard(
                    title: 'Crime',
                    icon: Icons.security_rounded,
                    color: Colors.purple,
                    isSelected: _selectedType == EmergencyType.crime,
                    onTap: () => setState(() => _selectedType = EmergencyType.crime),
                  ),
                  _EmergencyTypeCard(
                    title: 'Other',
                    icon: Icons.emergency_share_rounded,
                    color: Colors.grey.shade700,
                    isSelected: _selectedType == EmergencyType.other,
                    onTap: () => setState(() => _selectedType = EmergencyType.other),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              Text('Describe your emergency', style: AppTextStyles.titleSmall),
              const SizedBox(height: 8),
              AppTextField(
                hintText: 'Explain what happened and what kind of help you need urgently...',
                controller: _descController,
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Live Location Sharing Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.emergencyLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.share_location_rounded, color: AppColors.emergency, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Share Live Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(
                            _currentLocation.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _shareLocation,
                      activeThumbColor: AppColors.emergency,
                      onChanged: (val) => setState(() => _shareLocation = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              AppButton(
                text: 'Send Emergency SOS',
                backgroundColor: AppColors.emergency,
                icon: Icons.emergency_rounded,
                isLoading: _isLoading,
                onPressed: _sendEmergency,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyTypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _EmergencyTypeCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey.shade600, size: 30),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? color : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
