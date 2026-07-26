import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'core/services/cache_helper.dart';
import 'core/services/service_locator.dart';

/// Everything that has to happen before `runApp`.
class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Independent of each other, so run in parallel.
    await Future.wait([
      EasyLocalization.ensureInitialized(),
      CacheHelper.i.init(),
    ]);

    // Must run after CacheHelper is ready — SettingsCubit reads from it.
    ServicesLocator().init();
  }
}
