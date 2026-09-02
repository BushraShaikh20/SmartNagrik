import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/services/firestore_service.dart';
import '../../core/services/location_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_app_bar.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/location_model.dart';
import '../../models/report_model.dart';

class NearbyIssuesScreen extends StatefulWidget {
  const NearbyIssuesScreen({super.key});

  @override
  State<NearbyIssuesScreen> createState() => _NearbyIssuesScreenState();
}

class _NearbyIssuesScreenState extends State<NearbyIssuesScreen> {
  final MapController _mapController = MapController();
  LocationModel _userLocation = const LocationModel(
    latitude: 21.1458,
    longitude: 79.0882,
    address: 'Civil Lines, Nagpur, Maharashtra 440001',
  );
  String _selectedCategory = 'All Categories';
  ReportModel? _selectedReport;
  bool _isLoadingLocation = true;

  final List<String> _categories = [
    'All Categories',
    'Pothole',
    'Garbage',
    'Streetlight',
    'Water Leakage',
    'Drainage',
  ];

  @override
  void initState() {
    super.initState();
    _fetchLiveLocation();
  }

  Future<void> _fetchLiveLocation() async {
    setState(() => _isLoadingLocation = true);
    final loc = await LocationService.getCurrentLocation();
    if (mounted) {
      setState(() {
        _userLocation = loc;
        _isLoadingLocation = false;
      });
      _mapController.move(LatLng(loc.latitude, loc.longitude), 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestore = context.watch<FirestoreService>();
    final allReports = firestore.reports.where((rep) {
      if (_selectedCategory == 'All Categories') return true;
      return rep.category.toLowerCase() == _selectedCategory.toLowerCase();
    }).toList();

    final userLatLng = LatLng(_userLocation.latitude, _userLocation.longitude);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppAppBar(
        title: 'Nearby Issues & Live GPS',
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_rounded, color: AppColors.primary),
            tooltip: 'Recenter to Live GPS',
            onPressed: _fetchLiveLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          // OpenStreetMap with Civic Markers & Live User Location
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: userLatLng,
              initialZoom: 14.5,
              onTap: (_, __) => setState(() => _selectedReport = null),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.smartnagrik.app',
              ),
              MarkerLayer(
                markers: [
                  // Live User Location Marker (Pulsing Blue)
                  Marker(
                    point: userLatLng,
                    width: 50,
                    height: 50,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.withValues(alpha: 0.25),
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.shade700,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Issue Report Markers
                  ...allReports.map((rep) {
                    final isSelected = _selectedReport?.id == rep.id;
                    final distanceMeters = LocationService.getDistanceBetween(
                      startLat: _userLocation.latitude,
                      startLng: _userLocation.longitude,
                      endLat: rep.location.latitude,
                      endLng: rep.location.longitude,
                    );
                    final distanceStr = LocationService.formatDistance(distanceMeters);

                    return Marker(
                      point: LatLng(rep.location.latitude, rep.location.longitude),
                      width: isSelected ? 52 : 44,
                      height: isSelected ? 52 : 44,
                      child: Tooltip(
                        message: '${rep.title} ($distanceStr)',
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedReport = rep),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: rep.category == 'Pothole'
                                  ? Colors.orange
                                  : rep.category == 'Garbage'
                                      ? Colors.red
                                      : rep.category == 'Streetlight'
                                          ? Colors.amber.shade700
                                          : rep.category == 'Water Leakage'
                                              ? Colors.blue
                                              : AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Colors.yellowAccent : Colors.white,
                                width: isSelected ? 3 : 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.location_on_rounded,
                                color: Colors.white,
                                size: isSelected ? 28 : 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // Top Floating Bar: Live GPS Info & Category Filter
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Live GPS Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isLoadingLocation ? Colors.orange : Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _isLoadingLocation
                              ? 'Locating your live GPS...'
                              : 'Live GPS: ${LocationService.formatCoordinates(_userLocation.latitude, _userLocation.longitude)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                      Text(
                        '${allReports.length} Nearby',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Category Filter Pills
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSel = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat,
                              style: TextStyle(
                                color: isSel ? Colors.white : AppColors.textPrimary,
                                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                fontSize: 12,
                              )),
                          selected: isSel,
                          selectedColor: AppColors.primary,
                          backgroundColor: Colors.white,
                          elevation: 2,
                          onSelected: (_) => setState(() => _selectedCategory = cat),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Bottom Floating Selected Report Card
          if (_selectedReport != null)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  RouteConstants.reportDetails,
                  arguments: _selectedReport,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _selectedReport!.category,
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          StatusBadge(status: _selectedReport!.status),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _selectedReport!.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _selectedReport!.location.address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            LocationService.formatDistance(
                              LocationService.getDistanceBetween(
                                startLat: _userLocation.latitude,
                                startLng: _userLocation.longitude,
                                endLat: _selectedReport!.location.latitude,
                                endLng: _selectedReport!.location.longitude,
                              ),
                            ),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text('View Full Details',
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
