// ignore_for_file: must_be_immutable
import 'package:weather_app/core/shared/models/base.dart';

/// Maps the `location` object from WeatherAPI's `current.json` response.
class LocationModel extends Model {
  late final String name;
  late final String region;
  late final String country;
  late final double lat;
  late final double lon;
  late final String tzId;
  late final int localtimeEpoch;
  late final String localtime;

  LocationModel.fromJson([Map<String, dynamic>? json]) {
    name = stringFromJson(json, 'name');
    region = stringFromJson(json, 'region');
    country = stringFromJson(json, 'country');
    lat = doubleFromJson(json, 'lat');
    lon = doubleFromJson(json, 'lon');
    tzId = stringFromJson(json, 'tz_id');
    localtimeEpoch = intFromJson(json, 'localtime_epoch');
    localtime = stringFromJson(json, 'localtime');
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'region': region,
        'country': country,
        'lat': lat,
        'lon': lon,
        'tz_id': tzId,
        'localtime_epoch': localtimeEpoch,
        'localtime': localtime,
      };
}
