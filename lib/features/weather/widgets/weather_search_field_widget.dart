import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/app_colors.dart';
import '../../../generated/locale_keys.g.dart';

/// The city TextField + search button row. Pure presentation — reports
/// back through [onSearch], doesn't know about cubits.
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
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => onSearch(),
            decoration: InputDecoration(
              hintText: LocaleKeys.search_hint.tr(),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        SizedBox(
          height: 50.r,
          width: 50.r,
          child: ElevatedButton(
            // Disabled while loading, so taps don't stack up.
            onPressed: loading ? null : onSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: loading
                ? SizedBox(
                    height: 18.h,
                    width: 18.h,
                    child: const CircularProgressIndicator.adaptive(),
                  )
                : Icon(Icons.search, color: Colors.white, size: 22.w),
          ),
        ),
      ],
    );
  }
}
