import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/speed_unit.dart';
import '../../../core/extensions/temp_unit.dart';
import '../../../core/extensions/text_style_extensions.dart';
import '../../../core/manager/settings_cubit.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/shared/widgets/app_button.dart';
import '../../../generated/locale_keys.g.dart';

/// Bottom-sheet body for the settings icon: lets the user pick a pending
/// temperature unit, wind-speed unit, and language, applying/persisting all
/// three only when Save is tapped.
class SettingsSheetWidget extends StatefulWidget {
  const SettingsSheetWidget({super.key});

  @override
  State<SettingsSheetWidget> createState() => _SettingsSheetWidgetState();
}

class _SettingsSheetWidgetState extends State<SettingsSheetWidget> {
  late final SettingsCubit _settingsCubit = sl<SettingsCubit>();

  // "Pending" — nothing here takes effect until Save is tapped.
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys.settings_title.tr(),
                style: context.bold.copyWith(fontSize: 18),
              ),
              SizedBox(height: 20.h),
              Text(
                LocaleKeys.settings_unitsLabel.tr(),
                style: context.regular.copyWith(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
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
              SizedBox(height: 20.h),
              Text(
                LocaleKeys.settings_speedUnitLabel.tr(),
                style: context.regular.copyWith(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
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
              SizedBox(height: 20.h),
              Text(
                LocaleKeys.settings_languageLabel.tr(),
                style: context.regular.copyWith(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
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
              SizedBox(height: 24.h),
              AppButton(
                label: LocaleKeys.settings_save.tr(),
                icon: Icons.check,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
