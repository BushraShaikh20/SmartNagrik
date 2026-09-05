import 'package:latlong2/latlong.dart';
import '../../models/location_model.dart';

class MapService {
  static LatLng locationToLatLng(LocationModel loc) {
    return LatLng(loc.latitude, loc.longitude);
  }

  static LocationModel latLngToLocation(LatLng latLng, [String? address]) {
    return LocationModel(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      address: address ?? 'Selected Location (${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)})',
      city: 'Nagpur',
      state: 'Maharashtra',
      postalCode: '440001',
    );
  }

  // Pre-configured heatmap clusters in city
  static List<LatLng> getHeatmapPoints() {
    return const [
      LatLng(21.1458, 79.0882),
      LatLng(21.1462, 79.0890),
      LatLng(21.1470, 79.0875),
      LatLng(21.1500, 79.0920),
      LatLng(21.1515, 79.0940),
      LatLng(21.1390, 79.0810),
      LatLng(21.1380, 79.0830),
      LatLng(21.1550, 79.0790),
      LatLng(21.1600, 79.0850),
    ];
  }
}
