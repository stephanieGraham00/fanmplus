import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class MoodSelector extends StatelessWidget {
  final String? selectedMood;
  final ValueChanged<String> onMoodSelected;

  const MoodSelector({
    super.key,
    this.selectedMood,
    required this.onMoodSelected,
  });

  static const moods = {
    'Happy': '😊',
    'Loved': '🥰',
    'Sad': '😢',
    'Angry': '😡',
    'Tired': '😴',
    'Stressed': '😰',
    'Excited': '😍',
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: moods.entries.map((entry) {
        final isSelected = selectedMood == entry.key;
        return GestureDetector(
          onTap: () => onMoodSelected(entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.primaryLight : AppColors.secondaryLight,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12)]
                  : null,
            ),
            child: Center(
              child: Text(entry.value, style: const TextStyle(fontSize: 22)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class MoodBar extends StatelessWidget {
  final List<Map<String, dynamic>> moodHistory;

  const MoodBar({super.key, required this.moodHistory});

  @override
  Widget build(BuildContext context) {
    if (moodHistory.isEmpty) {
      return Text('No moods logged today', style: AppTextStyles.bodySmall);
    }
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: moodHistory.map((m) {
        final emoji = MoodSelector.moods[m['mood']] ?? '😊';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.secondaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 16)),
        );
      }).toList(),
    );
  }
}
