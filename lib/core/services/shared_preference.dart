import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setValue(String key, var value) async {
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }

  static dynamic getValue(String key) {
    return prefs.get(key);
  }
}

/// Keys kept from the old cache so saved data survives the update.
class AppCached {
  /// Last successful weather response (JSON) — offline viewing.
  static String lastWeather = 'last_weather_json';
  static String lastCity = 'last_weather_city';

  /// Unit preferences.
  static String tempUnit = 'app_temp_unit';
  static String speedUnit = 'app_speed_unit';
}
