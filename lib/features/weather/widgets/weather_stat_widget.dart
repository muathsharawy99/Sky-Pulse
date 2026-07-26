import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/text_style_extensions.dart';
import '../../../core/resources/app_colors.dart';

/// A single icon + value + label column used in the weather card's stats
/// row (feels-like, humidity, wind).
class WeatherStatWidget extends StatelessWidget {
  const WeatherStatWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = AppColors.primary,
    this.valueColor = AppColors.textPrimary,
    this.labelColor = AppColors.textSecondary,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color valueColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: iconColor),
        SizedBox(height: 4.h),
        Text(
          value,
          style: context.semiBold.copyWith(fontSize: 13, color: valueColor),
        ),
        Text(
          label,
          style: context.regular.copyWith(fontSize: 10, color: labelColor),
        ),
      ],
    );
  }
}
