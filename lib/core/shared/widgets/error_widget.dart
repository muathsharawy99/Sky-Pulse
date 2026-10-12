import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/locale_keys.g.dart';
import '../../extensions/unified_extensions.dart';

/// Error message + retry ("invalid city" and "request failed").
class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  final String title;
  final VoidCallback onTap;

  /// Overridden on the day / night background so it stays readable.
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline_rounded,
          color: context.errorColor,
          size: AppSize.s48,
        ),
        SizedBox(height: AppSize.s12.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.regular.copyWith(
            fontSize: FontSize.s14,
            color: textColor ?? context.secondaryTextColor,
          ),
        ),
        SizedBox(height: AppSize.s16.h),
        SizedBox(
          width: AppSize.s160.w,
          child: AppButton(
            label: LocaleKeys.errors_retry.tr(),
            icon: Icons.refresh,
            onPressed: onTap,
          ),
        ),
      ],
    ).withPadding(vertical: AppSize.s24.h, horizontal: AppSize.s8.w);
  }
}
