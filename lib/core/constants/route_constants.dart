class RouteConstants {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  
  // Auth
  static const String citizenLogin = '/auth/citizen-login';
  static const String citizenRegister = '/auth/citizen-register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String resetSuccess = '/auth/reset-success';
  static const String authorityLogin = '/auth/authority-login';
  static const String authorityRegister = '/auth/authority-register';
  static const String fieldOfficerLogin = '/auth/officer-login';
  static const String fieldOfficerRegister = '/auth/officer-register';

  // Citizen
  static const String citizenDashboard = '/citizen/dashboard';
  static const String myReports = '/citizen/my-reports';
  static const String reportProblem = '/citizen/report-problem';
  static const String selectLocation = '/citizen/select-location';
  static const String reportDetails = '/citizen/report-details';
  static const String reportTimeline = '/citizen/report-timeline';
  static const String citizenVerification = '/citizen/verify-resolution';
  static const String reportClosed = '/citizen/report-closed';
  static const String nearbyIssues = '/citizen/nearby-issues';
  static const String myImpact = '/citizen/my-impact';
  static const String rewardsBadges = '/citizen/rewards-badges';

  // Emergency SOS
  static const String emergencySos = '/emergency/sos';
  static const String emergencyNearby = '/emergency/nearby';
  static const String offerHelp = '/emergency/offer-help';
  static const String myEmergency = '/emergency/my-emergency';

  // Authority (Admin)
  static const String authorityDashboard = '/authority/dashboard';
  static const String allReportsAdmin = '/authority/all-reports';
  static const String verifyReportAdmin = '/authority/verify-report';
  static const String assignOfficer = '/authority/assign-officer';
  static const String analytics = '/authority/analytics';
  static const String heatmap = '/authority/heatmap';

  // Field Officer
  static const String fieldOfficerDashboard = '/officer/dashboard';
  static const String myTasks = '/officer/my-tasks';
  static const String taskDetails = '/officer/task-details';
  static const String workProgress = '/officer/work-progress';
  static const String completeTask = '/officer/complete-task';

  // Shared / Settings
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String emergencyContacts = '/profile/emergency-contacts';
  static const String savedLocations = '/profile/saved-locations';
  static const String menu = '/menu';
  static const String settings = '/settings';
  static const String helpSupport = '/help-support';
  static const String aboutUs = '/about-us';
}
