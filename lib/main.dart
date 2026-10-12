import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' as lang;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/extensions/unified_extensions.dart';
import 'core/services/bloc_observer.dart';
import 'core/services/service_locator.dart';
import 'core/services/shared_preference.dart';
import 'core/utils/phoenix.dart';
import 'core/utils/theme/light_theme.dart';
import 'core/utils/unfocus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Uncaught error: $error');
    debugPrintStack(stackTrace: stack);
    return true;
  };

  await Future.wait([
    lang.EasyLocalization.ensureInitialized(),
    ScreenUtil.ensureScreenSize(),
    CacheHelper.init(),
  ]);

  Bloc.observer = AppBlocObserver();
  // After CacheHelper — SettingsCubit reads the saved units.
  ServicesLocator().init();
  runApp(const SkyPulse());
}

class SkyPulse extends StatelessWidget {
  const SkyPulse({super.key});

  @override
  Widget build(BuildContext context) {
    return lang.EasyLocalization(
      path: 'assets/translations',
      // Match "en" / "ar" only, ignore region variants like en_US.
      useOnlyLangCode: true,
      ignorePluralRules: false,
      startLocale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      child: ScreenUtilInit(
        designSize: AppConstants.appSize,
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Sky Pulse',
            themeMode: ThemeMode.light,
            initialRoute: AppRoutes.init.initial,
            routes: AppRoutes.init.appRoutes,
            navigatorKey: navigator,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: LightTheme.getTheme(),
            builder: (context, child) {
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                FlutterError.dumpErrorToConsole(errorDetails);
                if (kReleaseMode) {
                  return const SizedBox.shrink();
                }
                return ErrorWidget(errorDetails.exception);
              };
              return Phoenix(
                child: MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(1.sp)),
                  child: Unfocus(child: child ?? const SizedBox.shrink()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
