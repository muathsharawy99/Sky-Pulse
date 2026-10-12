import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/extensions/unified_extensions.dart';

/// Icon + value + label (feels-like, humidity, wind).
class WeatherStatWidget extends StatelessWidget {
  const WeatherStatWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.valueColor,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final Color? valueColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: AppSize.s20, color: iconColor ?? context.primaryColor),
        SizedBox(height: AppSize.s4.h),
        Text(
          value,
          style: context.semiBold.copyWith(
            fontSize: FontSize.s13,
            color: valueColor ?? context.defaultTextColor,
          ),
        ),
        Text(
          label,
          style: context.regular.copyWith(
            fontSize: FontSize.s10,
            color: labelColor ?? context.secondaryTextColor,
          ),
        ),
      ],
    );
  }
}
