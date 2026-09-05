class AppStringUtils {
  static String generateReportId() {
    final rand = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();
    return 'SN$rand';
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}
