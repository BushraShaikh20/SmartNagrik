import 'package:flutter/material.dart';
import '../../features/about/about_us_screen.dart';
import '../../features/authentication/authority_login_screen.dart';
import '../../features/authentication/citizen_login_screen.dart';
import '../../features/authentication/citizen_register_screen.dart';
import '../../features/authentication/field_officer_login_screen.dart';
import '../../features/authentication/forgot_password_screen.dart';
import '../../features/authentication/password_reset_success_screen.dart';
import '../../features/authentication/reset_password_screen.dart';
import '../../features/authentication/role_selection_screen.dart';
import '../../features/authentication/verify_otp_screen.dart';
import '../../features/authority/all_reports_admin_screen.dart';
import '../../features/authority/analytics_screen.dart';
import '../../features/authority/assign_officer_screen.dart';
import '../../features/authority/authority_dashboard_screen.dart';
import '../../features/authority/verify_report_admin_screen.dart';
import '../../features/citizen/citizen_dashboard_screen.dart';
import '../../features/citizen/citizen_verification_screen.dart';
import '../../features/citizen/my_impact_screen.dart';
import '../../features/citizen/my_reports_screen.dart';
import '../../features/citizen/report_closed_screen.dart';
import '../../features/citizen/rewards_badges_screen.dart';
import '../../features/emergency/emergency_nearby_screen.dart';
import '../../features/emergency/emergency_sos_screen.dart';
import '../../features/emergency/my_emergency_screen.dart';
import '../../features/emergency/offer_help_screen.dart';
import '../../features/field_officer/complete_task_screen.dart';
import '../../features/field_officer/field_officer_dashboard_screen.dart';
import '../../features/field_officer/my_tasks_screen.dart';
import '../../features/field_officer/task_details_screen.dart';
import '../../features/field_officer/work_progress_screen.dart';
import '../../features/help_support/help_support_screen.dart';
import '../../features/location/heatmap_screen.dart';
import '../../features/location/select_location_screen.dart';
import '../../features/menu/menu_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/emergency_contacts_screen.dart';
import '../../features/profile/my_profile_screen.dart';
import '../../features/profile/saved_locations_screen.dart';
import '../../features/reports/nearby_issues_screen.dart';
import '../../features/reports/report_details_screen.dart';
import '../../features/reports/report_problem_screen.dart';
import '../../features/reports/report_timeline_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../models/emergency_model.dart';
import '../../models/location_model.dart';
import '../../models/report_model.dart';
import '../../models/task_model.dart';
import '../constants/route_constants.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteConstants.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case RouteConstants.roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());
      
      // Auth
      case RouteConstants.citizenLogin:
        return MaterialPageRoute(builder: (_) => const CitizenLoginScreen());
      case RouteConstants.citizenRegister:
        return MaterialPageRoute(builder: (_) => const CitizenRegisterScreen());
      case RouteConstants.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case RouteConstants.verifyOtp:
        final destination = settings.arguments as String? ?? '+91 98765 43210';
        return MaterialPageRoute(builder: (_) => VerifyOtpScreen(destination: destination));
      case RouteConstants.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case RouteConstants.resetSuccess:
        return MaterialPageRoute(builder: (_) => const PasswordResetSuccessScreen());
      case RouteConstants.authorityLogin:
        return MaterialPageRoute(builder: (_) => const AuthorityLoginScreen());
      case RouteConstants.fieldOfficerLogin:
        return MaterialPageRoute(builder: (_) => const FieldOfficerLoginScreen());

      // Citizen
      case RouteConstants.citizenDashboard:
        return MaterialPageRoute(builder: (_) => const CitizenDashboardScreen());
      case RouteConstants.myReports:
        return MaterialPageRoute(builder: (_) => const MyReportsScreen());
      case RouteConstants.reportProblem:
        return MaterialPageRoute(builder: (_) => const ReportProblemScreen());
      case RouteConstants.selectLocation:
        final initialLoc = settings.arguments as LocationModel?;
        return MaterialPageRoute(builder: (_) => SelectLocationScreen(initialLocation: initialLoc));
      case RouteConstants.reportDetails:
        final report = settings.arguments as ReportModel?;
        return MaterialPageRoute(builder: (_) => ReportDetailsScreen(report: report));
      case RouteConstants.reportTimeline:
        final report = settings.arguments as ReportModel?;
        return MaterialPageRoute(builder: (_) => ReportTimelineScreen(report: report));
      case RouteConstants.citizenVerification:
        final report = settings.arguments as ReportModel?;
        return MaterialPageRoute(builder: (_) => CitizenVerificationScreen(report: report));
      case RouteConstants.reportClosed:
        final report = settings.arguments as ReportModel?;
        return MaterialPageRoute(builder: (_) => ReportClosedScreen(report: report));
      case RouteConstants.nearbyIssues:
        return MaterialPageRoute(builder: (_) => const NearbyIssuesScreen());
      case RouteConstants.myImpact:
        return MaterialPageRoute(builder: (_) => const MyImpactScreen());
      case RouteConstants.rewardsBadges:
        return MaterialPageRoute(builder: (_) => const RewardsBadgesScreen());

      // Emergency SOS
      case RouteConstants.emergencySos:
        return MaterialPageRoute(builder: (_) => const EmergencySosScreen());
      case RouteConstants.emergencyNearby:
        final emergency = settings.arguments as EmergencyModel?;
        return MaterialPageRoute(builder: (_) => EmergencyNearbyScreen(emergency: emergency));
      case RouteConstants.offerHelp:
        final emergency = settings.arguments as EmergencyModel?;
        return MaterialPageRoute(builder: (_) => OfferHelpScreen(emergency: emergency));
      case RouteConstants.myEmergency:
        final emergency = settings.arguments as EmergencyModel?;
        return MaterialPageRoute(builder: (_) => MyEmergencyScreen(emergency: emergency));

      // Authority (Admin)
      case RouteConstants.authorityDashboard:
        return MaterialPageRoute(builder: (_) => const AuthorityDashboardScreen());
      case RouteConstants.allReportsAdmin:
        return MaterialPageRoute(builder: (_) => const AllReportsAdminScreen());
      case RouteConstants.verifyReportAdmin:
        final report = settings.arguments as ReportModel?;
        return MaterialPageRoute(builder: (_) => VerifyReportAdminScreen(report: report));
      case RouteConstants.assignOfficer:
        final report = settings.arguments as ReportModel?;
        return MaterialPageRoute(builder: (_) => AssignOfficerScreen(report: report));
      case RouteConstants.analytics:
        return MaterialPageRoute(builder: (_) => const AnalyticsScreen());
      case RouteConstants.heatmap:
        return MaterialPageRoute(builder: (_) => const HeatmapScreen());

      // Field Officer
      case RouteConstants.fieldOfficerDashboard:
        return MaterialPageRoute(builder: (_) => const FieldOfficerDashboardScreen());
      case RouteConstants.myTasks:
        return MaterialPageRoute(builder: (_) => const MyTasksScreen());
      case RouteConstants.taskDetails:
        final task = settings.arguments as TaskModel?;
        return MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: task));
      case RouteConstants.workProgress:
        final task = settings.arguments as TaskModel?;
        return MaterialPageRoute(builder: (_) => WorkProgressScreen(task: task));
      case RouteConstants.completeTask:
        final task = settings.arguments as TaskModel?;
        return MaterialPageRoute(builder: (_) => CompleteTaskScreen(task: task));

      // Shared & Settings
      case RouteConstants.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case RouteConstants.profile:
        return MaterialPageRoute(builder: (_) => const MyProfileScreen());
      case RouteConstants.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case RouteConstants.emergencyContacts:
        return MaterialPageRoute(builder: (_) => const EmergencyContactsScreen());
      case RouteConstants.savedLocations:
        return MaterialPageRoute(builder: (_) => const SavedLocationsScreen());
      case RouteConstants.menu:
        return MaterialPageRoute(builder: (_) => const MenuScreen());
      case RouteConstants.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case RouteConstants.helpSupport:
        return MaterialPageRoute(builder: (_) => const HelpSupportScreen());
      case RouteConstants.aboutUs:
        return MaterialPageRoute(builder: (_) => const AboutUsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
