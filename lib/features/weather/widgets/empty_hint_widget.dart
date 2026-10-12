import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/extensions/unified_extensions.dart';
import 'package:weather_app/gen/locale_keys.g.dart';

/// Placeholder shown before the user has searched for a city.
class EmptyHintWidget extends StatelessWidget {
  const EmptyHintWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.wb_sunny_outlined,
          size: AppSize.s64,
          color: context.primaryColor.withValues(alpha: 0.5),
        ),
        SizedBox(height: AppSize.s12.h),
        Text(
          LocaleKeys.home_emptyStateHint.tr(),
          textAlign: TextAlign.center,
          style: context.regular.copyWith(
            fontSize: FontSize.s14,
            color: context.secondaryTextColor,
          ),
        ),
      ],
    ).withPadding(top: AppSize.s60.h);
  }
}
