import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/blocs/settings/manager/settings_cubit.dart';
import 'package:weather_app/core/blocs/settings/manager/settings_state.dart';
import 'package:weather_app/core/extensions/unified_extensions.dart';
import 'package:weather_app/core/services/service_locator.dart';
import 'package:weather_app/gen/assets.gen.dart';
import 'package:weather_app/gen/locale_keys.g.dart';

import '../manager/weather_cubit.dart';
import '../manager/weather_state.dart';
import '../utils/error_message_resolver.dart';
import '../utils/weather_theme.dart';
import '../widgets/empty_hint_widget.dart';
import '../widgets/settings_button_widget.dart';
import '../widgets/weather_card_widget.dart';
import '../widgets/weather_search_field_widget.dart';

/// Search a city and show its current weather.
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherCubit cubit = sl<WeatherCubit>();
  final SettingsCubit settingsCubit = sl<SettingsCubit>();
  final TextEditingController controller = TextEditingController();

  Locale? _lastLocale;

  @override
  void initState() {
    super.initState();
    cubit.loadCachedWeather();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Clear the search field when the language changes (context.locale
    // isn't available in initState).
    final currentLocale = context.locale;
    if (_lastLocale != null && _lastLocale != currentLocale) {
      controller.clear();
    }
    _lastLocale = currentLocale;
  }

  @override
  void dispose() {
    if (!cubit.isClosed) cubit.close();
    controller.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    cubit.getWeather(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      bloc: cubit,
      builder: (context, state) {
        // Keyed off the last weather (not the request status) so the
        // background keeps its theme through loading / errors.
        final weather = state.weather;
        final showingWeather = state.status.isDone && weather != null;
        final isDay = weather?.current.isDay;

        return Scaffold(
          // Body draws behind the transparent AppBar so the gradient runs
          // edge-to-edge under the status bar.
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: CustomImage(
              Assets.images.appLogo.path,
              borderRadius: BorderRadius.circular(AppSize.s8.r),
            ).withPadding(all: AppSize.s8.w),
            title: Text(LocaleKeys.home_title.tr()),
            backgroundColor: Colors.transparent,
            foregroundColor: screenForegroundColor(isDay),
            elevation: 0,
            actions: const [SettingsButtonWidget()],
          ),
          body: AnimatedContainer(
            duration: AppConstants.themeAnimation,
            curve: Curves.easeInOut,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: screenBackgroundGradient(isDay),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSize.screenPadding.w),
                // Caps content width on tablets / large screens.
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: AppConstants.maxContentWidth.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WeatherSearchFieldWidget(
                        controller: controller,
                        onSearch: _search,
                        loading: state.status.isLoading,
                      ),
                      SizedBox(height: AppSize.s24.h),
                      if (state.status.isLoading) const LoadingApp(),
                      if (state.status.isError)
                        CustomErrorWidget(
                          title: resolveErrorMessage(state.errorType),
                          onTap: _search,
                          textColor: screenSecondaryForegroundColor(isDay),
                        ),
                      if (showingWeather)
                        // Nested so only the card rebuilds on unit changes.
                        BlocBuilder<SettingsCubit, SettingsState>(
                          bloc: settingsCubit,
                          builder:
                              (context, settings) => WeatherCardWidget(
                                weather: weather,
                                isOffline: state.isOffline,
                                tempUnit: settings.tempUnit,
                                speedUnit: settings.speedUnit,
                              ),
                        ),
                      if (state.status.isInitial) const EmptyHintWidget(),
                    ],
                  ),
                ),
              ).withPadding(top: kToolbarHeight),
            ),
          ),
        );
      },
    );
  }
}
