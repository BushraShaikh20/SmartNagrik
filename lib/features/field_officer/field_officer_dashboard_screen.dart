import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/task_status.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_utils.dart';
import '../../core/widgets/app_bottom_navigation.dart';
import '../../core/widgets/greeting_header.dart';

class FieldOfficerDashboardScreen extends StatefulWidget {
  const FieldOfficerDashboardScreen({super.key});

  @override
  State<FieldOfficerDashboardScreen> createState() =>
      _FieldOfficerDashboardScreenState();
}

class _FieldOfficerDashboardScreenState
    extends State<FieldOfficerDashboardScreen> {
  int _currentNavIndex = 0;

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      setState(() => _currentNavIndex = 0);
    } else if (index == 1) {
      Navigator.pushNamed(context, RouteConstants.myTasks);
    } else if (index == 2) {
      Navigator.pushNamed(context, RouteConstants.notifications);
    } else if (index == 3) {
      Navigator.pushNamed(context, RouteConstants.menu);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final firestore = context.watch<FirestoreService>();
    final user = auth.currentUser;
    final tasks = firestore.tasks;

    final assignedCount =
        tasks.where((t) => t.status == TaskStatus.assigned).length;
    final inProgressCount =
        tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final completedCount =
        tasks.where((t) => t.status == TaskStatus.completed).length;

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
                accentColor: AppColors.purple,
              ),
              const SizedBox(height: 24),

              // Overview 3 Stats
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
                    _buildStat('Assigned', '$assignedCount', AppColors.warning),
                    _buildDivider(),
                    _buildStat(
                        'In Progress', '$inProgressCount', AppColors.secondary),
                    _buildDivider(),
                    _buildStat(
                        'Completed', '$completedCount', AppColors.primary),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Today's Schedule
              Text("Today's Schedule", style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event_note_rounded,
                        color: AppColors.purple, size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tasks.isEmpty
                                ? 'Daily Field Schedule'
                                : 'Assigned Site Inspections',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$assignedCount pending tasks scheduled for today',
                            style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // My Tasks Quick Category Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Tasks', style: AppTextStyles.titleMedium),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, RouteConstants.myTasks),
                    child: const Text('View All',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (tasks.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: Text('No tasks assigned currently.',
                        style: TextStyle(color: AppColors.textMuted)),
                  ),
                )
              else
                ...tasks.map((task) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(14),
                        title: Text('#${task.reportId} • ${task.title}',
                            style: AppTextStyles.titleSmall),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(task.location.address,
                                style: const TextStyle(
                                    color: AppColors.textMuted, fontSize: 12)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: task.status == TaskStatus.inProgress
                                        ? AppColors.secondaryLight
                                        : AppColors.warningLight,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    task.status.label,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          task.status == TaskStatus.inProgress
                                              ? AppColors.secondary
                                              : AppColors.warning,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                    'Due: ${AppDateUtils.formatDate(task.dueDate)}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMuted)),
                              ],
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14, color: AppColors.textMuted),
                        onTap: () => Navigator.pushNamed(
                            context, RouteConstants.taskDetails,
                            arguments: task),
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
          BottomNavItem(
              icon: Icons.assignment_turned_in_outlined, label: 'Tasks'),
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
                  fontSize: 22, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDivider() =>
      Container(height: 32, width: 1, color: AppColors.border);
}
