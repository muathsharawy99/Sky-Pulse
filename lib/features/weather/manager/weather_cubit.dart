import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import '../../../core/blocs/safe_cubit.dart';
import '../../../core/extensions/cubit_enums.dart';
import '../../../core/services/cache_helper.dart';
import '../../../generated/locale_keys.g.dart';
import '../data/weather_model.dart';
import '../service/weather_service.dart';

part 'weather_state.dart';

/// Takes a city name, fires the API request, and emits the [WeatherState]
/// the screen renders. Registered as a factory in the service locator and
/// wired to the UI via `BlocBuilder(bloc: ...)`, not `BlocProvider`.
class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._weatherService) : super(const WeatherState());

  final WeatherService _weatherService;

  // Plain field, not part of WeatherState — stays populated through
  // loading/error too, which is what lets the background theme keep the
  // previous city's colors instead of flashing neutral mid-search.
  WeatherModel? weatherModel;
  String lastSearchedCity = '';

  /// Validates input, skips redundant re-fetches, hits the API, and falls
  /// back to cached data on a connectivity error.
  Future<void> getWeather(String city) async {
    final trimmedCity = city.trim();
    if (trimmedCity.isEmpty) {
      emit(
        state.copyWith(
          status: RequestState.error,
          message: LocaleKeys.errors_emptyCity.tr(),
          errorType: ErrorType.emptyCity,
          isOffline: false,
        ),
      );
      return;
    }

    // Ignore taps while a request's already running.
    if (state.status.isLoading) return;

    // Skip re-fetching the same city that's already showing successfully
    // (still allows a retry if we're offline/showing stale cache).
    final isSameCity =
        trimmedCity.toLowerCase() == lastSearchedCity.toLowerCase();
    if (isSameCity && state.status.isDone && !state.isOffline) return;

    lastSearchedCity = trimmedCity;

    emit(
      state.copyWith(
        status: RequestState.loading,
        message: '',
        errorType: ErrorType.none,
      ),
    );

    final res = await _weatherService.getCurrentWeather(city: trimmedCity);

    if (!res.success) {
      // Network error specifically — fall back to cached data (offline
      // viewing) instead of a bare error screen.
      if (res.errType == ErrorType.network) {
        final cached = await CacheHelper.i.getLastWeather();
        if (cached != null) {
          weatherModel = WeatherModel.fromJson(cached);
          emit(
            state.copyWith(
              status: RequestState.done,
              message: res.msg,
              errorType: ErrorType.none,
              isOffline: true,
            ),
          );
          return;
        }
      }

      // No cache to fall back on — surface the real error.
      emit(
        state.copyWith(
          status: RequestState.error,
          message: res.msg,
          errorType: res.errType,
          isOffline: false,
        ),
      );
      return;
    }

    final data = Map<String, dynamic>.from(res.data ?? {});
    weatherModel = WeatherModel.fromJson(data);
    // Cache every successful lookup for offline viewing later.
    await CacheHelper.i.saveLastWeather(trimmedCity, data);

    emit(
      state.copyWith(
        status: RequestState.done,
        message: '',
        errorType: ErrorType.none,
        isOffline: false,
      ),
    );
  }

  /// Restores the last cached weather on cold start — called once from
  /// `initState()`.
  Future<void> loadCachedWeather() async {
    final cached = await CacheHelper.i.getLastWeather();
    if (cached == null) return;

    weatherModel = WeatherModel.fromJson(cached);
    lastSearchedCity =
        CacheHelper.i.getLastCity() ?? weatherModel!.location.name;

    // Marked offline until the user searches again.
    emit(state.copyWith(status: RequestState.done, isOffline: true));
  }
}
