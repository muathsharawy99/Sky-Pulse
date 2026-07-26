import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/text_style_extensions.dart';
import '../../../core/resources/app_colors.dart';
import '../../../generated/locale_keys.g.dart';

/// Placeholder shown before the user has searched for a city.
class EmptyHintWidget extends StatelessWidget {
  const EmptyHintWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 60.h),
      child: Column(
        children: [
          Icon(
            Icons.wb_sunny_outlined,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
          SizedBox(height: 12.h),
          Text(
            LocaleKeys.home_emptyStateHint.tr(),
            textAlign: TextAlign.center,
            style: context.regular.copyWith(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
