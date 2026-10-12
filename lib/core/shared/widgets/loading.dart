import 'package:flutter/material.dart';

import '../../extensions/unified_extensions.dart';

/// Adaptive loader (Cupertino on iOS / macOS). Use it for every loader
/// instead of the raw Flutter widgets.
class CustomProgress extends StatelessWidget {
  const CustomProgress({super.key, required this.size, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(color ?? context.primaryColor),
      ),
    );
  }
}

/// Loader shown while a weather fetch is in flight.
class LoadingApp extends StatelessWidget {
  const LoadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator.adaptive().center.withPadding(
      vertical: AppSize.s40,
    );
  }
}
