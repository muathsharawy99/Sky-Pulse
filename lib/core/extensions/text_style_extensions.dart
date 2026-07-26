import 'package:flutter/material.dart';

import '../resources/app_colors.dart';

/// Named text-style shortcuts, mirroring the `context.regular` /
/// `context.semiBold` pattern from other projects. Uses the system default
/// font (this project has no bundled custom font) and [AppColors.textPrimary]
/// as the default color — override with `.copyWith(...)` where needed.
extension TextStyleContextExtension on BuildContext {
  TextStyle get regular =>
      const TextStyle(fontWeight: FontWeight.w400, color: AppColors.textPrimary);

  TextStyle get medium =>
      const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary);

  TextStyle get semiBold =>
      const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  TextStyle get bold =>
      const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary);
}
