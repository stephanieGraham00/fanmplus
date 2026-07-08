import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../providers/tracker_provider.dart';
import '../../providers/language_provider.dart';
import '../../models/tracker_model.dart';
import '../../utils/constants.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/mood_selector.dart';
import '../../widgets/symptom_tile.dart';
import '../../widgets/tracker_card.dart';
import '../../widgets/pam_icon.dart';

class SelfCareScreen extends ConsumerWidget {
  const SelfCareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(translationsProvider);
    final tracker = ref.watch(trackerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr.selfCare, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 4),
              Text(tr.selfCareSubtitle, style: AppTextStyles.bodyMedium),
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
                        Text(tr.yourMood, style: AppTextStyles.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 16),
                    MoodSelector(
                      selectedMood: tracker.currentMood,
                      onMoodSelected: (mood) => ref.read(trackerProvider.notifier).setMood(mood),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              TrackerCard(
                emoji: '💧',
                title: tr.waterTracker,
                value: '${tracker.waterGlasses}/${tracker.waterGoal}',
                subtitle: tr.waterGoal(tracker.waterGoal),
                progress: tracker.waterProgress,
                onTap: () => ref.read(trackerProvider.notifier).addWater(),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: AppColors.textHint),
                      onPressed: () => ref.read(trackerProvider.notifier).removeWater(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: AppColors.primary),
                      onPressed: () => ref.read(trackerProvider.notifier).addWater(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TrackerCard(
                      emoji: '🏃',
                      title: tr.exercise,
                      value: '${tracker.exerciseMinutes} min',
                      subtitle: tr.thisWeek,
                      progress: tracker.exerciseMinutes / 150,
                      color: AppColors.fertile,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TrackerCard(
                      emoji: '😴',
                      title: tr.sleep,
                      value: '${tracker.sleepHours}h',
                      subtitle: tr.qualityOf(tracker.sleepQuality),
                      progress: tracker.sleepHours / 9,
                      color: AppColors.luteal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(tr.symptoms, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.symptoms.take(12).map((s) {
                        final isSelected = tracker.todaySymptoms.any((t) => t.symptom == s);
                        return QuickSymptomChip(
                          label: s,
                          isSelected: isSelected,
                          onTap: () {
                            if (isSelected) {
                              final idx = tracker.todaySymptoms.indexWhere((t) => t.symptom == s);
                              ref.read(trackerProvider.notifier).removeSymptom(idx);
                            } else {
                              ref.read(trackerProvider.notifier).addSymptom(
                                SymptomLog(userId: '', symptom: s, severity: 5, date: DateTime.now()),
                              );
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    ...tracker.todaySymptoms.map((s) => SymptomTile(
                      name: s.symptom, severity: s.severity, onSeverityChanged: (v) {},
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(tr.tips, style: AppTextStyles.headlineLarge),
              const SizedBox(height: 12),
              _TipCard(iconName: 'flower', title: tr.meditation, desc: tr.meditationDesc),
              const SizedBox(height: 8),
              _TipCard(iconName: 'heart', title: tr.journal, desc: tr.journalDesc),
              const SizedBox(height: 8),
              _TipCard(iconName: 'run', title: tr.walk, desc: tr.walkDesc),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String iconName, title, desc;
  const _TipCard({required this.iconName, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.secondaryLight, borderRadius: BorderRadius.circular(12)),
            child: PamIcon(name: iconName, size: 20, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleMedium),
              Text(desc, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
