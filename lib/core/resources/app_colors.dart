import 'package:flutter/material.dart';

/// Every named color in the app lives here.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2F80ED);
  static const Color primaryDark = Color(0xFF1B1F3B);
  static const Color background = Color(0xFFF3F6FD);

  // Unused currently — card switched to the day/night gradient instead.

  static const Color error = Color(0xFFE94E4E);
  static const Color textPrimary = Color(0xFF1B1F3B);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color hoverColor = Color(0xFFE0E3E9);
}

extension AppColorsContextExtension on BuildContext {
  Color get hoverColor => AppColors.hoverColor;
}
