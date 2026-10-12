/// WeatherAPI base url, key and endpoints.
class ApiConstants {
  static const String baseUrl = 'https://api.weatherapi.com/v1';

  // Hardcoded key — fine for this task, but in a real app this belongs
  // behind a backend/env config, not shipped in the client.
  static const String apiKey = '6f27a7b9512c4882a45162444252101';

  // ── Weather
  static const String currentWeather = 'current.json';
}
