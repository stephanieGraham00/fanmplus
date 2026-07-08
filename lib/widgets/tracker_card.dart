import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'glass_card.dart';

class TrackerCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String value;
  final String? subtitle;
  final double? progress;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? color;

  const TrackerCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.value,
    this.subtitle,
    this.progress,
    this.onTap,
    this.trailing,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (color ?? AppColors.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: AppTextStyles.titleSmall),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: AppTextStyles.headlineLarge),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!, style: AppTextStyles.bodySmall),
          ],
          if (progress != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.secondaryLight,
                valueColor: AlwaysStoppedAnimation(color ?? AppColors.primary),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: (color ?? AppColors.primary).withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (color ?? AppColors.primary).withOpacity(0.12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color ?? AppColors.primary, size: 18),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.titleSmall.copyWith(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
