import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/cycle_provider.dart';
import '../../providers/tracker_provider.dart';
import '../../providers/user_data_provider.dart';
import '../../providers/language_provider.dart';
import '../../models/tracker_model.dart';
import '../../utils/constants.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/cycle_progress.dart';
import '../../widgets/mood_selector.dart';
import '../../widgets/tracker_card.dart';
import '../../widgets/mascot_widget.dart';
import '../../widgets/symptom_tile.dart';
import '../../widgets/pam_icon.dart';
import '../../utils/helpers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cycleProvider.notifier).setLastPeriod(
        DateTime.now().subtract(const Duration(days: 14)),
      );
      _scheduleNotifications();
    });
  }

  void _scheduleNotifications() async {
    final cycle = ref.read(cycleProvider);
    if (cycle.prediction != null) {
      await NotificationService.schedulePeriodReminder(
        daysUntil: cycle.prediction!.daysUntilNextPeriod,
        daysBefore: 2,
      );
      final daysToOv = cycle.prediction!.nextOvulation.difference(DateTime.now()).inDays;
      await NotificationService.scheduleOvulationReminder(daysUntilOvulation: daysToOv);
    }
    await NotificationService.schedulePillReminder(hour: 8, minute: 0);
    await NotificationService.scheduleSymptomReminder();
    await NotificationService.scheduleDailyCheckIn();
  }

  @override
  Widget build(BuildContext context) {
    final cycle = ref.watch(cycleProvider);
    final tracker = ref.watch(trackerProvider);
    final tr = ref.watch(translationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetingWidget(userName: 'Fanm+ Sè'),
              const SizedBox(height: 20),

              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text('✨', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        NotificationHelper.getMotivationalQuote(),
                        style: AppTextStyles.quoteText.copyWith(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(tr.yourCycleTitle, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Center(
                      child: CycleProgressWidget(
                        cycleDay: cycle.prediction?.cycleDay ?? 1,
                        cycleLength: cycle.adaptiveCycleLength,
                        size: 180,
                        phaseName: cycle.prediction?.cyclePhase,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          emoji: '🌸',
                          value: '${cycle.prediction?.daysUntilNextPeriod ?? 0}',
                          label: tr.daysUntil,
                          subtitle: tr.nextPeriod,
                        ),
                        _StatItem(
                          emoji: '🌞',
                          value: cycle.prediction?.nextOvulation.format(pattern: 'MMM dd') ?? '--',
                          label: '',
                          subtitle: tr.ovulation,
                        ),
                        _StatItem(
                          emoji: '💛',
                          value: cycle.prediction?.fertileWindow ?? '--',
                          label: '',
                          subtitle: tr.fertileWindow,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (cycle.periodStarts.length >= 2)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${tr.adaptivePrediction}: ${CycleCalculator.getAdaptiveCycleInfo(cycle.periodStarts)}',
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.success),
                        ),
                      ),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.08),
                            AppColors.secondary.withOpacity(0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Text('🤰', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr.pregnancyChance,
                                style: AppTextStyles.titleSmall,
                              ),
                              Text(
                                '${(cycle.prediction?.pregnancyChance ?? 0) * 100}%',
                                style: AppTextStyles.headlineLarge.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(tr.dailyWellness, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TrackerCard(
                      emoji: '💧',
                      title: tr.water,
                      value: '${tracker.waterGlasses}/${tracker.waterGoal}',
                      subtitle: '${tracker.waterGoal} ${tr.glasses}',
                      progress: tracker.waterProgress,
                      onTap: () => ref.read(trackerProvider.notifier).addWater(),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: AppColors.primary),
                        onPressed: () => ref.read(trackerProvider.notifier).addWater(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TrackerCard(
                      emoji: '🏃',
                      title: tr.exercise,
                      value: '${tracker.exerciseMinutes} min',
                      subtitle: tr.todayLabel,
                      progress: tracker.exerciseMinutes / 60,
                      color: AppColors.fertile,
                      onTap: () => _showExerciseDialog(tr),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TrackerCard(
                      emoji: '😴',
                      title: tr.sleep,
                      value: '${tracker.sleepHours}h',
                      subtitle: '${tr.quality}: ${tracker.sleepQuality}/5',
                      progress: tracker.sleepHours / 9,
                      color: AppColors.luteal,
                      onTap: () => _showSleepDialog(tr),
                    ),
                  ),
                  Expanded(
                    child: TrackerCard(
                      emoji: '💊',
                      title: tr.medication,
                      value: tracker.todaySymptoms.isEmpty ? '0' : '${tracker.todaySymptoms.length}',
                      subtitle: tr.todaySymptoms,
                      color: AppColors.warning,
                      onTap: () => _showSymptomDialog(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(tr.howFeeling, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    MoodSelector(
                      selectedMood: tracker.currentMood,
                      onMoodSelected: (mood) {
                        ref.read(trackerProvider.notifier).setMood(mood);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('😊 ${tr.moodRecorded}'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(tr.quickSymptomsTitle, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Cramps', 'Headache', 'Fatigue', 'Hunger', 'Back pain', 'Energy'].map((s) {
                        return QuickSymptomChip(
                          label: s,
                          isSelected: tracker.todaySymptoms.any((t) => t.symptom == s),
                          onTap: () {
                            ref.read(trackerProvider.notifier).addSymptom(
                              SymptomLog(
                                userId: '',
                                symptom: s,
                                severity: 5,
                                date: DateTime.now(),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    if (tracker.todaySymptoms.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ...tracker.todaySymptoms.asMap().entries.map((entry) {
                        return SymptomTile(
                          name: entry.value.symptom,
                          severity: entry.value.severity,
                          onSeverityChanged: (s) {},
                          onRemove: () => ref.read(trackerProvider.notifier).removeSymptom(entry.key),
                        );
                      }),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(tr.quickAccess, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      onTap: () => context.push('/medical-profile'),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          const Text('📋', style: TextStyle(fontSize: 28)),
                          const SizedBox(height: 6),
                          Text(tr.medicalFile, style: AppTextStyles.titleSmall, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GlassCard(
                      onTap: () => context.push('/contraception'),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          const Text('🛡️', style: TextStyle(fontSize: 28)),
                          const SizedBox(height: 6),
                          Text(tr.contraception, style: AppTextStyles.titleSmall, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GlassCard(
                      onTap: () => context.push('/reports'),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          const Text('📊', style: TextStyle(fontSize: 28)),
                          const SizedBox(height: 6),
                          Text('Reports', style: AppTextStyles.titleSmall, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              GlassCard(
                gradient: LinearGradient(
                  colors: [AppColors.error.withOpacity(0.05), AppColors.error.withOpacity(0.02)],
                ),
                onTap: () => context.push('/abuse'),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text('🛡️', style: TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr.sosAlert, style: AppTextStyles.titleLarge.copyWith(color: AppColors.error)),
                        Text(tr.sosSubtitle, style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: AppColors.error),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _HealthSectionCards(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _showExerciseDialog(AppTranslations tr) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (ctx) {
        int minutes = 30;
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(tr.addExercise, style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 20),
                  Text('$minutes ${tr.minutes}', style: AppTextStyles.cycleDayText),
                  Slider(
                    value: minutes.toDouble(),
                    min: 5, max: 120, divisions: 23,
                    activeColor: AppColors.fertile,
                    onChanged: (v) => setState(() => minutes = v.toInt()),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(trackerProvider.notifier).setExercise(minutes);
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.fertile),
                      child: Text(tr.confirm),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSleepDialog(AppTranslations tr) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (ctx) {
        int hours = 8;
        int quality = 3;
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('${tr.sleep}', style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 20),
                  Text('$hours ${tr.hours}', style: AppTextStyles.cycleDayText),
                  Slider(
                    value: hours.toDouble(),
                    min: 1, max: 12, divisions: 11,
                    activeColor: AppColors.luteal,
                    onChanged: (v) => setState(() => hours = v.toInt()),
                  ),
                  const SizedBox(height: 12),
                  Text('${tr.quality}: $quality/5', style: AppTextStyles.titleMedium),
                  Slider(
                    value: quality.toDouble(),
                    min: 1, max: 5, divisions: 4,
                    activeColor: AppColors.luteal,
                    onChanged: (v) => setState(() => quality = v.toInt()),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(trackerProvider.notifier).setSleep(hours, quality);
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.luteal),
                      child: Text(tr.confirm),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSymptomDialog() {
    final tr2 = ref.read(translationsProvider);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.secondaryLight,
                  borderRadius: BorderRadius.circular(2),
                ),
                alignment: Alignment.center,
              ),
              const SizedBox(height: 16),
              Text(tr2.symptomsWord, style: AppTextStyles.headlineMedium),
              const SizedBox(height: 16),
              Text(tr2.chooseSymptoms),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: AppConstants.symptoms.take(10).map((s) {
                  return QuickSymptomChip(
                    label: s,
                    isSelected: false,
                    onTap: () {},
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: Text(tr2.close),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

}

class _HealthSectionCards extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(translationsProvider);
    final userData = ref.watch(currentUserDataProvider).valueOrNull;
    final isPregnant = userData?.isPregnant == true;
    final hasHiv = userData?.hasHiv == true;
    final hasAbuse = userData?.hasExperiencedAbuse == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr.yourHealth, style: AppTextStyles.headlineLarge),
        const SizedBox(height: 12),
        if (isPregnant)
          _HealthCard(
            emoji: '🤰',
            title: tr.pregnancy,
            subtitle: tr.pregnancySubtitle,
            color: AppColors.primary,
            onTap: () => context.push('/pregnancy'),
          ),
        if (hasHiv)
          _HealthCard(
            emoji: '🎗️',
            title: tr.hiv,
            subtitle: tr.hivSubtitle,
            color: AppColors.info,
            onTap: () => context.push('/hiv'),
          ),
        if (hasAbuse)
          _HealthCard(
            emoji: '🛡️',
            title: tr.abuse,
            subtitle: tr.abuseSubtitle,
            color: AppColors.error,
            onTap: () => context.push('/abuse'),
          ),
        _HealthCard(
          emoji: '💬',
          title: tr.aiChat,
          subtitle: tr.aiChatSubtitle,
          color: AppColors.secondary,
          onTap: () => context.push('/ai-chat'),
        ),
        _HealthCard(
          emoji: '📞',
          title: tr.emergencyNumbers,
          subtitle: tr.emergencySubtitle,
          color: AppColors.warning,
          onTap: () => context.push('/abuse'),
        ),
      ],
    );
  }
}

class _HealthCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _HealthCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleMedium),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final String subtitle;

  const _StatItem({
    required this.emoji,
    required this.value,
    required this.label,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary)),
        if (label.isNotEmpty) Text(label, style: AppTextStyles.bodySmall),
        const SizedBox(height: 2),
        Text(subtitle, style: AppTextStyles.labelSmall),
      ],
    );
  }
}
