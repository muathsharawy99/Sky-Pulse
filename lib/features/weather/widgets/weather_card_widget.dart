import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/extensions/unified_extensions.dart';
import 'package:weather_app/gen/locale_keys.g.dart';

import '../data/models/weather_model.dart';
import '../utils/weather_formatters.dart';
import '../utils/weather_theme.dart';
import 'offline_badge_widget.dart';
import 'weather_stat_widget.dart';

/// City, temperature, condition, icon and stats on the day / night gradient.
class WeatherCardWidget extends StatelessWidget {
  const WeatherCardWidget({
    super.key,
    required this.weather,
    required this.tempUnit,
    required this.speedUnit,
    this.isOffline = false,
  });

  final WeatherModel weather;
  final TempUnit tempUnit;
  final SpeedUnit speedUnit;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final onCard = context.onPrimary;
    final mutedOnCard = onCard.withValues(alpha: 0.75);

    // Animated so the gradient cross-fades between cities.
    return AnimatedContainer(
      duration: AppConstants.themeAnimation,
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.s20.w),
      decoration: BoxDecoration(
        gradient: weatherGradient(current.isDay),
        borderRadius: BorderRadius.circular(AppSize.radiusCard.r),
        border: Border.all(color: onCard.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor.withValues(alpha: 0.12),
            blurRadius: AppSize.s16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isOffline) ...[
            const OfflineBadgeWidget(),
            SizedBox(height: AppSize.s12.h),
          ],
          Text(
            '${weather.location.name}, ${weather.location.country}',
            textAlign: TextAlign.center,
            style: context.bold.copyWith(fontSize: FontSize.s20, color: onCard),
          ),
          SizedBox(height: AppSize.s12.h),
          CustomImage(
            current.condition.iconUrl,
            width: AppSize.s80.w,
            height: AppSize.s80.w,
          ),
          SizedBox(height: AppSize.s8.h),
          Text(
            formatTemperature(current.tempC, current.tempF, tempUnit),
            style: context.bold.copyWith(fontSize: FontSize.s42, color: onCard),
          ),
          SizedBox(height: AppSize.s4.h),
          Text(
            current.condition.text,
            style: context.regular.copyWith(
              fontSize: FontSize.s16,
              color: onCard.withValues(alpha: 0.85),
            ),
          ),
          SizedBox(height: AppSize.s16.h),
          Divider(color: onCard.withValues(alpha: 0.25)),
          SizedBox(height: AppSize.s12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WeatherStatWidget(
                icon: Icons.thermostat,
                label: LocaleKeys.weather_feelsLike.tr(),
                value: formatTemperature(
                  current.feelslikeC,
                  current.feelslikeF,
                  tempUnit,
                ),
                iconColor: onCard,
                valueColor: onCard,
                labelColor: mutedOnCard,
              ),
              WeatherStatWidget(
                icon: Icons.water_drop_outlined,
                label: LocaleKeys.weather_humidity.tr(),
                value: '${current.humidity}%',
                iconColor: onCard,
                valueColor: onCard,
                labelColor: mutedOnCard,
              ),
              WeatherStatWidget(
                icon: Icons.air,
                label: LocaleKeys.weather_wind.tr(),
                value: formatSpeed(current.windKph, current.windMph, speedUnit),
                iconColor: onCard,
                valueColor: onCard,
                labelColor: mutedOnCard,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
