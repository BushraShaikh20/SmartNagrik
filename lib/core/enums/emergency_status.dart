enum EmergencyStatus {
  active('Emergency Active'),
  responding('Responding'),
  resolved('Resolved'),
  cancelled('Cancelled');

  final String label;
  const EmergencyStatus(this.label);

  static EmergencyStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'responding':
        return EmergencyStatus.responding;
      case 'resolved':
        return EmergencyStatus.resolved;
      case 'cancelled':
        return EmergencyStatus.cancelled;
      case 'active':
      default:
        return EmergencyStatus.active;
    }
  }
}
