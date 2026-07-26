import 'package:equatable/equatable.dart';

import '../blocs/safe_cubit.dart';
import '../extensions/speed_unit.dart';
import '../extensions/temp_unit.dart';
import '../services/cache_helper.dart';

part 'settings_state.dart';

/// Holds temp/speed unit preferences. Language isn't here — that's handled
/// by easy_localization directly.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  /// Loads saved units (or defaults) into state — called once on startup.
  Future<void> load() async {
    await CacheHelper.i.init();
    emit(
      state.copyWith(
        tempUnit: CacheHelper.i.getTempUnit(),
        speedUnit: CacheHelper.i.getSpeedUnit(),
      ),
    );
  }

  // Skips the emit if unchanged, to avoid a pointless rebuild.
  Future<void> setTempUnit(TempUnit tempUnit) async {
    if (tempUnit == state.tempUnit) return;
    emit(state.copyWith(tempUnit: tempUnit));
    await CacheHelper.i.saveTempUnit(tempUnit);
  }

  Future<void> setSpeedUnit(SpeedUnit speedUnit) async {
    if (speedUnit == state.speedUnit) return;
    emit(state.copyWith(speedUnit: speedUnit));
    await CacheHelper.i.saveSpeedUnit(speedUnit);
  }
}
