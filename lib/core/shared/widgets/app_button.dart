import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../extensions/unified_extensions.dart';

/// Shared primary button (error retry, settings Save).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s48.h,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.primaryColor,
          foregroundColor: context.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.radiusField.r),
          ),
        ),
        child: loading
            ? CustomProgress(size: AppSize.s20.h, color: context.onPrimary)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: AppSize.s18),
                    SizedBox(width: AppSize.s8.w),
                  ],
                  Text(
                    label,
                    style: context.semiBold.copyWith(
                      fontSize: FontSize.s15,
                      color: context.onPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
