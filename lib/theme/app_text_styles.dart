import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
    fontSize: 34, fontWeight: FontWeight.bold, color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
    fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary,
  );

  static TextStyle get displaySmall => GoogleFonts.playfairDisplay(
    fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get headlineLarge => GoogleFonts.quicksand(
    fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => GoogleFonts.quicksand(
    fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get headlineSmall => GoogleFonts.quicksand(
    fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get titleLarge => GoogleFonts.quicksand(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.quicksand(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get titleSmall => GoogleFonts.quicksand(
    fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.quicksand(
    fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.quicksand(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.quicksand(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
  );

  static TextStyle get labelLarge => GoogleFonts.quicksand(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get labelSmall => GoogleFonts.quicksand(
    fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textHint,
    letterSpacing: 0.5,
  );

  static TextStyle get gradientText => GoogleFonts.playfairDisplay(
    fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5,
  );

  static TextStyle get quoteText => GoogleFonts.playfairDisplay(
    fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.textPrimary,
    height: 1.4, fontStyle: FontStyle.italic,
  );

  static TextStyle get buttonText => GoogleFonts.quicksand(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white,
    letterSpacing: 0.5,
  );

  static TextStyle get countdownText => GoogleFonts.quicksand(
    fontSize: 42, fontWeight: FontWeight.bold, color: AppColors.primary,
  );

  static TextStyle get cycleDayText => GoogleFonts.quicksand(
    fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primary,
  );
}
