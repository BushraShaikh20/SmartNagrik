import 'package:flutter/material.dart';

class SettingsService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _language = 'English';

  // 4 Granular, Independent Notification Channels
  bool _masterNotifications = true;
  bool _emergencyAlerts = true;
  bool _civicReportUpdates = true;
  bool _soundVibration = true;

  ThemeMode get themeMode => _themeMode;
  String get language => _language;
  bool get notificationsEnabled => _masterNotifications;
  bool get masterNotifications => _masterNotifications;
  bool get emergencyAlerts => _emergencyAlerts;
  bool get civicReportUpdates => _civicReportUpdates;
  bool get soundVibration => _soundVibration;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void toggleNotifications(bool enabled) {
    _masterNotifications = enabled;
    notifyListeners();
  }

  void setMasterNotifications(bool enabled) {
    _masterNotifications = enabled;
    notifyListeners();
  }

  void setEmergencyAlerts(bool enabled) {
    _emergencyAlerts = enabled;
    notifyListeners();
  }

  void setCivicReportUpdates(bool enabled) {
    _civicReportUpdates = enabled;
    notifyListeners();
  }

  void setSoundVibration(bool enabled) {
    _soundVibration = enabled;
    notifyListeners();
  }
}
