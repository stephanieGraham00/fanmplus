import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SymptomTile extends StatelessWidget {
  final String name;
  final int severity;
  final ValueChanged<int> onSeverityChanged;
  final VoidCallback? onRemove;

  const SymptomTile({
    super.key,
    required this.name,
    required this.severity,
    required this.onSeverityChanged,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondaryLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Text(name, style: AppTextStyles.titleSmall),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(10, (i) {
              final isFilled = i < severity;
              return GestureDetector(
                onTap: () => onSeverityChanged(i + 1),
                child: Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled
                        ? AppColors.primary.withOpacity(0.3 + (i / 10) * 0.7)
                        : AppColors.secondaryLight,
                  ),
                ),
              );
            }),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              child: Icon(Icons.close, size: 16, color: AppColors.textHint),
            ),
          ],
        ],
      ),
    );
  }
}

class QuickSymptomChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const QuickSymptomChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.secondaryLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
