import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/extensions/unified_extensions.dart';
import 'package:weather_app/gen/locale_keys.g.dart';

/// City field + search button. Reports back through [onSearch].
class WeatherSearchFieldWidget extends StatelessWidget {
  const WeatherSearchFieldWidget({
    super.key,
    required this.controller,
    required this.onSearch,
    this.loading = false,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSize.radiusField.r);
    return Row(
      children: [
        TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => onSearch(),
          decoration: InputDecoration(
            hintText: LocaleKeys.search_hint.tr(),
            filled: true,
            fillColor: context.surfaceColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSize.s16.w,
              vertical: AppSize.s14.h,
            ),
            border: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
          ),
        ).expand(),
        SizedBox(width: AppSize.s10.w),
        SizedBox(
          height: AppSize.s50.r,
          width: AppSize.s50.r,
          child: ElevatedButton(
            // Disabled while loading, so taps don't stack up.
            onPressed: loading ? null : onSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: radius),
            ),
            child: loading
                ? CustomProgress(size: AppSize.s18.h)
                : Icon(
                    Icons.search,
                    color: context.onPrimary,
                    size: AppSize.s22.w,
                  ),
          ),
        ),
      ],
    );
  }
}
