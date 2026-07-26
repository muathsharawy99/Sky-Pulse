import 'package:easy_localization/easy_localization.dart';

import '../../../core/extensions/speed_unit.dart';
import '../../../core/extensions/temp_unit.dart';
import '../../../generated/locale_keys.g.dart';

/// Pure formatting logic for displaying weather values in the user's chosen
/// units — kept out of the widgets so the widgets stay presentation-only.
// No C/F suffix on purpose — just the number and °.
String formatTemperature(double celsius, double fahrenheit, TempUnit unit) {
  final value = unit.isCelsius ? celsius : fahrenheit;
  return '${value.toStringAsFixed(1)}°';
}

String formatSpeed(double kph, double mph, SpeedUnit unit) {
  final value = unit.isKph ? kph : mph;
  final suffix =
      unit.isKph ? LocaleKeys.weather_kph.tr() : LocaleKeys.weather_mph.tr();
  return '${value.toStringAsFixed(0)} $suffix';
}
