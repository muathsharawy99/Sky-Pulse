import 'package:get_it/get_it.dart';

import '../../features/weather/manager/weather_cubit.dart';
import '../../features/weather/service/weather_service.dart';
import '../blocs/settings/manager/settings_cubit.dart';
import '../blocs/settings/service/settings_service.dart';

final sl = GetIt.instance;

class ServicesLocator {
  void init() {
    //app-wide
    sl.registerLazySingleton(() => SettingsCubit(SettingsService())..load());

    //weather
    sl.registerFactory(() => WeatherCubit(WeatherService()));
  }
}
