import 'package:flutter/material.dart';

/// Design tokenek a Meal Planner App UI Kitbol (Figma), szerep szerint
/// elnevezve, nem kinezet szerint. A Figma frame-ek 220 egyseg szelesek,
/// ezert a meretek egy 375 logikai pixeles telefonra vannak skalazva (kb. 1.7x).
abstract final class AppColors {
  static const primary = Color(0xFF8B5CF6);
  static const onPrimary = Color(0xFFFFFFFF);
  static const link = Color(0xFF2F80ED);

  static const background = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF4F4F6);
  static const border = Color(0xFFE2E2E6);
  static const ringTrack = Color(0xFFEDEDF0);

  static const textPrimary = Color(0xFF111111);
  static const textSecondary = Color(0xFF8E8E93);
  static const textDisabled = Color(0xFFC4C4C8);

  static const favorite = Color(0xFFE5484D);

  static const macroFat = Color(0xFFFFB443);
  static const macroProtein = Color(0xFF3B82F6);
  static const macroCarbs = Color(0xFF7B61FF);
}

/// Terkoz skala 4 tobbszoroseire epitve.
abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

abstract final class AppRadius {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const sheet = 20.0;
  static const pill = 999.0;
}
