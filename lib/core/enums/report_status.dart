enum ReportStatus {
  submitted('Submitted'),
  communityVerified('Community Verified'),
  officerAssigned('Officer Assigned'),
  inProgress('In Progress'),
  resolved('Resolved'),
  citizenVerified('Citizen Verified'),
  closed('Closed'),
  rejected('Rejected');

  final String label;
  const ReportStatus(this.label);

  static ReportStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'communityverified':
      case 'community_verified':
        return ReportStatus.communityVerified;
      case 'officerassigned':
      case 'officer_assigned':
        return ReportStatus.officerAssigned;
      case 'inprogress':
      case 'in_progress':
        return ReportStatus.inProgress;
      case 'resolved':
        return ReportStatus.resolved;
      case 'citizenverified':
      case 'citizen_verified':
        return ReportStatus.citizenVerified;
      case 'closed':
        return ReportStatus.closed;
      case 'rejected':
        return ReportStatus.rejected;
      case 'submitted':
      case 'pending':
      default:
        return ReportStatus.submitted;
    }
  }
}
