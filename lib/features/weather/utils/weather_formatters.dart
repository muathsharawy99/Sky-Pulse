import 'package:easy_localization/easy_localization.dart';
import 'package:weather_app/core/shared/enums/speed_unit.dart';
import 'package:weather_app/core/shared/enums/temp_unit.dart';
import 'package:weather_app/gen/locale_keys.g.dart';

/// Weather values in the user's units. No C / F suffix on purpose — just
/// the number and °.
String formatTemperature(double celsius, double fahrenheit, TempUnit unit) {
  final value = unit.isCelsius ? celsius : fahrenheit;
  return '${value.toStringAsFixed(1)}°';
}

String formatSpeed(double kph, double mph, SpeedUnit unit) {
  final value = unit.isKph ? kph : mph;
  final suffix = unit.isKph
      ? LocaleKeys.weather_kph.tr()
      : LocaleKeys.weather_mph.tr();
  return '${value.toStringAsFixed(0)} $suffix';
}
