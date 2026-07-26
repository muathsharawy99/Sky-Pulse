import '../../../core/shared/models/base.dart';
import 'condition_model.dart';

/// Everything under `current` in the API response — the "right now"
/// weather snapshot the app is built around.
class CurrentModel extends Model {
  late final int lastUpdatedEpoch;
  late final String lastUpdated;
  late final double tempC;
  late final double tempF;

  // Drives the day/night background theme — is it daytime at the
  // searched location, not the device's local time.
  late final bool isDay;
  late final ConditionModel condition;
  late final double windMph;
  late final double windKph;
  late final int windDegree;
  late final String windDir;
  late final int pressureMb;
  late final double pressureIn;
  late final double precipMm;
  late final double precipIn;
  late final int humidity;
  late final int cloud;
  late final double feelslikeC;
  late final double feelslikeF;
  late final double windchillC;
  late final double windchillF;
  late final double heatindexC;
  late final double heatindexF;
  late final double dewpointC;
  late final double dewpointF;
  late final double visKm;
  late final double visMiles;
  late final double uv;
  late final double gustMph;
  late final double gustKph;
  late final bool willItRain;
  late final int chanceOfRain;
  late final bool willItSnow;
  late final int chanceOfSnow;
  late final double wetbulbC;
  late final double wetbulbF;

  CurrentModel.fromJson([Map<String, dynamic>? json]) {
    lastUpdatedEpoch = intFromJson(json, 'last_updated_epoch');
    lastUpdated = stringFromJson(json, 'last_updated');
    tempC = doubleFromJson(json, 'temp_c');
    tempF = doubleFromJson(json, 'temp_f');
    isDay = boolFromJson(json, 'is_day');
    condition = ConditionModel.fromJson(json?['condition']);
    windMph = doubleFromJson(json, 'wind_mph');
    windKph = doubleFromJson(json, 'wind_kph');
    windDegree = intFromJson(json, 'wind_degree');
    windDir = stringFromJson(json, 'wind_dir');
    pressureMb = intFromJson(json, 'pressure_mb');
    pressureIn = doubleFromJson(json, 'pressure_in');
    precipMm = doubleFromJson(json, 'precip_mm');
    precipIn = doubleFromJson(json, 'precip_in');
    humidity = intFromJson(json, 'humidity');
    cloud = intFromJson(json, 'cloud');
    feelslikeC = doubleFromJson(json, 'feelslike_c');
    feelslikeF = doubleFromJson(json, 'feelslike_f');
    windchillC = doubleFromJson(json, 'windchill_c');
    windchillF = doubleFromJson(json, 'windchill_f');
    heatindexC = doubleFromJson(json, 'heatindex_c');
    heatindexF = doubleFromJson(json, 'heatindex_f');
    dewpointC = doubleFromJson(json, 'dewpoint_c');
    dewpointF = doubleFromJson(json, 'dewpoint_f');
    visKm = doubleFromJson(json, 'vis_km');
    visMiles = doubleFromJson(json, 'vis_miles');
    uv = doubleFromJson(json, 'uv');
    gustMph = doubleFromJson(json, 'gust_mph');
    gustKph = doubleFromJson(json, 'gust_kph');
    willItRain = boolFromJson(json, 'will_it_rain');
    chanceOfRain = intFromJson(json, 'chance_of_rain');
    willItSnow = boolFromJson(json, 'will_it_snow');
    chanceOfSnow = intFromJson(json, 'chance_of_snow');
    wetbulbC = doubleFromJson(json, 'wetbulb_c');
    wetbulbF = doubleFromJson(json, 'wetbulb_f');
  }

  @override
  Map<String, dynamic> toJson() => {
        'last_updated_epoch': lastUpdatedEpoch,
        'last_updated': lastUpdated,
        'temp_c': tempC,
        'temp_f': tempF,
        'is_day': isDay ? 1 : 0,
        'condition': condition.toJson(),
        'wind_mph': windMph,
        'wind_kph': windKph,
        'wind_degree': windDegree,
        'wind_dir': windDir,
        'pressure_mb': pressureMb,
        'pressure_in': pressureIn,
        'precip_mm': precipMm,
        'precip_in': precipIn,
        'humidity': humidity,
        'cloud': cloud,
        'feelslike_c': feelslikeC,
        'feelslike_f': feelslikeF,
        'windchill_c': windchillC,
        'windchill_f': windchillF,
        'heatindex_c': heatindexC,
        'heatindex_f': heatindexF,
        'dewpoint_c': dewpointC,
        'dewpoint_f': dewpointF,
        'vis_km': visKm,
        'vis_miles': visMiles,
        'uv': uv,
        'gust_mph': gustMph,
        'gust_kph': gustKph,
        'will_it_rain': willItRain ? 1 : 0,
        'chance_of_rain': chanceOfRain,
        'will_it_snow': willItSnow ? 1 : 0,
        'chance_of_snow': chanceOfSnow,
        'wetbulb_c': wetbulbC,
        'wetbulb_f': wetbulbF,
      };
}
