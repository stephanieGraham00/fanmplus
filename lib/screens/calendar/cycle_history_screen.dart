import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/body_metrics_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/pam_icon.dart';
import '../../utils/helpers.dart';

class CycleHistoryScreen extends ConsumerWidget {
  const CycleHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(translationsProvider);
    final cycle = ref.watch(cycleProvider);
    final bodyMetrics = ref.watch(bodyMetricsProvider);
    final periodStarts = cycle.periodStarts;
    final flowLogs = bodyMetrics.flowLogs;

    // Build cycle history from period starts
    final allFlowDates = flowLogs.map((f) => DateTime(f.date.year, f.date.month, f.date.day)).toSet();
    final history = CycleCalculator.buildCycleHistory(periodStarts, allFlowDates);

    final adaptiveLen = CycleCalculator.computeAdaptiveCycleLength(periodStarts);
    final avgLen = adaptiveLen ?? cycle.cycleLength;

    // Calculate stats
    final cycleLengths = history.map((h) => h.cycleLength).toList();
    final shortest = cycleLengths.isEmpty ? avgLen : cycleLengths.reduce((a, b) => a < b ? a : b);
    final longest = cycleLengths.isEmpty ? avgLen : cycleLengths.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(tr.cycleHistoryTitle, style: AppTextStyles.titleLarge),
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
            // Summary stats
            GlassCard(
              padding: const EdgeInsets.all(20),
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.08), AppColors.secondary.withOpacity(0.08)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(value: '${periodStarts.length}', label: tr.cycleCountTitle),
                  Container(width: 1, height: 40, color: AppColors.secondaryLight),
                  _StatItem(value: '$avgLen', label: tr.avgCycleLenLabel),
                  Container(width: 1, height: 40, color: AppColors.secondaryLight),
                  _StatItem(value: '$shortest', label: tr.shortestLabel),
                  Container(width: 1, height: 40, color: AppColors.secondaryLight),
                  _StatItem(value: '$longest', label: tr.longestLabel),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (history.isEmpty)
              GlassCard(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Text('📊', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 16),
                    Text(tr.noHistoryYet, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
                  ],
                ),
              )
            else
              ...List.generate(history.length, (index) {
                final h = history[history.length - 1 - index]; // latest first
                final flowCount = flowLogs.where((f) =>
                  f.date.isAfter(h.periodStart.subtract(const Duration(days: 1))) &&
                  f.date.isBefore(h.periodStart.add(Duration(days: h.periodLength + 1)))
                ).length;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.period.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('🌸', style: TextStyle(fontSize: 18)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${tr.yourCyclesLabel} ${history.length - index}', style: AppTextStyles.titleMedium),
                                  Text(DateFormat('dd MMM yyyy').format(h.periodStart), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('${h.cycleLength} ${tr.days}', style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _DetailChip(label: '${tr.periodDaysLabel}: ${h.periodLength}'),
                            const SizedBox(width: 8),
                            _DetailChip(label: '${h.periodLength} ${tr.days}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  final String label;
  const _DetailChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: AppTextStyles.labelSmall),
    );
  }
}
