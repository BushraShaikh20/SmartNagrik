import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/report_status.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_navigation.dart';
import '../../core/widgets/greeting_header.dart';
import '../../core/widgets/status_badge.dart';

class AuthorityDashboardScreen extends StatefulWidget {
  const AuthorityDashboardScreen({super.key});

  @override
  State<AuthorityDashboardScreen> createState() =>
      _AuthorityDashboardScreenState();
}

class _AuthorityDashboardScreenState extends State<AuthorityDashboardScreen> {
  int _currentNavIndex = 0;

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      setState(() => _currentNavIndex = 0);
    } else if (index == 1) {
      Navigator.pushNamed(context, RouteConstants.allReportsAdmin);
    } else if (index == 2) {
      Navigator.pushNamed(context, RouteConstants.analytics);
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
    final allReports = firestore.reports;

    final totalCount = allReports.length;
    final inProgressCount = allReports
        .where((r) =>
            r.status == ReportStatus.inProgress ||
            r.status == ReportStatus.officerAssigned)
        .length;
    final resolvedCount = allReports
        .where((r) =>
            r.status == ReportStatus.resolved ||
            r.status == ReportStatus.closed)
        .length;
    final pendingCount = allReports
        .where((r) =>
            r.status == ReportStatus.submitted ||
            r.status == ReportStatus.communityVerified)
        .length;

    final requiringAttention = allReports
        .where((r) =>
            r.status == ReportStatus.submitted ||
            r.status == ReportStatus.communityVerified)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetingHeader(
                user: user,
                accentColor: AppColors.secondary,
              ),
              const SizedBox(height: 24),

              // Overview 4 Stats Card
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
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    _buildStat(
                        'Total Reports', '$totalCount', AppColors.primary),
                    _buildDivider(),
                    _buildStat(
                        'In Progress', '$inProgressCount', AppColors.secondary),
                    _buildDivider(),
                    _buildStat(
                        'Resolved', '$resolvedCount', AppColors.primaryDark),
                    _buildDivider(),
                    _buildStat('Pending', '$pendingCount', AppColors.warning),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Quick Actions
              Text('Quick Actions', style: AppTextStyles.titleMedium),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _ActionTile(
                      title: 'All Reports',
                      subtitle: '$totalCount total',
                      icon: Icons.list_alt_rounded,
                      color: AppColors.primary,
                      onTap: () => Navigator.pushNamed(
                          context, RouteConstants.allReportsAdmin),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionTile(
                      title: 'Assign Officer',
                      subtitle: 'Manage tasks',
                      icon: Icons.assignment_ind_outlined,
                      color: AppColors.secondary,
                      onTap: () => Navigator.pushNamed(
                          context, RouteConstants.assignOfficer),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActionTile(
                      title: 'Analytics',
                      subtitle: 'City trends',
                      icon: Icons.analytics_outlined,
                      color: const Color(0xFF8B5CF6),
                      onTap: () => Navigator.pushNamed(
                          context, RouteConstants.analytics),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionTile(
                      title: 'Heatmap',
                      subtitle: 'GIS hotspot',
                      icon: Icons.map_outlined,
                      color: const Color(0xFFF59E0B),
                      onTap: () =>
                          Navigator.pushNamed(context, RouteConstants.heatmap),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Reports Requiring Attention
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reports Requiring Attention',
                      style: AppTextStyles.titleMedium),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, RouteConstants.allReportsAdmin),
                    child: const Text('View All',
                        style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (requiringAttention.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Text('No reports requiring immediate attention.',
                        style: TextStyle(color: AppColors.textMuted)),
                  ),
                )
              else
                ...requiringAttention.map((rep) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(14),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('#${rep.id} • ${rep.category}',
                                style: AppTextStyles.titleSmall),
                            StatusBadge(status: rep.status),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(rep.title,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pushNamed(
                                      context, RouteConstants.verifyReportAdmin,
                                      arguments: rep),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    minimumSize: Size.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Verify / Review',
                                      style: TextStyle(fontSize: 12)),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () => Navigator.pushNamed(
                                      context, RouteConstants.assignOfficer,
                                      arguments: rep),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    side: const BorderSide(
                                        color: AppColors.primary),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    minimumSize: Size.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Assign Officer',
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentNavIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
          BottomNavItem(icon: Icons.assignment_outlined, label: 'Reports'),
          BottomNavItem(icon: Icons.analytics_outlined, label: 'Analytics'),
          BottomNavItem(
              icon: Icons.notifications_none_rounded, label: 'Alerts'),
          BottomNavItem(icon: Icons.grid_view_rounded, label: 'More'),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDivider() =>
      Container(height: 32, width: 1, color: AppColors.border);
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
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
                      borderRadius: BorderRadius.circular(12)),
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
