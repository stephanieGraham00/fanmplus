import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class MascotWidget extends StatelessWidget {
  final String? message;
  final double size;

  const MascotWidget({
    super.key,
    this.message,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '🌸',
              style: TextStyle(fontSize: size * 0.45),
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              message!,
              style: AppTextStyles.quoteText.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}

class GreetingWidget extends StatelessWidget {
  final String userName;

  const GreetingWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    String emoji;

    if (hour < 12) {
      greeting = 'Bonjour';
      emoji = '🌅';
    } else if (hour < 17) {
      greeting = 'Bon apre-midi';
      emoji = '☀️';
    } else {
      greeting = 'Bonswa';
      emoji = '🌙';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('$greeting,', style: AppTextStyles.headlineMedium),
            const SizedBox(width: 8),
            Text(emoji, style: const TextStyle(fontSize: 24)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          userName,
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
