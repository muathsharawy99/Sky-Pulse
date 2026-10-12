import 'package:flutter/material.dart';

import 'color/light_theme_color.dart';

class LightTheme {
  static ThemeData getTheme() {
    final colors = LightThemeColor();
    return ThemeData(
      useMaterial3: true,
      primaryColor: colors.primary,
      scaffoldBackgroundColor: colors.scaffoldColor,
      colorScheme: ColorScheme.fromSeed(seedColor: colors.primary),
    );
  }
}
