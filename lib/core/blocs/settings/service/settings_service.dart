import 'package:weather_app/core/services/shared_preference.dart';
import 'package:weather_app/core/shared/enums/speed_unit.dart';
import 'package:weather_app/core/shared/enums/temp_unit.dart';

/// Unit preferences on disk (defaults: celsius, km/h).
class SettingsService {
  TempUnit getTempUnit() =>
      TempUnit.fromName(CacheHelper.getValue(AppCached.tempUnit));

  SpeedUnit getSpeedUnit() =>
      SpeedUnit.fromName(CacheHelper.getValue(AppCached.speedUnit));

  Future<void> saveTempUnit(TempUnit unit) =>
      CacheHelper.setValue(AppCached.tempUnit, unit.name);

  Future<void> saveSpeedUnit(SpeedUnit unit) =>
      CacheHelper.setValue(AppCached.speedUnit, unit.name);
}
