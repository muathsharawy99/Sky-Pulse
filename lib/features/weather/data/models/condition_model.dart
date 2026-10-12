// ignore_for_file: must_be_immutable
import 'package:weather_app/core/shared/models/base.dart';

/// The `condition` object nested inside `current` — description text,
/// icon, and WeatherAPI's numeric condition code.
class ConditionModel extends Model {
  late final String text;

  // Raw value from the API, untouched.
  late final String icon;

  // The actual usable URL — API returns icon as "//cdn.../icon.png" with
  // no scheme, so it needs "https:" prefixed before an Image can load it.
  late final String iconUrl;
  late final int code;

  ConditionModel.fromJson([Map<String, dynamic>? json]) {
    text = stringFromJson(json, 'text');
    icon = stringFromJson(json, 'icon');
    iconUrl = icon.startsWith('//') ? 'https:$icon' : icon;
    code = intFromJson(json, 'code');
  }

  @override
  Map<String, dynamic> toJson() => {
        'text': text,
        'icon': icon,
        'code': code,
      };
}
