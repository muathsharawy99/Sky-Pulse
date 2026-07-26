import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/shared/widgets/custom_image.dart';

import '../../../core/extensions/speed_unit.dart';
import '../../../core/extensions/temp_unit.dart';
import '../../../core/extensions/text_style_extensions.dart';
import '../../../generated/locale_keys.g.dart';
import '../data/weather_model.dart';
import '../utils/weather_formatters.dart';
import '../utils/weather_theme.dart';

import 'offline_badge_widget.dart';
import 'weather_stat_widget.dart';

/// The main weather card — city name, temp, condition, icon, and stats.
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
    final isDay = weather.current.isDay;

    // Animated so the gradient crossfades between cities instead of
    // hard-cutting.
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: weatherGradient(isDay),
        borderRadius: BorderRadius.circular(20.r),
        // Faint outline so the card still reads as its own panel.
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isOffline) ...[
            const OfflineBadgeWidget(),
            SizedBox(height: 12.h),
          ],
          Text(
            '${weather.location.name}, ${weather.location.country}',
            textAlign: TextAlign.center,
            style: context.bold.copyWith(fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 12.h),
          // Condition icon straight from WeatherAPI's icon set.
          CustomImage(
            weather.current.condition.iconUrl,
            width: 80.w,
            height: 80.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 8.h),
          Text(
            formatTemperature(
              weather.current.tempC,
              weather.current.tempF,
              tempUnit,
            ),
            style: context.bold.copyWith(fontSize: 42, color: Colors.white),
          ),
          SizedBox(height: 4.h),
          Text(
            weather.current.condition.text,
            style: context.regular.copyWith(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          SizedBox(height: 16.h),
          Divider(color: Colors.white.withValues(alpha: 0.25)),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WeatherStatWidget(
                icon: Icons.thermostat,
                label: LocaleKeys.weather_feelsLike.tr(),
                value: formatTemperature(
                  weather.current.feelslikeC,
                  weather.current.feelslikeF,
                  tempUnit,
                ),
                iconColor: Colors.white,
                valueColor: Colors.white,
                labelColor: Colors.white.withValues(alpha: 0.75),
              ),
              WeatherStatWidget(
                icon: Icons.water_drop_outlined,
                label: LocaleKeys.weather_humidity.tr(),
                value: '${weather.current.humidity}%',
                iconColor: Colors.white,
                valueColor: Colors.white,
                labelColor: Colors.white.withValues(alpha: 0.75),
              ),
              WeatherStatWidget(
                icon: Icons.air,
                label: LocaleKeys.weather_wind.tr(),
                value: formatSpeed(
                  weather.current.windKph,
                  weather.current.windMph,
                  speedUnit,
                ),
                iconColor: Colors.white,
                valueColor: Colors.white,
                labelColor: Colors.white.withValues(alpha: 0.75),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
