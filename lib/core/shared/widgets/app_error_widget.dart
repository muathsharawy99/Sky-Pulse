import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/locale_keys.g.dart';
import '../../extensions/text_style_extensions.dart';
import '../../resources/app_colors.dart';
import 'app_button.dart';

/// Shown for both "invalid city" and "request failed" errors.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.textColor = AppColors.textSecondary,
  });

  final String message;
  final VoidCallback onRetry;

  // Overridden by the weather screen on the dark/colorful theme so it
  // doesn't render dark-on-dark.
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 48,
          ),
          SizedBox(height: 12.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.regular.copyWith(
              fontSize: 14,
              color: textColor,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: 160.w,
            child: AppButton(
              label: LocaleKeys.errors_retry.tr(),
              icon: Icons.refresh,
              onPressed: onRetry,
            ),
          ),
        ],
      ),
    );
  }
}
