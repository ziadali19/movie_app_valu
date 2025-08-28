import 'package:flutter/material.dart';

import 'colors.dart';
import 'styles.dart';

class Themes {
  static Themes themes = Themes._();

  Themes._();

  static Themes get instance => themes;

  ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: ColorsManager.primary,
        secondary: ColorsManager.secondary,
      ),
      appBarTheme: AppBarTheme(
        color: ColorsManager.secondary,
        centerTitle: true,
        titleTextStyle: TextStyles.font18Black500.copyWith(
          color: ColorsManager.primary,
          fontFamily: 'IBMPlexSans',
        ),
      ),
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'IBMPlexSans',
    );
  }
}
