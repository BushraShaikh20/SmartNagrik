import 'package:flutter/material.dart';
import '../../core/services/location_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/snackbar_utils.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

class SavedLocationItem {
  final String id;
  final String title;
  final String area;
  final String fullAddress;
  final IconData icon;

  SavedLocationItem({
    required this.id,
    required this.title,
    required this.area,
    required this.fullAddress,
    required this.icon,
  });
}

class SavedLocationsScreen extends StatefulWidget {
  const SavedLocationsScreen({super.key});

  @override
  State<SavedLocationsScreen> createState() => _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends State<SavedLocationsScreen> {
  // Starts with 0 saved locations by default
  final List<SavedLocationItem> _locations = [];

  void _showAddLocationDialog() {
    final titleController = TextEditingController();
    final areaController = TextEditingController();
    final addressController = TextEditingController();
    String selectedTag = 'Home';
    IconData selectedIcon = Icons.home_rounded;

    final tags = [
      {'tag': 'Home', 'icon': Icons.home_rounded},
      {'tag': 'Work', 'icon': Icons.business_rounded},
      {'tag': "Parents' House", 'icon': Icons.family_restroom_rounded},
      {'tag': 'Shop / Business', 'icon': Icons.storefront_rounded},
      {'tag': 'Gym', 'icon': Icons.fitness_center_rounded},
      {'tag': 'Other', 'icon': Icons.location_on_rounded},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Add New Saved Location', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 6),
                  const Text(
                    'Save your frequent areas or relation addresses for 1-tap civic reporting and SOS.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 18),

                  // Relation / Category Tags
                  Text('Location Relation', style: AppTextStyles.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map((t) {
                      final isSel = selectedTag == t['tag'];
                      return ChoiceChip(
                        avatar: Icon(
                          t['icon'] as IconData,
                          size: 16,
                          color: isSel ? Colors.white : AppColors.primary,
                        ),
                        label: Text(t['tag'] as String),
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : AppColors.textPrimary,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        selected: isSel,
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.grey.shade100,
                        onSelected: (_) {
                          setModalState(() {
                            selectedTag = t['tag'] as String;
                            selectedIcon = t['icon'] as IconData;
                            titleController.text = selectedTag;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Area / Relation Title Field
                  Text('Area / Landmark Title', style: AppTextStyles.labelLarge),
                  const SizedBox(height: 8),
                  AppTextField(
                    hintText: 'e.g. Civil Lines, Ramdaspeth, Ward 12',
                    controller: areaController,
                    prefixIcon: const Icon(Icons.maps_home_work_outlined, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),

                  // Full Address Field
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Full Address', style: AppTextStyles.labelLarge),
                      TextButton.icon(
                        onPressed: () async {
                          final loc = await LocationService.getCurrentLocation();
                          addressController.text = loc.address;
                          if (areaController.text.isEmpty && loc.city != null) {
                            areaController.text = loc.city!;
                          }
                          setModalState(() {});
                        },
                        icon: const Icon(Icons.my_location_rounded, size: 14),
                        label: const Text('Use Live GPS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AppTextField(
                    hintText: 'Enter full street, building & pin code',
                    controller: addressController,
                    maxLines: 2,
                    prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  AppButton(
                    text: 'Save Location',
                    icon: Icons.bookmark_add_rounded,
                    onPressed: () {
                      if (areaController.text.trim().isEmpty && addressController.text.trim().isEmpty) {
                        SnackbarUtils.showError(ctx, 'Please enter an area or address');
                        return;
                      }

                      setState(() {
                        _locations.add(
                          SavedLocationItem(
                            id: 'loc_${DateTime.now().millisecondsSinceEpoch}',
                            title: titleController.text.trim().isNotEmpty
                                ? titleController.text.trim()
                                : selectedTag,
                            area: areaController.text.trim().isNotEmpty
                                ? areaController.text.trim()
                                : selectedTag,
                            fullAddress: addressController.text.trim().isNotEmpty
                                ? addressController.text.trim()
                                : areaController.text.trim(),
                            icon: selectedIcon,
                          ),
                        );
                      });

                      Navigator.pop(ctx);
                      SnackbarUtils.showSuccess(context, 'Location added to saved addresses!');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'Saved Locations',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt_rounded, color: AppColors.primary),
            tooltip: 'Add Location',
            onPressed: _showAddLocationDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddLocationDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Location', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _locations.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBackground,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_location_alt_outlined, color: AppColors.primary, size: 48),
                    ),
                    const SizedBox(height: 18),
                    Text('No Saved Locations Yet', style: AppTextStyles.titleMedium),
                    const SizedBox(height: 8),
                    const Text(
                      'Save your frequent areas, family houses, or office locations with custom relation tags for quick reporting.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _showAddLocationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text('Add Your First Location', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: _locations.length,
              itemBuilder: (context, index) {
                final loc = _locations[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBackground,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(loc.icon, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(loc.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    loc.area,
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              loc.fullAddress,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.grey, size: 20),
                        onPressed: () {
                          setState(() => _locations.removeAt(index));
                          SnackbarUtils.showInfo(context, 'Location removed');
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
