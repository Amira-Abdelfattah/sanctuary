import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Public Sans type scale, mirroring the Stitch "Protective Serenity"
/// design tokens (headline-lg, headline-md, body-lg, body-md, label-md, label-sm).
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get headlineLg => GoogleFonts.publicSans(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 38 / 30,
        letterSpacing: -0.02,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineLgMobile => GoogleFonts.publicSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        letterSpacing: -0.01,
        color: AppColors.onSurface,
      );

  static TextStyle get headlineMd => GoogleFonts.publicSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyLg => GoogleFonts.publicSans(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 26 / 18,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyMd => GoogleFonts.publicSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.onSurface,
      );

  static TextStyle get labelMd => GoogleFonts.publicSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.01,
        color: AppColors.onSurface,
      );

  static TextStyle get labelSm => GoogleFonts.publicSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        letterSpacing: 0.04,
        color: AppColors.onSurfaceVariant,
      );
}
