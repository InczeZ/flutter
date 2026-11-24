import 'package:flutter/material.dart';

import 'app_tokens.dart';

/// Az app [ThemeData]-jat epiti fel a design tokenekbol. A widgetek a
/// szovegstilusokat a `Theme.of(context).textTheme`-bol olvassak, nem
/// beegetett meretekkel dolgoznak.
abstract final class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      surface: AppColors.background,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: const TextTheme(
        // Oldalcim, pl. a recept neve.
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        // Kartya- es szekciocimek.
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        // Kiemelt ertekek, pl. kaloria es makro feliratok.
        titleSmall: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        // Torzsszoveg, pl. hozzavalok nevei.
        bodyMedium: TextStyle(
          fontSize: 15,
          height: 1.4,
          color: AppColors.textPrimary,
        ),
        // Masodlagos szoveg, pl. mennyisegek es feliratok.
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
        // Kis feliratok a makro gyuruk alatt es az also savban.
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
