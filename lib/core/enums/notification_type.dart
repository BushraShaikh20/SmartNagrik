enum NotificationType {
  reportResolved('Report Resolved'),
  officerAssigned('Officer Assigned'),
  progressUpdated('Progress Updated'),
  emergencyNearby('Emergency Nearby'),
  verificationRequired('Verification Required'),
  system('System');

  final String label;
  const NotificationType(this.label);

  static NotificationType fromString(String? type) {
    switch (type?.toLowerCase()) {
      case 'officerassigned':
      case 'officer_assigned':
        return NotificationType.officerAssigned;
      case 'progressupdated':
      case 'progress_updated':
        return NotificationType.progressUpdated;
      case 'emergencynearby':
      case 'emergency_nearby':
        return NotificationType.emergencyNearby;
      case 'verificationrequired':
      case 'verification_required':
        return NotificationType.verificationRequired;
      case 'system':
        return NotificationType.system;
      case 'reportresolved':
      case 'report_resolved':
      default:
        return NotificationType.reportResolved;
    }
  }
}
