import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/enums/report_status.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_app_bar.dart';

class BadgeDefinition {
  final String id;
  final String name;
  final String desc;
  final IconData icon;
  final Color color;
  final int currentProgress;
  final int targetProgress;
  final String unit;

  BadgeDefinition({
    required this.id,
    required this.name,
    required this.desc,
    required this.icon,
    required this.color,
    required this.currentProgress,
    required this.targetProgress,
    required this.unit,
  });

  bool get isUnlocked => currentProgress >= targetProgress;
  double get progressRatio => (currentProgress / targetProgress).clamp(0.0, 1.0);
}

class RewardsBadgesScreen extends StatelessWidget {
  const RewardsBadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = context.watch<FirestoreService>();
    final allReports = firestore.reports;
    final totalReports = allReports.length;
    final resolvedCount = allReports
        .where((r) =>
            r.status == ReportStatus.resolved ||
            r.status == ReportStatus.closed)
        .length;
    final wasteReports = allReports
        .where((r) =>
            r.category.toLowerCase().contains('garbage') ||
            r.category.toLowerCase().contains('waste'))
        .length;
    final emergencyCount = firestore.emergencies.length;
    final totalPoints =
        (resolvedCount * 50) + (totalReports * 10) + (emergencyCount * 30);

    final badges = [
      BadgeDefinition(
        id: 'starter',
        name: 'Civic Starter',
        desc: 'Report your first civic problem on Smart Nagrik',
        icon: Icons.flag_rounded,
        color: Colors.blue,
        currentProgress: totalReports,
        targetProgress: 1,
        unit: 'report',
      ),
      BadgeDefinition(
        id: 'eco_guardian',
        name: 'Eco Guardian',
        desc: 'Report 3 environmental or garbage issues',
        icon: Icons.eco_rounded,
        color: Colors.green,
        currentProgress: wasteReports,
        targetProgress: 3,
        unit: 'eco reports',
      ),
      BadgeDefinition(
        id: 'problem_solver',
        name: 'Problem Solver',
        desc: 'Have 2 filed issues successfully verified & resolved',
        icon: Icons.verified_rounded,
        color: Colors.teal,
        currentProgress: resolvedCount,
        targetProgress: 2,
        unit: 'resolutions',
      ),
      BadgeDefinition(
        id: 'community_shield',
        name: 'Community Shield',
        desc: 'Respond or participate in 1 Emergency SOS broadcast',
        icon: Icons.shield_rounded,
        color: AppColors.emergency,
        currentProgress: emergencyCount,
        targetProgress: 1,
        unit: 'emergency response',
      ),
      BadgeDefinition(
        id: 'nagrik_champion',
        name: 'Nagrik Champion',
        desc: 'Earn 100 civic impact contribution points',
        icon: Icons.military_tech_rounded,
        color: Colors.purple,
        currentProgress: totalPoints,
        targetProgress: 100,
        unit: 'points',
      ),
    ];

    final unlockedCount = badges.where((b) => b.isUnlocked).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'Rewards & Civic Badges'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Points & Badges Summary Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.emoji_events_rounded,
                          color: Colors.white, size: 36),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$totalPoints pts',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text(
                            '$unlockedCount of ${badges.length} Badges Unlocked',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Available Badges & Progress', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),

              ...badges.map((b) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: b.isUnlocked
                          ? b.color.withValues(alpha: 0.4)
                          : AppColors.border,
                      width: b.isUnlocked ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: b.isUnlocked
                            ? b.color.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.02),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              color: b.isUnlocked
                                  ? b.color.withValues(alpha: 0.15)
                                  : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              b.icon,
                              color: b.isUnlocked ? b.color : Colors.grey,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(b.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    if (b.isUnlocked) ...[
                                      const SizedBox(width: 6),
                                      const Icon(Icons.check_circle_rounded,
                                          color: Colors.green, size: 16),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  b.desc,
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: b.isUnlocked
                                  ? Colors.green.shade50
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              b.isUnlocked ? 'Unlocked' : 'Locked',
                              style: TextStyle(
                                color: b.isUnlocked
                                    ? Colors.green.shade700
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: b.progressRatio,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              b.isUnlocked ? Colors.green : b.color),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress: ${b.currentProgress}/${b.targetProgress} ${b.unit}',
                            style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${(b.progressRatio * 100).toInt()}%',
                            style: TextStyle(
                              color: b.isUnlocked ? Colors.green : AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
