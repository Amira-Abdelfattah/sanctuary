import 'package:flutter/material.dart';

/// Design tokens extracted from the "Protective Serenity" design system.
/// Keeping every color in a single source of truth makes it trivial to
/// re-theme the whole app (e.g. dark mode) later.
class AppColors {
  AppColors._();

  // Surfaces
  static const Color surface = Color(0xFFFBF9F8);
  static const Color surfaceDim = Color(0xFFDBD9D9);
  static const Color surfaceBright = Color(0xFFFBF9F8);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF5F3F3);
  static const Color surfaceContainer = Color(0xFFEFEDED);
  static const Color surfaceContainerHigh = Color(0xFFEAE8E7);
  static const Color surfaceContainerHighest = Color(0xFFE4E2E2);

  // On-surface (text)
  static const Color onSurface = Color(0xFF1B1C1C);
  static const Color onSurfaceVariant = Color(0xFF42474C);
  static const Color inverseSurface = Color(0xFF303030);
  static const Color inverseOnSurface = Color(0xFFF2F0F0);

  // Outline
  static const Color outline = Color(0xFF73787D);
  static const Color outlineVariant = Color(0xFFC2C7CD);

  // Primary (Soft Blue)
  static const Color primary = Color(0xFF456277);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFA3C1DA);
  static const Color onPrimaryContainer = Color(0xFF324F65);
  static const Color inversePrimary = Color(0xFFACCAE3);

  // Secondary
  static const Color secondary = Color(0xFF5D5F5F);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFDFE0E0);
  static const Color onSecondaryContainer = Color(0xFF616363);

  // Tertiary (warm accent)
  static const Color tertiary = Color(0xFF7B5736);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFE3B48C);
  static const Color onTertiaryContainer = Color(0xFF674525);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Background
  static const Color background = Color(0xFFFBF9F8);
  static const Color onBackground = Color(0xFF1B1C1C);
  static const Color surfaceVariant = Color(0xFFE4E2E2);

  // Semantic status colors (muted, non-alarmist)
  static const Color safeGreen = Color(0xFF2E7D32);
  static const Color safeGreenBg = Color(0xFFE8F5E9);
  static const Color warningOrange = Color(0xFFB45309);
  static const Color warningOrangeBg = Color(0xFFFFF3E0);
  static const Color dangerRed = Color(0xFFBA1A1A);
  static const Color dangerRedBg = Color(0xFFFFDAD6);
}
