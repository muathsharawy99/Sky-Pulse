import 'package:easy_localization/easy_localization.dart';
import 'package:weather_app/core/blocs/safe_cubit.dart';
import 'package:weather_app/core/extensions/cubit_enums.dart';
import 'package:weather_app/gen/locale_keys.g.dart';

import '../data/models/weather_model.dart';
import '../service/weather_service.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._service) : super(const WeatherState());

  final WeatherService _service;

  String lastSearchedCity = '';

  /// Validates input, skips redundant re-fetches, hits the API, and falls
  /// back to cached data on a connectivity error.
  Future<void> getWeather(String city) async {
    final trimmedCity = city.trim();
    if (trimmedCity.isEmpty) {
      emit(
        state.copyWith(
          status: RequestState.error,
          msg: LocaleKeys.errors_emptyCity.tr(),
          errorType: ErrorType.emptyCity,
          isOffline: false,
        ),
      );
      return;
    }

    // Ignore taps while a request is already running.
    if (state.status.isLoading) return;

    // Same city already showing live data → nothing to do (a retry is
    // still allowed while offline / showing the cache).
    final isSameCity =
        trimmedCity.toLowerCase() == lastSearchedCity.toLowerCase();
    if (isSameCity && state.status.isDone && !state.isOffline) return;

    lastSearchedCity = trimmedCity;
    emit(
      state.copyWith(
        status: RequestState.loading,
        msg: '',
        errorType: ErrorType.none,
      ),
    );

    final res = await _service.getCurrentWeather(city: trimmedCity);

    if (!res.success) {
      // No internet → show the last saved weather instead of an error.
      final cached = res.errType.isNetwork ? _service.getLastWeather() : null;
      if (cached != null) {
        emit(
          state.copyWith(
            status: RequestState.done,
            msg: res.msg,
            errorType: ErrorType.none,
            isOffline: true,
            weather: WeatherModel.fromJson(cached),
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          status: RequestState.error,
          msg: res.msg,
          errorType: res.errType,
          isOffline: false,
        ),
      );
      return;
    }

    final data = Map<String, dynamic>.from(res.data ?? {});
    await _service.saveLastWeather(trimmedCity, data);
    emit(
      state.copyWith(
        status: RequestState.done,
        msg: '',
        errorType: ErrorType.none,
        isOffline: false,
        weather: WeatherModel.fromJson(data),
      ),
    );
  }

  /// Restores the last cached weather on cold start (marked offline until
  /// the user searches again).
  void loadCachedWeather() {
    final cached = _service.getLastWeather();
    if (cached == null) return;
    final weather = WeatherModel.fromJson(cached);
    lastSearchedCity = _service.getLastCity() ?? weather.location.name;
    emit(
      state.copyWith(
        status: RequestState.done,
        isOffline: true,
        weather: weather,
      ),
    );
  }
}
