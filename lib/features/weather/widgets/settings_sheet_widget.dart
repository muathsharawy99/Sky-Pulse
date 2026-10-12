import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/blocs/settings/manager/settings_cubit.dart';
import 'package:weather_app/core/extensions/unified_extensions.dart';
import 'package:weather_app/core/services/service_locator.dart';
import 'package:weather_app/gen/locale_keys.g.dart';

/// Temperature unit, wind-speed unit and language — applied and saved
/// together only when Save is tapped.
class SettingsSheetWidget extends StatefulWidget {
  const SettingsSheetWidget({super.key});

  @override
  State<SettingsSheetWidget> createState() => _SettingsSheetWidgetState();
}

class _SettingsSheetWidgetState extends State<SettingsSheetWidget> {
  final SettingsCubit _settingsCubit = sl<SettingsCubit>();

  late TempUnit _pendingTempUnit = _settingsCubit.state.tempUnit;
  late SpeedUnit _pendingSpeedUnit = _settingsCubit.state.speedUnit;
  Locale? _pendingLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Not initState() — context.locale isn't available that early.
    _pendingLocale ??= context.locale;
  }

  void _save() {
    _settingsCubit.setTempUnit(_pendingTempUnit);
    _settingsCubit.setSpeedUnit(_pendingSpeedUnit);
    context.setLocale(_pendingLocale!);
    Navigator.of(context).pop();
  }

  Widget _label(String text) => Text(
    text,
    style: context.regular.copyWith(
      fontSize: FontSize.s13,
      color: context.secondaryTextColor,
    ),
  ).withPadding(bottom: AppSize.s8.h);

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: AppSize.s20.h);
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              LocaleKeys.settings_title.tr(),
              style: context.bold.copyWith(fontSize: FontSize.s18),
            ),
            gap,
            _label(LocaleKeys.settings_unitsLabel.tr()),
            SegmentedButton<TempUnit>(
              segments: [
                ButtonSegment(
                  value: TempUnit.celsius,
                  label: Text(LocaleKeys.weather_celsius.tr()),
                ),
                ButtonSegment(
                  value: TempUnit.fahrenheit,
                  label: Text(LocaleKeys.weather_fahrenheit.tr()),
                ),
              ],
              selected: {_pendingTempUnit},
              onSelectionChanged: (selection) =>
                  setState(() => _pendingTempUnit = selection.first),
            ),
            gap,
            _label(LocaleKeys.settings_speedUnitLabel.tr()),
            SegmentedButton<SpeedUnit>(
              segments: [
                ButtonSegment(
                  value: SpeedUnit.kph,
                  label: Text(LocaleKeys.weather_kph.tr()),
                ),
                ButtonSegment(
                  value: SpeedUnit.mph,
                  label: Text(LocaleKeys.weather_mph.tr()),
                ),
              ],
              selected: {_pendingSpeedUnit},
              onSelectionChanged: (selection) =>
                  setState(() => _pendingSpeedUnit = selection.first),
            ),
            gap,
            _label(LocaleKeys.settings_languageLabel.tr()),
            SegmentedButton<Locale>(
              segments: [
                ButtonSegment(
                  value: const Locale('en'),
                  label: Text(LocaleKeys.settings_englishLanguageName.tr()),
                ),
                ButtonSegment(
                  value: const Locale('ar'),
                  label: Text(LocaleKeys.settings_arabicLanguageName.tr()),
                ),
              ],
              selected: {_pendingLocale ?? context.locale},
              onSelectionChanged: (selection) =>
                  setState(() => _pendingLocale = selection.first),
            ),
            SizedBox(height: AppSize.s24.h),
            AppButton(
              label: LocaleKeys.settings_save.tr(),
              icon: Icons.check,
              onPressed: _save,
            ),
          ],
        ).withPadding(all: AppSize.screenPadding.w),
      ),
    );
  }
}
