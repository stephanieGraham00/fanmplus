import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CycleProgressWidget extends StatelessWidget {
  final int cycleDay;
  final int cycleLength;
  final double size;
  final String? phaseName;

  const CycleProgressWidget({
    super.key,
    required this.cycleDay,
    required this.cycleLength,
    this.size = 200,
    this.phaseName,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (cycleDay / cycleLength).clamp(0.0, 1.0);
    final remaining = cycleLength - cycleDay;
    final phase = _getPhase();
    final percentComplete = (progress * 100).round();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _CyclePainter(
              progress: progress,
              phaseColor: phase.color,
              backgroundColor: AppColors.secondaryLight,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(phase.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 4),
              Text(
                'Day $cycleDay',
                style: AppTextStyles.cycleDayText.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                phase.name,
                style: AppTextStyles.bodySmall.copyWith(
                  color: phase.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$percentComplete% · $remaining ${remaining == 1 ? 'day' : 'days'} left',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _CyclePhase _getPhase() {
    if (phaseName != null) {
      if (phaseName == 'Peryòd' || phaseName == 'Period') return _CyclePhase('Period', '🌸', AppColors.period);
      if (phaseName == 'Ovilasyon' || phaseName == 'Ovulation') return _CyclePhase('Ovulation', '🌞', AppColors.ovulation);
      if (phaseName?.contains('Fetil') == true || phaseName?.contains('Fertile') == true) {
        return _CyclePhase('Fertile', '💛', AppColors.fertile);
      }
      if (phaseName == 'Faz Luteal' || phaseName == 'Luteal') return _CyclePhase('Luteal', '🌙', AppColors.luteal);
    }
    final ovDay = cycleLength - 14;
    if (cycleDay <= 5) return _CyclePhase('Period', '🌸', AppColors.period);
    if (cycleDay == ovDay) return _CyclePhase('Ovulation', '🌞', AppColors.ovulation);
    if (cycleDay >= ovDay - 5 && cycleDay <= ovDay + 1) {
      return _CyclePhase('Fertile', '💛', AppColors.fertile);
    }
    if (cycleDay > ovDay + 1) return _CyclePhase('Luteal', '🌙', AppColors.luteal);
    return _CyclePhase('Follicular', '🌱', AppColors.safe);
  }
}

class _CyclePhase {
  final String name;
  final String emoji;
  final Color color;
  _CyclePhase(this.name, this.emoji, this.color);
}

class _CyclePainter extends CustomPainter {
  final double progress;
  final Color phaseColor;
  final Color backgroundColor;

  _CyclePainter({
    required this.progress,
    required this.phaseColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = phaseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // Glow effect
    if (progress > 0) {
      final glowPaint = Paint()
        ..color = phaseColor.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CyclePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.phaseColor != phaseColor;
  }
}
