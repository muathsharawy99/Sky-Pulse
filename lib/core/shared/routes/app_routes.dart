import 'package:flutter/material.dart';

import '../../../features/weather/screens/weather_screen.dart';
import 'routes.dart';

class AppRoutes {
  static AppRoutes get init => AppRoutes._internal();

  String initial = NamedRoutes.weather;

  AppRoutes._internal();

  Map<String, Widget Function(BuildContext c)> appRoutes = {
    NamedRoutes.weather: (c) => const WeatherScreen(),
  };
}
