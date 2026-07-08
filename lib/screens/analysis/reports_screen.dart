import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/pam_icon.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/tracker_provider.dart';
import '../../providers/body_metrics_provider.dart';
import '../../providers/contraception_provider.dart';
import '../../providers/language_provider.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final cycle = ref.watch(cycleProvider);
    final tracker = ref.watch(trackerProvider);
    final bodyMetrics = ref.watch(bodyMetricsProvider);
    final contraception = ref.watch(contraceptionProvider);
    final tr = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(tr.reportsTitle, style: AppTextStyles.titleLarge),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cycle Phase Chart
            Text(tr.cyclePhaseBreakdown, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: _buildCycleSections(cycle),
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _LegendItem(color: AppColors.period, label: tr.period),
                      _LegendItem(color: AppColors.fertile, label: tr.fertile),
                      _LegendItem(color: AppColors.ovulation, label: tr.ovulation),
                      _LegendItem(color: AppColors.safe, label: tr.safe),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Mood Trend
            Text(tr.moodTrends, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 180,
                child: tracker.moodHistory.isEmpty
                    ? Center(
                        child: Text(
                          '${tr.noMoodData}\nKòmanse anrejistre imè ou!',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                        ),
                      )
                    : BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 10,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                                  return Text(days[value.toInt() % 7], style: AppTextStyles.labelSmall);
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(show: false),
                          barGroups: _buildMoodBars(tracker),
                        ),
                      ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Contraception Stats
            Text(tr.contraceptionStats, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: contraception.totalProtected.toDouble(),
                            color: AppColors.success,
                            title: '${contraception.totalProtected}',
                            radius: 50,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            value: contraception.totalUnprotected.toDouble(),
                            color: AppColors.error,
                            title: '${contraception.totalUnprotected}',
                            radius: 50,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                        centerSpaceRadius: 30,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _LegendItem(color: AppColors.success, label: '${tr.protectedLabel} (${contraception.totalProtected})'),
                      _LegendItem(color: AppColors.error, label: '${tr.unprotectedLabel} (${contraception.totalUnprotected})'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Body Metrics Charts
            Text(tr.bodyMetricsCharts, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),

            // Temperature
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const PamIcon(name: 'med', size: 20, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(tr.temperature, style: AppTextStyles.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: bodyMetrics.temperatures.isEmpty
                        ? Center(child: Text(tr.noData, style: AppTextStyles.bodySmall))
                        : LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: bodyMetrics.temperatures.take(14).toList().asMap().entries.map((e) {
                                    return FlSpot(e.key.toDouble(), e.value.temperature);
                                  }).toList(),
                                  isCurved: true,
                                  color: AppColors.primary,
                                  barWidth: 2,
                                  dotData: const FlDotData(show: true),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: AppColors.primary.withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Weight
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const PamIcon(name: 'bow', size: 20, color: AppColors.secondary),
                      const SizedBox(width: 8),
                      Text(tr.weight, style: AppTextStyles.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: bodyMetrics.weights.isEmpty
                        ? Center(child: Text(tr.noData, style: AppTextStyles.bodySmall))
                        : LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: bodyMetrics.weights.take(30).toList().asMap().entries.map((e) {
                                    return FlSpot(e.key.toDouble(), e.value.weight);
                                  }).toList(),
                                  isCurved: true,
                                  color: AppColors.secondary,
                                  barWidth: 2,
                                  dotData: const FlDotData(show: true),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: AppColors.secondary.withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Blood Pressure
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const PamIcon(name: 'heart', size: 20, color: AppColors.error),
                      const SizedBox(width: 8),
                      Text(tr.bloodPressure, style: AppTextStyles.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: bodyMetrics.bloodPressures.isEmpty
                        ? Center(child: Text(tr.noData, style: AppTextStyles.bodySmall))
                        : LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: bodyMetrics.bloodPressures.take(14).toList().asMap().entries.map((e) {
                                    return FlSpot(e.key.toDouble(), e.value.systolic.toDouble());
                                  }).toList(),
                                  isCurved: true,
                                  color: AppColors.error,
                                  barWidth: 2,
                                  dotData: const FlDotData(show: true),
                                ),
                                LineChartBarData(
                                  spots: bodyMetrics.bloodPressures.take(14).toList().asMap().entries.map((e) {
                                    return FlSpot(e.key.toDouble(), e.value.diastolic.toDouble());
                                  }).toList(),
                                  isCurved: true,
                                  color: AppColors.info,
                                  barWidth: 2,
                                  dotData: const FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _LegendItem(color: AppColors.error, label: 'Sistolik'),
                      _LegendItem(color: AppColors.info, label: 'Dyastolik'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Cycle History
            Text(tr.cycleHistory, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(label: tr.avgCycleLength, value: '${cycle.cycleLength} jou'),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Longè peryòd', value: '${cycle.periodLength} jou'),
                  const SizedBox(height: 8),
                  _InfoRow(label: tr.lastPeriod, value: cycle.lastPeriodDate?.format(pattern: 'dd MMM yyyy') ?? '--'),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Pwochen peryòd', value: cycle.prediction?.nextPeriod.format(pattern: 'dd MMM yyyy') ?? '--'),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Pwochen ovilasyon', value: cycle.prediction?.nextOvulation.format(pattern: 'dd MMM yyyy') ?? '--'),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildCycleSections(CycleState cycle) {
    final cycleLength = cycle.cycleLength;
    final periodLength = cycle.periodLength;
    final ovDay = cycleLength - 14;

    return [
      PieChartSectionData(
        value: periodLength.toDouble(),
        color: AppColors.period,
        title: '$periodLength',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        value: 6,
        color: AppColors.fertile,
        title: '6',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        value: 1,
        color: AppColors.ovulation,
        title: '1',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        value: (cycleLength - periodLength - 7).toDouble(),
        color: AppColors.safe,
        title: '${cycleLength - periodLength - 7}',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }

  List<BarChartGroupData> _buildMoodBars(TrackerState tracker) {
    final moodValues = {
      '😊': 8,
      '😢': 3,
      '😡': 2,
      '😐': 5,
      '😰': 4,
    };
    final recentMoods = tracker.moodHistory.take(7).toList();
    return List.generate(7, (index) {
      if (index < recentMoods.length) {
        final mood = recentMoods[index].mood;
        final value = moodValues[mood] ?? 5;
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: value.toDouble(),
              color: AppColors.primary,
              width: 16,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        );
      }
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: 0,
            color: AppColors.secondaryLight,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        Text(value, style: AppTextStyles.titleSmall),
      ],
    );
  }
}
