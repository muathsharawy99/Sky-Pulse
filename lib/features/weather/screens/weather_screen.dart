import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/manager/settings_cubit.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/shared/widgets/app_error_widget.dart';
import '../../../core/shared/widgets/custom_image.dart';
import '../../../core/shared/widgets/loading_widget.dart';
import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../manager/weather_cubit.dart';
import '../utils/error_message_resolver.dart';
import '../utils/weather_theme.dart';
import '../widgets/empty_hint_widget.dart';
import '../widgets/settings_button_widget.dart';
import '../widgets/weather_card_widget.dart';
import '../widgets/weather_search_field_widget.dart';

/// The one and only screen in the app. Sub-widgets live in
/// features/weather/widgets/ to keep this file's build() readable.
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // Grabbed from get_it rather than BlocProvider — see service_locator.dart.
  late final WeatherCubit _cubit = sl<WeatherCubit>();
  late final SettingsCubit _settingsCubit = sl<SettingsCubit>();
  final TextEditingController _controller = TextEditingController();

  Locale? _lastLocale;

  @override
  void initState() {
    super.initState();
    _cubit.loadCachedWeather();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Clears the search field when the language changes. Not in
    // initState() — context.locale isn't available that early.
    final currentLocale = context.locale;
    if (_lastLocale != null && _lastLocale != currentLocale) {
      _controller.clear();
    }
    _lastLocale = currentLocale;
  }

  @override
  void dispose() {
    _cubit.close();
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    _cubit.getWeather(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      bloc: _cubit,
      builder: (context, state) {
        // Keyed off the weather model (not request status) so the
        // background keeps its theme through loading/errors instead of
        // flashing back to neutral.
        final showingWeather =
            state.status.isDone && _cubit.weatherModel != null;
        final isDay = _cubit.weatherModel?.current.isDay;
        final foreground = screenForegroundColor(isDay);

        return Scaffold(
          // Body draws behind the transparent AppBar so the gradient runs
          // edge-to-edge under the status bar.
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.all(8.w),
              child: CustomImage(
                Assets.images.appLogo.path,
                fit: BoxFit.contain,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            title: Text(LocaleKeys.home_title.tr()),
            backgroundColor: Colors.transparent,
            foregroundColor: foreground,
            elevation: 0,
            actions: const [SettingsButtonWidget()],
          ),
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: double.infinity,
            height: double.infinity,
            decoration:
                BoxDecoration(gradient: screenBackgroundGradient(isDay)),
            child: SafeArea(
              child: Padding(
                // SafeArea alone doesn't account for the AppBar's height
                // once it's behind the body — add it back manually.
                padding: EdgeInsets.only(top: kToolbarHeight),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  // Caps content width on tablets/large screens.
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 480.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        WeatherSearchFieldWidget(
                          controller: _controller,
                          onSearch: _search,
                          loading: state.status.isLoading,
                        ),
                        SizedBox(height: 24.h),
                        if (state.status.isLoading) const LoadingWidget(),
                        if (state.status.isError)
                          AppErrorWidget(
                            message: resolveErrorMessage(state.errorType),
                            onRetry: _search,
                            textColor: screenSecondaryForegroundColor(isDay),
                          ),
                        if (showingWeather)
                          // Nested so only the card rebuilds on unit changes.
                          BlocBuilder<SettingsCubit, SettingsState>(
                            bloc: _settingsCubit,
                            builder: (context, settingsState) {
                              return WeatherCardWidget(
                                weather: _cubit.weatherModel!,
                                isOffline: state.isOffline,
                                tempUnit: settingsState.tempUnit,
                                speedUnit: settingsState.speedUnit,
                              );
                            },
                          ),
                        if (state.status.isInitial) const EmptyHintWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
