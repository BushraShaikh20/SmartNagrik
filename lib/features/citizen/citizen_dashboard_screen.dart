import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/report_status.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_avatar.dart';
import '../../core/widgets/app_bottom_navigation.dart';
import '../../core/widgets/status_badge.dart';

class CitizenDashboardScreen extends StatefulWidget {
  const CitizenDashboardScreen({super.key});

  @override
  State<CitizenDashboardScreen> createState() => _CitizenDashboardScreenState();
}

class _CitizenDashboardScreenState extends State<CitizenDashboardScreen> {
  int _currentNavIndex = 0;

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      setState(() => _currentNavIndex = 0);
    } else if (index == 1) {
      Navigator.pushNamed(context, RouteConstants.myReports);
    } else if (index == 2) {
      Navigator.pushNamed(context, RouteConstants.reportProblem);
    } else if (index == 3) {
      Navigator.pushNamed(context, RouteConstants.notifications);
    } else if (index == 4) {
      Navigator.pushNamed(context, RouteConstants.menu);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final firestore = context.watch<FirestoreService>();
    final user = auth.currentUser;

    final myReports = firestore.reports
        .where((r) => r.citizenId == (user?.id ?? 'usr_rohan_101'))
        .toList();
    final totalCount = myReports.length;
    final inProgressCount = myReports
        .where((r) =>
            r.status == ReportStatus.inProgress ||
            r.status == ReportStatus.officerAssigned)
        .length;
    final resolvedCount = myReports
        .where((r) =>
            r.status == ReportStatus.resolved ||
            r.status == ReportStatus.closed ||
            r.status == ReportStatus.citizenVerified)
        .length;
    final pendingCount = myReports
        .where((r) =>
            r.status == ReportStatus.submitted ||
            r.status == ReportStatus.communityVerified)
        .length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Profile & Notifications Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, RouteConstants.profile),
                        child: AppAvatar(
                            name: user?.fullName ?? 'Rohan Sharma', radius: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${user?.fullName.split(' ').first ?? 'Rohan'} 👋',
                            style: AppTextStyles.titleLarge,
                          ),
                          Text(
                            'Citizen Reporter',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none_rounded,
                            size: 26, color: AppColors.textPrimary),
                        onPressed: () => Navigator.pushNamed(
                            context, RouteConstants.notifications),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 4 Stat Cards in 1 Container
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildStatItem(
                        'Total Reports', '$totalCount', AppColors.primary),
                    _buildDivider(),
                    _buildStatItem(
                        'In Progress', '$inProgressCount', AppColors.secondary),
                    _buildDivider(),
                    _buildStatItem(
                        'Resolved', '$resolvedCount', AppColors.primaryDark),
                    _buildDivider(),
                    _buildStatItem(
                        'Pending', '$pendingCount', AppColors.warning),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Emergency SOS & Report Problem Big Action Buttons
              Row(
                children: [
                  // Emergency SOS Button (Red)
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                            context, RouteConstants.emergencySos),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emergency,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.emergency_rounded, size: 20),
                            SizedBox(width: 6),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Emergency SOS',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Report Problem Button (Blue)
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                            context, RouteConstants.reportProblem),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.add_circle_outline_rounded, size: 20),
                            SizedBox(width: 6),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Report Problem',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Quick Actions Section Title
              Text('Quick Actions', style: AppTextStyles.titleMedium),
              const SizedBox(height: 16),

              // Quick Action Tiles Grid
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      title: 'My Reports',
                      subtitle: '$totalCount filed',
                      icon: Icons.assignment_outlined,
                      color: AppColors.primary,
                      onTap: () => Navigator.pushNamed(
                          context, RouteConstants.myReports),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionCard(
                      title: 'Nearby Issues',
                      subtitle: 'Explore map',
                      icon: Icons.map_outlined,
                      color: AppColors.secondary,
                      onTap: () => Navigator.pushNamed(
                          context, RouteConstants.nearbyIssues),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      title: 'Live Location',
                      subtitle: 'GPS tracker',
                      icon: Icons.my_location_rounded,
                      color: const Color(0xFF0EA5E9),
                      onTap: () => Navigator.pushNamed(
                          context, RouteConstants.selectLocation),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionCard(
                      title: 'My Impact',
                      subtitle: '120 points',
                      icon: Icons.military_tech_outlined,
                      color: const Color(0xFF8B5CF6),
                      onTap: () =>
                          Navigator.pushNamed(context, RouteConstants.myImpact),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _QuickActionCard(
                title: 'Rewards & Badges',
                subtitle: 'View your 3 earned achievements and rank',
                icon: Icons.emoji_events_outlined,
                color: const Color(0xFFF59E0B),
                onTap: () =>
                    Navigator.pushNamed(context, RouteConstants.rewardsBadges),
              ),
              const SizedBox(height: 28),

              // Recent Reports Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Reports', style: AppTextStyles.titleMedium),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, RouteConstants.myReports),
                    child: const Text('View All',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (myReports.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Text(
                        'No reports filed yet. Tap Report Problem to start.',
                        style: TextStyle(color: AppColors.textMuted)),
                  ),
                )
              else
                ...myReports.take(2).map((rep) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(14),
                        leading: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.report_outlined,
                              color: AppColors.primary),
                        ),
                        title: Text('#${rep.id} • ${rep.category}',
                            style: AppTextStyles.titleSmall),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(rep.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13)),
                            const SizedBox(height: 6),
                            StatusBadge(status: rep.status),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14, color: AppColors.textMuted),
                        onTap: () => Navigator.pushNamed(
                            context, RouteConstants.reportDetails,
                            arguments: rep),
                      ),
                    )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentNavIndex,
        onTap: _onBottomNavTapped,
        onCenterActionTap: () =>
            Navigator.pushNamed(context, RouteConstants.reportProblem),
        items: const [
          BottomNavItem(icon: Icons.home_rounded, label: 'Home'),
          BottomNavItem(icon: Icons.assignment_outlined, label: 'Reports'),
          BottomNavItem(icon: Icons.add, label: '', isCenterAction: true),
          BottomNavItem(
              icon: Icons.notifications_none_rounded, label: 'Alerts'),
          BottomNavItem(icon: Icons.grid_view_rounded, label: 'More'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 32,
      width: 1,
      color: AppColors.border,
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
