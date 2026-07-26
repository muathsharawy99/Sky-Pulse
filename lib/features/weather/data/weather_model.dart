import '../../../core/shared/models/base.dart';
import 'current_model.dart';
import 'location_model.dart';

/// Root model for a single WeatherAPI `current.json` response — also
/// what gets cached to disk for offline viewing.
class WeatherModel extends Model {
  late final LocationModel location;
  late final CurrentModel current;

  WeatherModel.fromJson([Map<String, dynamic>? json]) {
    location = LocationModel.fromJson(json?['location'] ?? {});
    current = CurrentModel.fromJson(json?['current'] ?? {});
  }

  @override
  Map<String, dynamic> toJson() => {
        'location': location.toJson(),
        'current': current.toJson(),
      };
}
