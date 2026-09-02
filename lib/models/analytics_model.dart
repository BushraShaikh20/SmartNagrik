class AnalyticsModel {
  final int totalReports;
  final int pendingReports;
  final int inProgressReports;
  final int resolvedReports;
  final Map<String, int> reportsByCategory;
  final Map<String, int> monthlyTrends;

  const AnalyticsModel({
    this.totalReports = 142,
    this.pendingReports = 28,
    this.inProgressReports = 45,
    this.resolvedReports = 69,
    this.reportsByCategory = const {
      'Pothole': 48,
      'Garbage': 34,
      'Streetlight': 26,
      'Water Leakage': 18,
      'Drainage': 16,
    },
    this.monthlyTrends = const {
      'Jan': 18,
      'Feb': 24,
      'Mar': 32,
      'Apr': 28,
      'May': 40,
    },
  });

  Map<String, dynamic> toMap() {
    return {
      'totalReports': totalReports,
      'pendingReports': pendingReports,
      'inProgressReports': inProgressReports,
      'resolvedReports': resolvedReports,
      'reportsByCategory': reportsByCategory,
      'monthlyTrends': monthlyTrends,
    };
  }

  factory AnalyticsModel.fromMap(Map<String, dynamic> map) {
    return AnalyticsModel(
      totalReports: (map['totalReports'] as num?)?.toInt() ?? 142,
      pendingReports: (map['pendingReports'] as num?)?.toInt() ?? 28,
      inProgressReports: (map['inProgressReports'] as num?)?.toInt() ?? 45,
      resolvedReports: (map['resolvedReports'] as num?)?.toInt() ?? 69,
      reportsByCategory: (map['reportsByCategory'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toInt()),
          ) ??
          const {
            'Pothole': 48,
            'Garbage': 34,
            'Streetlight': 26,
            'Water Leakage': 18,
            'Drainage': 16,
          },
      monthlyTrends: (map['monthlyTrends'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toInt()),
          ) ??
          const {
            'Jan': 18,
            'Feb': 24,
            'Mar': 32,
            'Apr': 28,
            'May': 40,
          },
    );
  }
}
