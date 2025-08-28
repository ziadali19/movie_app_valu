import 'package:flutter/material.dart';

import 'colors.dart';
import 'styles.dart';

class Themes {
  static Themes themes = Themes._();

  Themes._();

  static Themes get instance => themes;

  ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: ColorsManager.primary, // Red accent
        secondary: ColorsManager.secondary, // Dark gray
        background: ColorsManager.background, // Black
        surface: ColorsManager.surface, // Dark surface
        onPrimary: ColorsManager.onPrimary, // White on red
        onSecondary: ColorsManager.onSecondary, // White on dark
        onBackground: ColorsManager.textPrimary, // White on black
        onSurface: ColorsManager.textPrimary, // White on surface
      ),
      scaffoldBackgroundColor: ColorsManager.background,
      appBarTheme: AppBarTheme(
        backgroundColor: ColorsManager.background,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyles.font18Black500.copyWith(
          color: ColorsManager.textPrimary,
          fontFamily: 'IBMPlexSans',
        ),
        iconTheme: const IconThemeData(color: ColorsManager.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: ColorsManager.cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'IBMPlexSans',
    );
  }
}
