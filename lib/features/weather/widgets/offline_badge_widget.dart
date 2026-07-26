import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/text_style_extensions.dart';
import '../../../core/resources/app_colors.dart';
import '../../../generated/locale_keys.g.dart';

/// Small pill shown on the weather card when displaying the last cached
/// result because a fresh network fetch failed.
class OfflineBadgeWidget extends StatelessWidget {
  const OfflineBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        LocaleKeys.weather_offlineBadge.tr(),
        style: context.semiBold.copyWith(fontSize: 11, color: AppColors.error),
      ),
    );
  }
}
