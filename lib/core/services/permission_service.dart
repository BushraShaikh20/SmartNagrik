import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestLocationPermission() async {
    try {
      final status = await Permission.location.request();
      return status.isGranted;
    } catch (_) {
      return true; // Fallback
    }
  }

  static Future<bool> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return status.isGranted;
    } catch (_) {
      return true;
    }
  }

  static Future<bool> requestNotificationPermission() async {
    try {
      final status = await Permission.notification.request();
      return status.isGranted;
    } catch (_) {
      return true;
    }
  }
}
