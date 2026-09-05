import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_search_field.dart';
import '../../models/location_model.dart';

class SelectLocationScreen extends StatefulWidget {
  final LocationModel? initialLocation;
  const SelectLocationScreen({super.key, this.initialLocation});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  late LatLng _selectedPosition;
  String _address = 'Civil Lines, Nagpur, Maharashtra 440001';
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _selectedPosition = LatLng(
      widget.initialLocation?.latitude ?? 21.1458,
      widget.initialLocation?.longitude ?? 79.0882,
    );
    _address = widget.initialLocation?.address ?? 'Civil Lines, Nagpur, Maharashtra 440001';
  }

  void _onPositionChanged(LatLng newPos) {
    setState(() {
      _selectedPosition = newPos;
      _address = 'Ward 12, (${newPos.latitude.toStringAsFixed(4)}, ${newPos.longitude.toStringAsFixed(4)}), Nagpur';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Select Location'),
      body: Stack(
        children: [
          // Flutter OpenStreetMap View
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedPosition,
              initialZoom: 15.0,
              onTap: (tapPosition, point) => _onPositionChanged(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.smartnagrik.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedPosition,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.location_pin,
                      size: 48,
                      color: AppColors.emergency,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Search Location Bar
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AppSearchField(
                hintText: 'Search landmark or address in Nagpur...',
                onChanged: (val) {},
              ),
            ),
          ),

          // Bottom Floating Address Card
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBackground,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text('Address', style: AppTextStyles.titleSmall),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _address,
                    style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Use This Location',
                    onPressed: () {
                      final loc = LocationModel(
                        latitude: _selectedPosition.latitude,
                        longitude: _selectedPosition.longitude,
                        address: _address,
                        city: 'Nagpur',
                        state: 'Maharashtra',
                      );
                      Navigator.pop(context, loc);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
