import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFFFF5FA2);
  static const Color primaryLight = Color(0xFFFF8FC2);
  static const Color primaryDark = Color(0xFFD81B60);

  // Secondary palette
  static const Color secondary = Color(0xFFD8B4FE);
  static const Color secondaryLight = Color(0xFFF0E6FF);
  static const Color secondaryDark = Color(0xFF9C27B0);

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFCFAFF);
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF16213E);

  // Text
  static const Color textPrimary = Color(0xFF2D1B69);
  static const Color textSecondary = Color(0xFF7C6BA0);
  static const Color textHint = Color(0xFFB8A9D4);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Cycle phases
  static const Color period = Color(0xFFFF5FA2);
  static const Color fertile = Color(0xFF7C4DFF);
  static const Color ovulation = Color(0xFFFFAB00);
  static const Color safe = Color(0xFF4CAF50);
  static const Color luteal = Color(0xFF7881FF);

  // Gradient colors
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF5FA2), Color(0xFFD8B4FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient purpleGradient = LinearGradient(
    colors: [Color(0xFFD8B4FE), Color(0xFF9C27B0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF5FA2), Color(0xFFFF8FC2), Color(0xFFD8B4FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFF5F9), Color(0xFFF5EEFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glassmorphism
  static final Color glassLight = Colors.white.withOpacity(0.5);
  static final Color glassBorder = Colors.white.withOpacity(0.3);
}
