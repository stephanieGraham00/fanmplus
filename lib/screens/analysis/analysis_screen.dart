import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/glass_card.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(translationsProvider);
    final cycle = ref.watch(cycleProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr.analysis, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 4),
              Text(tr.analysisSubtitle, style: AppTextStyles.bodyMedium),
              const SizedBox(height: 24),

              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('😊', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(tr.moods, style: AppTextStyles.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 180,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 7,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                  if (value.toInt() >= 0 && value.toInt() < 7) {
                                    return Text(days[value.toInt()], style: AppTextStyles.labelSmall);
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            horizontalInterval: 1,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) => FlLine(color: AppColors.secondaryLight, strokeWidth: 1),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(7, (i) {
                            final heights = [3.0, 5.0, 2.0, 6.0, 4.0, 5.0, 3.0];
                            return BarChartGroupData(x: i, barRods: [
                              BarChartRodData(toY: heights[i], color: AppColors.primary, width: 20,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(6))),
                            ]);
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🌸', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(tr.yourCycleAnalysis, style: AppTextStyles.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _AnalysisRow(tr.avgCycleLength, '${cycle.cycleLength} ${tr.days}'),
                    _AnalysisRow(tr.periodDuration, '${cycle.periodLength} ${tr.days}'),
                    _AnalysisRow(tr.currentPhaseLabel, cycle.prediction?.cyclePhase ?? '--'),
                    _AnalysisRow(tr.nextPeriodLabel, cycle.prediction?.nextPeriod.format() ?? '--'),
                    _AnalysisRow(tr.nextOvulationLabel, cycle.prediction?.nextOvulation.format() ?? '--'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🤕', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(tr.symptomsLabel, style: AppTextStyles.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 160,
                      child: Row(
                        children: [
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 30,
                                sections: [
                                  PieChartSectionData(value: 35, color: AppColors.period, title: '35%', radius: 30,
                                    titleStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.white)),
                                  PieChartSectionData(value: 25, color: AppColors.fertile, title: '25%', radius: 30,
                                    titleStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.white)),
                                  PieChartSectionData(value: 20, color: AppColors.ovulation, title: '20%', radius: 30,
                                    titleStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.white)),
                                  PieChartSectionData(value: 20, color: AppColors.safe, title: '20%', radius: 30,
                                    titleStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.white)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _PieLegend(AppColors.period, tr.cramps),
                              const SizedBox(height: 6),
                              _PieLegend(AppColors.fertile, tr.headache),
                              const SizedBox(height: 6),
                              _PieLegend(AppColors.ovulation, tr.fatigue),
                              const SizedBox(height: 6),
                              _PieLegend(AppColors.safe, tr.other),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalysisRow extends StatelessWidget {
  final String label;
  final String value;
  const _AnalysisRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(value, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _PieLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _PieLegend(this.color, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
