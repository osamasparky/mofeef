import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  // Headings with Reem Kufi (Authentic Saudi Heritage Branding)
  static TextStyle headingLarge = GoogleFonts.reemKufi(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle headingMedium = GoogleFonts.reemKufi(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle headingSmall = GoogleFonts.reemKufi(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Subtitles & Body with Tajawal (Crisp UI Readability)
  static TextStyle titleLarge = GoogleFonts.tajawal(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.tajawal(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle titleSmall = GoogleFonts.tajawal(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLarge = GoogleFonts.tajawal(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.tajawal(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.tajawal(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static TextStyle button = GoogleFonts.tajawal(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static TextStyle price = GoogleFonts.tajawal(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryGold,
  );
}
