class AppSettingsModel {
  final String themeMode;
  final String language;
  final bool locationPermissionGranted;
  final bool pushNotificationsEnabled;

  const AppSettingsModel({
    this.themeMode = 'system',
    this.language = 'English',
    this.locationPermissionGranted = true,
    this.pushNotificationsEnabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode,
      'language': language,
      'locationPermissionGranted': locationPermissionGranted,
      'pushNotificationsEnabled': pushNotificationsEnabled,
    };
  }

  factory AppSettingsModel.fromMap(Map<String, dynamic> map) {
    return AppSettingsModel(
      themeMode: map['themeMode'] as String? ?? 'system',
      language: map['language'] as String? ?? 'English',
      locationPermissionGranted: map['locationPermissionGranted'] as bool? ?? true,
      pushNotificationsEnabled: map['pushNotificationsEnabled'] as bool? ?? true,
    );
  }

  AppSettingsModel copyWith({
    String? themeMode,
    String? language,
    bool? locationPermissionGranted,
    bool? pushNotificationsEnabled,
  }) {
    return AppSettingsModel(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      locationPermissionGranted:
          locationPermissionGranted ?? this.locationPermissionGranted,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
    );
  }
}
