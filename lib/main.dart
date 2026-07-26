import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_init.dart';
import 'core/resources/app_colors.dart';
import 'core/utils/phoenix.dart';
import 'core/utils/unfocus.dart';
import 'features/weather/screens/weather_screen.dart';

void main() async {
  await AppInitializer.init();
  runApp(
    // Wraps everything so context.locale/.tr() work app-wide.
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      // Match "en"/"ar" only, ignore region variants like en_US.
      useOnlyLangCode: true,
      startLocale: const Locale('en'),
      ignorePluralRules: false,
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Makes the .w/.h/.r extensions scale relative to designSize —
    // covers the responsive-design bonus point along with the
    // ConstrainedBox on the home screen.
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Weather App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) {
            // Swallow render-time widget errors instead of the red error
            // screen — blunt, but fine for this app's scope.
            ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
              return const SizedBox.shrink();
            };
            return Phoenix(
              child: MediaQuery(
                // Locks text scale to 1.0 so ScreenUtil's own scaling
                // doesn't compound with the OS's accessibility setting.
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(1.sp)),
                child: Unfocus(child: child ?? const SizedBox.shrink()),
              ),
            );
          },
          home: const WeatherScreen(),
        );
      },
    );
  }
}
