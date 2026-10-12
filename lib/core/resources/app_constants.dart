import 'package:flutter/material.dart';

class AppConstants {
  /// The design frame the screens were drawn on.
  static const Size appSize = Size(390, 844);

  /// Content width cap on tablets / large screens.
  static const double maxContentWidth = 480;

  /// Background / card gradient cross-fade.
  static const themeAnimation = Duration(milliseconds: 500);

  /// WeatherAPI error codes meaning "city not found".
  static const invalidCityCodes = [1003, 1006];
}
