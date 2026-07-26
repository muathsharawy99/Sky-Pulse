import 'package:get_it/get_it.dart';

import '../../features/weather/manager/weather_cubit.dart';
import '../../features/weather/service/weather_service.dart';
import '../manager/settings_cubit.dart';

/// The get_it instance cubits are pulled from (`sl<WeatherCubit>()`),
/// used instead of `BlocProvider`/`context.read`.
final sl = GetIt.instance;

class ServicesLocator {
  void init() {
    // Singleton — settings apply app-wide, one instance for the app's life.
    sl.registerLazySingleton(() => SettingsCubit()..load());

    // Factory — fresh WeatherCubit per lookup, not shared state.
    sl.registerFactory(() => WeatherCubit(WeatherService()));
  }
}
