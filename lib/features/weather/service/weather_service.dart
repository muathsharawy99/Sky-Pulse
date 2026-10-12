import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:weather_app/core/resources/api_constants.dart';
import 'package:weather_app/core/services/server_gate.dart';
import 'package:weather_app/core/services/shared_preference.dart';
import 'package:weather_app/gen/locale_keys.g.dart';

/// Current weather from WeatherAPI + the last successful response on disk
/// (offline viewing).
class WeatherService {
  Future<CustomResponse<Map<String, dynamic>>> getCurrentWeather({
    required String city,
  }) => ServerGate.i.getFromServer<Map<String, dynamic>>(
    url: ApiConstants.currentWeather,
    params: {
      'q': city,
      // Localizes the condition text to the app's current language.
      'lang': LocaleKeys.static_lang.tr(),
    },
  );

  Future<void> saveLastWeather(String city, Map<String, dynamic> json) async {
    await CacheHelper.setValue(AppCached.lastCity, city);
    await CacheHelper.setValue(AppCached.lastWeather, jsonEncode(json));
  }

  /// Null when nothing is saved or the saved entry is corrupted.
  Map<String, dynamic>? getLastWeather() {
    final raw = CacheHelper.getValue(AppCached.lastWeather);
    if (raw is! String || raw.isEmpty) return null;
    try {
      return Map<String, dynamic>.from(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  String? getLastCity() {
    final city = CacheHelper.getValue(AppCached.lastCity);
    return city is String ? city : null;
  }
}
