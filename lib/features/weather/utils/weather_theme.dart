import 'package:flutter/material.dart';

import '../../../core/resources/app_colors.dart';

/// Day/night gradient palette, shared by the full-screen background and
/// the weather card so they read as one surface.
LinearGradient weatherGradient(bool isDay) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: isDay
        ? [AppColors.primary, const Color(0xFF56CCF2)]
        : [AppColors.primaryDark, const Color(0xFF05060F)],
  );
}

/// Full-screen version. `isDay` is null until the first successful lookup
/// — falls back to the neutral background only then, and otherwise keeps
/// the last city's colors through loading/errors so it never flashes grey.
LinearGradient screenBackgroundGradient(bool? isDay) {
  if (isDay == null) {
    return const LinearGradient(
      colors: [AppColors.background, AppColors.background],
    );
  }
  return weatherGradient(isDay);
}

/// Foreground (text/icon) color that stays legible against
/// [screenBackgroundGradient] for the same `isDay` value.
Color screenForegroundColor(bool? isDay) =>
    isDay == null ? AppColors.textPrimary : Colors.white;

/// Softer foreground color (labels, hints) for the same [screenBackgroundGradient].
Color screenSecondaryForegroundColor(bool? isDay) => isDay == null
    ? AppColors.textSecondary
    : Colors.white.withValues(alpha: 0.75);
