import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/pam_icon.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/tracker_provider.dart';
import '../../providers/body_metrics_provider.dart';
import '../../providers/contraception_provider.dart';
import '../../providers/language_provider.dart';

class MedicalProfileScreen extends ConsumerStatefulWidget {
  const MedicalProfileScreen({super.key});

  @override
  ConsumerState<MedicalProfileScreen> createState() => _MedicalProfileScreenState();
}

class _MedicalProfileScreenState extends ConsumerState<MedicalProfileScreen> {
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
        title: Text(tr.medicalFile, style: AppTextStyles.titleLarge),
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
            // Cycle Summary Card
            GlassCard(
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.1), AppColors.secondary.withOpacity(0.1)],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const PamIcon(name: 'heart', size: 28, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(tr.cycleSummary, style: AppTextStyles.headlineMedium),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        label: 'Jou Sik',
                        value: '${cycle.prediction?.cycleDay ?? 0}',
                        color: AppColors.primary,
                      ),
                      _StatItem(
                        label: tr.phase,
                        value: cycle.prediction?.cyclePhase ?? '--',
                        color: AppColors.secondary,
                      ),
                      _StatItem(
                        label: tr.daysLeft,
                        value: '${cycle.prediction?.daysUntilNextPeriod ?? 0}',
                        color: AppColors.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        label: 'Ovilasyon',
                        value: cycle.prediction?.nextOvulation.format(pattern: 'dd MMM') ?? '--',
                        color: AppColors.ovulation,
                      ),
                      _StatItem(
                        label: 'Fenèt Fetil',
                        value: cycle.prediction?.fertileWindow ?? '--',
                        color: AppColors.fertile,
                      ),
                      _StatItem(
                        label: 'Chans Gwosès',
                        value: '${((cycle.prediction?.pregnancyChance ?? 0) * 100).toInt()}%',
                        color: AppColors.success,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Body Metrics
            Text(tr.bodyMetrics, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    iconName: 'med',
                    label: tr.temperature,
                    value: bodyMetrics.latestTemperature != null
                        ? '${bodyMetrics.latestTemperature!.toStringAsFixed(1)}°C'
                        : '--',
                    onTap: () => _showAddDialog(tr.temperature, (v) {
                      ref.read(bodyMetricsProvider.notifier).addTemperature(
                        TemperatureLog(userId: '', date: DateTime.now(), temperature: double.parse(v)),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    iconName: 'bow',
                    label: tr.weight,
                    value: bodyMetrics.latestWeight != null
                        ? '${bodyMetrics.latestWeight!.toStringAsFixed(1)} kg'
                        : '--',
                    onTap: () => _showAddDialog(tr.weight, (v) {
                      ref.read(bodyMetricsProvider.notifier).addWeight(
                        WeightLog(userId: '', date: DateTime.now(), weight: double.parse(v)),
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    iconName: 'heart',
                    label: tr.bloodPressure,
                    value: bodyMetrics.latestBloodPressure != null
                        ? '${bodyMetrics.latestBloodPressure!.systolic}/${bodyMetrics.latestBloodPressure!.diastolic}'
                        : '--',
                    onTap: () => _showAddBloodPressureDialog(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    iconName: 'period',
                    label: 'Intansite San',
                    value: bodyMetrics.latestFlow?.intensity ?? '--',
                    onTap: () => _showFlowDialog(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Contraception Summary
            Text(tr.contraception, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _InfoRow(label: 'Metòd aktyèl', value: contraception.currentMethod),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Tout fwa pwoteje', value: '${contraception.totalProtected}'),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Tout fwa pa pwoteje', value: '${contraception.totalUnprotected}'),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Pilil lendemèn', value: '${contraception.morningAfterCount}'),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Tx pwoteksyon',
                    value: '${(contraception.protectionRate * 100).toInt()}%',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Mood & Symptoms Summary
            Text(tr.moodAndSymptoms, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tracker.currentMood.isNotEmpty)
                    _InfoRow(label: 'Imè jodi a', value: tracker.currentMood),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Sentòm jodi a', value: '${tracker.todaySymptoms.length}'),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Dlo jodi a', value: '${tracker.waterGlasses}/${tracker.waterGoal}'),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Egzèsis', value: '${tracker.exerciseMinutes} minit'),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Dòmi', value: '${tracker.sleepHours}h (kalite ${tracker.sleepQuality}/5)'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Medical Info
            Text(tr.medicalInfo, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(label: 'Gwoup san', value: tr.notEntered),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Alerji', value: tr.notEntered),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Maladi', value: tr.notEntered),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Medikaman', value: tr.notEntered),
                  const SizedBox(height: 8),
                  _InfoRow(label: 'Dènye tcheke', value: tr.notEntered),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(tr.addMedicalInfo, style: TextStyle(color: AppColors.primary)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(String title, Function(String) onSave) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTextStyles.headlineMedium),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: tr.enterValue,
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
                      onSave(controller.text);
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

  void _showAddBloodPressureDialog() {
    final sysController = TextEditingController();
    final diaController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tr.bloodPressure, style: AppTextStyles.headlineMedium),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: sysController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Sistolik',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: diaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Dyastolik',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (sysController.text.isNotEmpty && diaController.text.isNotEmpty) {
                      ref.read(bodyMetricsProvider.notifier).addBloodPressure(
                        BloodPressureLog(
                          userId: '',
                          date: DateTime.now(),
                          systolic: int.parse(sysController.text),
                          diastolic: int.parse(diaController.text),
                        ),
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
              Text('Intansite Bag San', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 16),
              ...['spotting', 'light', 'medium', 'heavy'].map((intensity) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(bodyMetricsProvider.notifier).addFlow(
                        FlowLog(userId: '', date: DateTime.now(), intensity: intensity),
                      );
                      Navigator.pop(ctx);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(intensity.toUpperCase(), style: const TextStyle(color: AppColors.primary)),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headlineMedium.copyWith(color: color, fontSize: 16)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String iconName;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _MetricCard({required this.iconName, required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          PamIcon(name: iconName, size: 28, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.labelSmall),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
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
