import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/firestore_service.dart';
import '../../core/services/report_pdf_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_app_bar.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = context.watch<FirestoreService>();
    final analytics = firestore.analytics;
    final allReports = firestore.reports;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'City Analytics',
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined, color: AppColors.primary),
            tooltip: 'Print Analytics PDF',
            onPressed: () => ReportPdfService.printAnalytics(
              context: context,
              totalReports: analytics.totalReports,
              inProgress: analytics.inProgressReports,
              resolved: analytics.resolvedReports,
              pending: analytics.pendingReports,
              reports: allReports,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.primary),
            tooltip: 'Share Analytics PDF',
            onPressed: () => ReportPdfService.shareAnalytics(
              context: context,
              totalReports: analytics.totalReports,
              inProgress: analytics.inProgressReports,
              resolved: analytics.resolvedReports,
              pending: analytics.pendingReports,
              reports: allReports,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Overview', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),

              Row(
                children: [
                  _StatBox(
                      label: 'Total Reports',
                      value: '${analytics.totalReports}',
                      color: AppColors.primary),
                  const SizedBox(width: 12),
                  _StatBox(
                      label: 'Pending',
                      value: '${analytics.pendingReports}',
                      color: AppColors.warning),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatBox(
                      label: 'In Progress',
                      value: '${analytics.inProgressReports}',
                      color: AppColors.secondary),
                  const SizedBox(width: 12),
                  _StatBox(
                      label: 'Resolved',
                      value: '${analytics.resolvedReports}',
                      color: AppColors.primaryDark),
                ],
              ),
              const SizedBox(height: 28),

              // Reports By Category Section
              Text('Reports by Category', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: analytics.reportsByCategory.entries.map((entry) {
                    final percentage = (entry.value / analytics.totalReports);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13)),
                              Text(
                                  '${entry.value} (${(percentage * 100).toStringAsFixed(0)}%)',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: Colors.grey.shade100,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 28),

              // Resolution Trends Chart
              Text('Resolution Trends (Monthly)',
                  style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              Container(
                height: 220,
                padding: const EdgeInsets.only(
                    top: 24, bottom: 12, left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
                            final i = value.toInt();
                            if (i >= 0 && i < months.length) {
                              return Text(months[i],
                                  style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 11));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 18),
                          FlSpot(1, 24),
                          FlSpot(2, 32),
                          FlSpot(3, 28),
                          FlSpot(4, 40),
                        ],
                        isCurved: true,
                        color: AppColors.primary,
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.primary.withValues(alpha: 0.15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 26, fontWeight: FontWeight.w900, color: color)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
