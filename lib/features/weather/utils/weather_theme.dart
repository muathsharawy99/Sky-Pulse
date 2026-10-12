import 'package:flutter/material.dart';
import 'package:weather_app/core/utils/theme/color/light_theme_color.dart';

/// Day / night gradient shared by the full-screen background and the card.
LinearGradient weatherGradient(bool isDay) {
  final colors = LightThemeColor();
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: isDay
        ? [colors.primary, colors.dayGradientEnd]
        : [colors.primaryDark, colors.nightGradientEnd],
  );
}

/// `isDay` is null until the first successful lookup — neutral background
/// only then; afterwards the last city's colors stay through loading / errors.
LinearGradient screenBackgroundGradient(bool? isDay) {
  if (isDay == null) {
    final background = LightThemeColor().scaffoldColor;
    return LinearGradient(colors: [background, background]);
  }
  return weatherGradient(isDay);
}

/// Text / icon color readable on [screenBackgroundGradient].
Color screenForegroundColor(bool? isDay) => isDay == null
    ? LightThemeColor().defaultTextColor
    : LightThemeColor().onPrimary;

/// Softer foreground (labels, hints) for the same background.
Color screenSecondaryForegroundColor(bool? isDay) => isDay == null
    ? LightThemeColor().secondaryText
    : LightThemeColor().onPrimary.withValues(alpha: 0.75);
