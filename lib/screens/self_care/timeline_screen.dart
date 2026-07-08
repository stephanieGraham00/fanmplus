import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/pam_icon.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/tracker_provider.dart';
import '../../providers/body_metrics_provider.dart';
import '../../providers/language_provider.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  DateTime _selectedDate = DateTime.now();
  int _selectedTab = 0; // 0=Timeline, 1=Report, 2=Stats

  @override
  Widget build(BuildContext context) {
    final cycle = ref.watch(cycleProvider);
    final tracker = ref.watch(trackerProvider);
    final bodyMetrics = ref.watch(bodyMetricsProvider);
    final tr = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const PamIcon(name: 'bow', size: 28, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(tr.dailyJournal, style: AppTextStyles.headlineLarge),
                ],
              ),
            ),

            // Tab selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _TabButton(label: tr.journal, index: 0, selected: _selectedTab, onTap: (i) => setState(() => _selectedTab = i)),
                    _TabButton(label: tr.report, index: 1, selected: _selectedTab, onTap: (i) => setState(() => _selectedTab = i)),
                    _TabButton(label: tr.stats, index: 2, selected: _selectedTab, onTap: (i) => setState(() => _selectedTab = i)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Date strip
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 30,
                itemBuilder: (ctx, index) {
                  final date = DateTime.now().subtract(Duration(days: 14 - index));
                  final isSelected = date.day == _selectedDate.day &&
                      date.month == _selectedDate.month &&
                      date.year == _selectedDate.year;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = date),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 52,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected ? null : Border.all(color: AppColors.secondaryLight),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('dd').format(date),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            DateFormat('EEE').format(date),
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected ? Colors.white70 : AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Content
            Expanded(
              child: _selectedTab == 0
                  ? _buildTimeline(cycle, tracker, bodyMetrics)
                  : _selectedTab == 1
                      ? _buildReport(tracker, bodyMetrics)
                      : _buildStats(cycle, tracker),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(CycleState cycle, TrackerState tracker, BodyMetricsState bodyMetrics) {
    final tr = ref.watch(translationsProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Text(
            DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate),
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: 16),

          // Flow
          _TimelineItem(
            iconName: 'period',
            title: 'Flow',
            subtitle: bodyMetrics.latestFlow?.intensity ?? tr.notRecorded,
            color: AppColors.period,
            onTap: () => _showFlowDialog(),
          ),
          const SizedBox(height: 8),

          // Nutrition (Water)
          _TimelineItem(
            iconName: 'water',
            title: tr.nutrition,
            subtitle: '${tracker.waterGlasses}/${tracker.waterGoal} vè dlo',
            color: AppColors.info,
            onTap: () => ref.read(trackerProvider.notifier).addWater(),
          ),
          const SizedBox(height: 8),

          // Mood
          _TimelineItem(
            iconName: 'heart',
            title: tr.mood,
            subtitle: tracker.currentMood.isEmpty ? tr.notSelected : tracker.currentMood,
            color: AppColors.primary,
            onTap: () {},
          ),
          const SizedBox(height: 8),

          // Weight
          _TimelineItem(
            iconName: 'bow',
            title: tr.weight,
            subtitle: bodyMetrics.latestWeight != null
                ? '${bodyMetrics.latestWeight!.toStringAsFixed(1)} kg'
                : tr.notRecorded,
            color: AppColors.secondary,
            onTap: () => _showAddWeightDialog(),
          ),
          const SizedBox(height: 8),

          // Temperature
          _TimelineItem(
            iconName: 'med',
            title: tr.temperature,
            subtitle: bodyMetrics.latestTemperature != null
                ? '${bodyMetrics.latestTemperature!.toStringAsFixed(1)}°C'
                : tr.notRecorded,
            color: AppColors.warning,
            onTap: () => _showAddTempDialog(),
          ),
          const SizedBox(height: 8),

          // Exercise
          _TimelineItem(
            iconName: 'run',
            title: tr.exerciseTrackerLabel,
            subtitle: '${tracker.exerciseMinutes} minit',
            color: AppColors.fertile,
            onTap: () {},
          ),
          const SizedBox(height: 8),

          // Sleep
          _TimelineItem(
            iconName: 'moon',
            title: tr.sleepTrackerLabel,
            subtitle: '${tracker.sleepHours}h (kalite ${tracker.sleepQuality}/5)',
            color: AppColors.luteal,
            onTap: () {},
          ),
          const SizedBox(height: 8),

          // Symptoms
          _TimelineItem(
            iconName: 'med',
            title: tr.symptoms,
            subtitle: tracker.todaySymptoms.isEmpty
                ? tr.noSymptoms
                : '${tracker.todaySymptoms.length} sentòm',
            color: AppColors.error,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildReport(TrackerState tracker, BodyMetricsState bodyMetrics) {
    final tr = ref.watch(translationsProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.weeklySummary, style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _ReportCard(label: 'Dlo', value: '${tracker.waterGlasses * 7}', unit: 'vè', iconName: 'water')),
              const SizedBox(width: 12),
              Expanded(child: _ReportCard(label: tr.exerciseTrackerLabel, value: '${tracker.exerciseMinutes * 7}', unit: 'min', iconName: 'run')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _ReportCard(label: tr.sleepTrackerLabel, value: '${tracker.sleepHours * 7}', unit: 'h', iconName: 'moon')),
              const SizedBox(width: 12),
              Expanded(child: _ReportCard(label: tr.symptoms, value: '${tracker.todaySymptoms.length}', unit: '', iconName: 'med')),
            ],
          ),
          const SizedBox(height: 24),
          Text(tr.latestMetrics, style: AppTextStyles.headlineMedium),
          const SizedBox(height: 12),
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow(label: tr.temperature, value: bodyMetrics.latestTemperature != null ? '${bodyMetrics.latestTemperature!.toStringAsFixed(1)}°C' : '--'),
                const SizedBox(height: 8),
                _InfoRow(label: tr.weight, value: bodyMetrics.latestWeight != null ? '${bodyMetrics.latestWeight!.toStringAsFixed(1)} kg' : '--'),
                const SizedBox(height: 8),
                _InfoRow(label: 'Presyon San', value: bodyMetrics.latestBloodPressure != null ? '${bodyMetrics.latestBloodPressure!.systolic}/${bodyMetrics.latestBloodPressure!.diastolic}' : '--'),
                const SizedBox(height: 8),
                _InfoRow(label: 'Intansite San', value: bodyMetrics.latestFlow?.intensity ?? '--'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(CycleState cycle, TrackerState tracker) {
    final tr = ref.watch(translationsProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cycle analysis card
          GlassCard(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(tr.cycleAnalysis, style: AppTextStyles.headlineMedium.copyWith(color: Colors.white)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  width: 140,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          height: 140,
                          width: 140,
                          child: CircularProgressIndicator(
                            value: (cycle.prediction?.cycleDay ?? 1) / cycle.cycleLength,
                            strokeWidth: 12,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Jou', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            Text(
                              '${cycle.prediction?.cycleDay ?? 0}',
                              style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              cycle.prediction?.cyclePhase ?? '--',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _CycleInfo(label: 'Pwochen Peryòd', value: '${cycle.prediction?.daysUntilNextPeriod ?? 0} jou'),
                    _CycleInfo(label: 'Ovilasyon', value: cycle.prediction?.nextOvulation.format(pattern: 'dd MMM') ?? '--'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Phase legend
          Text('Faz Sik', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              _PhaseChip(color: AppColors.period, label: 'Peryòd'),
              const SizedBox(width: 8),
              _PhaseChip(color: AppColors.fertile, label: 'Fetil'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _PhaseChip(color: AppColors.ovulation, label: 'Ovilasyon'),
              const SizedBox(width: 8),
              _PhaseChip(color: AppColors.safe, label: 'San Risk'),
            ],
          ),
          const SizedBox(height: 24),

          // Mood summary
          Text('Imè Semenn sa a', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 12),
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: tracker.moodHistory.isEmpty
                ? Center(
                    child: Text('Pa gen done imè ankò.', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint)),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _getMoodCounts(tracker).entries.map((e) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${e.key} (${e.value})', style: AppTextStyles.titleSmall),
                    )).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _getMoodCounts(TrackerState tracker) {
    final counts = <String, int>{};
    for (final log in tracker.moodHistory) {
      counts[log.mood] = (counts[log.mood] ?? 0) + 1;
    }
    return counts;
  }

  void _showFlowDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Intansite San', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 16),
              ...['spotting', 'light', 'medium', 'heavy'].map((i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(bodyMetricsProvider.notifier).addFlow(
                        FlowLog(userId: '', date: _selectedDate, intensity: i),
                      );
                      Navigator.pop(ctx);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(i.toUpperCase(), style: const TextStyle(color: AppColors.primary)),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddWeightDialog() {
    final controller = TextEditingController();
    final tr = ref.watch(translationsProvider);
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tr.weight, style: AppTextStyles.headlineMedium),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: tr.enterWeight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      ref.read(bodyMetricsProvider.notifier).addWeight(
                        WeightLog(userId: '', date: _selectedDate, weight: double.parse(controller.text)),
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(tr.confirm),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTempDialog() {
    final controller = TextEditingController();
    final tr = ref.watch(translationsProvider);
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tr.temperature, style: AppTextStyles.headlineMedium),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Antre temperati (°C)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      ref.read(bodyMetricsProvider.notifier).addTemperature(
                        TemperatureLog(userId: '', date: _selectedDate, temperature: double.parse(controller.text)),
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(tr.confirm),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final int index;
  final int selected;
  final Function(int) onTap;

  const _TabButton({required this.label, required this.index, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selected;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)] : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textHint,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String iconName;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _TimelineItem({
    required this.iconName,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: PamIcon(name: iconName, size: 22, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleSmall),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String iconName;

  const _ReportCard({required this.label, required this.value, required this.unit, required this.iconName});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          PamIcon(name: iconName, size: 24, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary)),
          Text(unit, style: AppTextStyles.labelSmall),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}

class _CycleInfo extends StatelessWidget {
  final String label;
  final String value;

  const _CycleInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class _PhaseChip extends StatelessWidget {
  final Color color;
  final String label;

  const _PhaseChip({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
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
