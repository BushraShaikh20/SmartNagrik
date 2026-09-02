enum ReportPriority {
  low('Low'),
  medium('Medium'),
  high('High'),
  urgent('Urgent');

  final String label;
  const ReportPriority(this.label);

  static ReportPriority fromString(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'low':
        return ReportPriority.low;
      case 'high':
        return ReportPriority.high;
      case 'urgent':
        return ReportPriority.urgent;
      case 'medium':
      default:
        return ReportPriority.medium;
    }
  }
}
