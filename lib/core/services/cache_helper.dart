import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../extensions/speed_unit.dart';
import '../extensions/temp_unit.dart';

/// Everything persisted to disk: the last successful weather lookup
/// (offline-viewing bonus feature) plus unit preferences. Backed by
/// shared_preferences.
class CacheHelper {
  CacheHelper._();

  static final CacheHelper i = CacheHelper._();

  static const String _lastWeatherKey = 'last_weather_json';
  static const String _lastCityKey = 'last_weather_city';
  static const String _tempUnitKey = 'app_temp_unit';
  static const String _speedUnitKey = 'app_speed_unit';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Stores the raw API response as a JSON string.
  Future<void> saveLastWeather(String city, Map<String, dynamic> json) async {
    await init();
    await _prefs!.setString(_lastCityKey, city);
    await _prefs!.setString(_lastWeatherKey, jsonEncode(json));
  }

  Future<Map<String, dynamic>?> getLastWeather() async {
    await init();
    final raw = _prefs!.getString(_lastWeatherKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return Map<String, dynamic>.from(jsonDecode(raw));
    } catch (_) {
      // Corrupted cache entry — treat as "nothing cached".
      return null;
    }
  }

  String? getLastCity() => _prefs?.getString(_lastCityKey);

  Future<void> saveTempUnit(TempUnit unit) async {
    await init();
    await _prefs!.setString(_tempUnitKey, unit.name);
  }

  // Defaults to celsius if nothing's saved yet.
  TempUnit getTempUnit() {
    final raw = _prefs?.getString(_tempUnitKey);
    return raw == TempUnit.fahrenheit.name
        ? TempUnit.fahrenheit
        : TempUnit.celsius;
  }

  Future<void> saveSpeedUnit(SpeedUnit unit) async {
    await init();
    await _prefs!.setString(_speedUnitKey, unit.name);
  }

  SpeedUnit getSpeedUnit() {
    final raw = _prefs?.getString(_speedUnitKey);
    return raw == SpeedUnit.mph.name ? SpeedUnit.mph : SpeedUnit.kph;
  }
}
