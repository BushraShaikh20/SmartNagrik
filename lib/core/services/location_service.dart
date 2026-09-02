import 'package:geolocator/geolocator.dart';
import '../../models/location_model.dart';
import '../constants/app_constants.dart';

class LocationService {
  static Future<LocationModel> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _defaultLocation();
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _defaultLocation();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _defaultLocation();
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      );

      final latStr = position.latitude.toStringAsFixed(4);
      final lngStr = position.longitude.toStringAsFixed(4);

      return LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        address: 'Live GPS: $latStr, $lngStr • Civil Lines, Nagpur 440001',
        city: 'Nagpur',
        state: 'Maharashtra',
        postalCode: '440001',
      );
    } catch (e) {
      return _defaultLocation();
    }
  }

  static double getDistanceBetween({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }

  static String formatCoordinates(double lat, double lng) {
    final latDir = lat >= 0 ? 'N' : 'S';
    final lngDir = lng >= 0 ? 'E' : 'W';
    return '${lat.abs().toStringAsFixed(5)}° $latDir, ${lng.abs().toStringAsFixed(5)}° $lngDir';
  }

  static LocationModel _defaultLocation() {
    return const LocationModel(
      latitude: AppConstants.defaultLatitude,
      longitude: AppConstants.defaultLongitude,
      address: AppConstants.defaultAddress,
      city: AppConstants.defaultCity,
      state: AppConstants.defaultState,
      postalCode: '440001',
    );
  }
}
