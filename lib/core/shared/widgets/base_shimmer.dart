import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../resources/app_colors.dart';

/// Standard shimmer wrapper used for loading placeholders across the app.
class BaseShimmer extends StatelessWidget {
  const BaseShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.hoverColor,
      highlightColor: AppColors.background,
      child: child,
    );
  }
}
