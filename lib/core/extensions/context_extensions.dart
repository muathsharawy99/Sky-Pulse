import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../utils/theme/color/light_theme_color.dart';

extension ContextExtensions on BuildContext {
  /// Route arguments passed with `push(..., arg: {...})`.
  Map<dynamic, dynamic> get arg =>
      (ModalRoute.of(this)?.settings.arguments ?? {}) as Map<dynamic, dynamic>;

  bool get isArabic => locale == const Locale('ar');

  // --- Named styles (system font; default color = defaultTextColor) ---
  TextStyle _style(FontWeight weight) =>
      TextStyle(fontWeight: weight, color: defaultTextColor);

  TextStyle get regular => _style(FontWeight.w400);
  TextStyle get medium => _style(FontWeight.w500);
  TextStyle get semiBold => _style(FontWeight.w600);
  TextStyle get bold => _style(FontWeight.w700);

  // --- Colors ---
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get primaryDark => LightThemeColor().primaryDark;
  Color get onPrimary => LightThemeColor().onPrimary;
  Color get surfaceColor => LightThemeColor().surface;
  Color get defaultTextColor => LightThemeColor().defaultTextColor;
  Color get secondaryTextColor => LightThemeColor().secondaryText;
  Color get hoverColor => LightThemeColor().hoverColor;
  Color get placeholderColor => LightThemeColor().placeholder;
  Color get borderLightColor => LightThemeColor().borderLight;
  Color get errorColor => LightThemeColor().errorColor;
  Color get shadowColor => LightThemeColor().shadowColor;
}
