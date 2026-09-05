import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../core/enums/report_status.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_app_bar.dart';

class MyImpactScreen extends StatelessWidget {
  const MyImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<AuthService>();
    final firestore = context.watch<FirestoreService>();
    final resolvedCount = firestore.reports
        .where((r) =>
            r.status == ReportStatus.resolved ||
            r.status == ReportStatus.closed)
        .length;
    final totalCount = firestore.reports.length;
    final points = (resolvedCount * 50) + (totalCount * 10);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'My Impact'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Big Score Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.emoji_events_rounded,
                        color: Colors.white, size: 48),
                    const SizedBox(height: 12),
                    Text('$points',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    const Text('Total Civic Impact Points',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('🌟 Citizen Rank #1 • $points Points',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Impact Breakdown', style: AppTextStyles.titleMedium),
              const SizedBox(height: 16),

              _ImpactTile(
                title: 'Reports Resolved',
                value: '$resolvedCount Issues',
                points: '+${resolvedCount * 50} pts',
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.primary,
              ),
              const SizedBox(height: 12),
              _ImpactTile(
                title: 'Reports Filed',
                value: '$totalCount Reports',
                points: '+${totalCount * 10} pts',
                icon: Icons.campaign_outlined,
                color: AppColors.secondary,
              ),
              const SizedBox(height: 12),
              _ImpactTile(
                title: 'Emergency Help Offered',
                value: '${firestore.emergencies.length} Responses',
                points: '+${firestore.emergencies.length * 30} pts',
                icon: Icons.volunteer_activism_outlined,
                color: AppColors.emergency,
              ),
              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Unlocked Badges', style: AppTextStyles.titleMedium),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, RouteConstants.rewardsBadges),
                    child: const Text('View All',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BadgeItem(
                      name: 'Eco Warrior',
                      icon: Icons.eco_rounded,
                      color: Colors.green),
                  _BadgeItem(
                      name: 'City Watch',
                      icon: Icons.visibility_rounded,
                      color: Colors.blue),
                  _BadgeItem(
                      name: 'Quick Reporter',
                      icon: Icons.bolt_rounded,
                      color: Colors.amber),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImpactTile extends StatelessWidget {
  final String title;
  final String value;
  final String points;
  final IconData icon;
  final Color color;

  const _ImpactTile({
    required this.title,
    required this.value,
    required this.points,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                Text(value,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          Text(points,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;

  const _BadgeItem(
      {required this.name, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
      ],
    );
  }
}
