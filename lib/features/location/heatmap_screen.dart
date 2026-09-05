import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/services/map_service.dart';
import '../../core/widgets/app_app_bar.dart';

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  State<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  String _category = 'All Categories';
  String _period = 'Last 30 Days';

  @override
  Widget build(BuildContext context) {
    final heatmapPoints = MapService.getHeatmapPoints();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppAppBar(title: 'Heatmap Analytics'),
      body: Stack(
        children: [
          // Heatmap Map Overlay
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(21.1458, 79.0882),
              initialZoom: 13.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.smartnagrik.app',
              ),
              CircleLayer(
                circles: heatmapPoints.map((pt) {
                  return CircleMarker(
                    point: pt,
                    radius: 45,
                    useRadiusInMeter: false,
                    color: Colors.red.withValues(alpha: 0.35),
                    borderColor: Colors.amber.withValues(alpha: 0.6),
                    borderStrokeWidth: 2,
                  );
                }).toList(),
              ),
            ],
          ),

          // Filters Header
          Positioned(
            top: 14,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6)
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _category,
                        isExpanded: true,
                        items: [
                          'All Categories',
                          'Potholes',
                          'Garbage',
                          'Streetlights'
                        ]
                            .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c,
                                    style: const TextStyle(fontSize: 12))))
                            .toList(),
                        onChanged: (v) => setState(() => _category = v!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6)
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _period,
                        isExpanded: true,
                        items: ['Last 7 Days', 'Last 30 Days', 'This Year']
                            .map((p) => DropdownMenuItem(
                                value: p,
                                child: Text(p,
                                    style: const TextStyle(fontSize: 12))))
                            .toList(),
                        onChanged: (v) => setState(() => _period = v!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
