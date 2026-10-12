import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/extensions/unified_extensions.dart';
import 'package:weather_app/gen/locale_keys.g.dart';

/// Pill on the weather card when showing the last cached result.
class OfflineBadgeWidget extends StatelessWidget {
  const OfflineBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s10.w,
        vertical: AppSize.s4.h,
      ),
      decoration: BoxDecoration(
        color: context.errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSize.s20.r),
      ),
      child: Text(
        LocaleKeys.weather_offlineBadge.tr(),
        style: context.semiBold.copyWith(
          fontSize: FontSize.s11,
          color: context.errorColor,
        ),
      ),
    );
  }
}
