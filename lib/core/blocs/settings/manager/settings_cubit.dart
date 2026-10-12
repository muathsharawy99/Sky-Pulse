import 'package:weather_app/core/blocs/safe_cubit.dart';
import 'package:weather_app/core/shared/enums/speed_unit.dart';
import 'package:weather_app/core/shared/enums/temp_unit.dart';

import '../service/settings_service.dart';
import 'settings_state.dart';

/// App-wide temp / speed unit preferences. Language is handled by
/// easy_localization directly.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._service) : super(const SettingsState());

  final SettingsService _service;

  /// Loads the saved units — called once when the cubit is created.
  void load() => emit(
    state.copyWith(
      tempUnit: _service.getTempUnit(),
      speedUnit: _service.getSpeedUnit(),
    ),
  );

  Future<void> setTempUnit(TempUnit tempUnit) async {
    if (tempUnit == state.tempUnit) return;
    emit(state.copyWith(tempUnit: tempUnit));
    await _service.saveTempUnit(tempUnit);
  }

  Future<void> setSpeedUnit(SpeedUnit speedUnit) async {
    if (speedUnit == state.speedUnit) return;
    emit(state.copyWith(speedUnit: speedUnit));
    await _service.saveSpeedUnit(speedUnit);
  }
}
