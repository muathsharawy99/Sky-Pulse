import 'package:flutter/material.dart';

import 'base_color.dart';

/// Sky Pulse palette (blue #2F80ED, night navy #1B1F3B).
class LightThemeColor extends BaseColor {
  // ── Brand
  @override
  Color get primary => const Color(0xFF2F80ED);
  @override
  Color get primaryDark => const Color(0xFF1B1F3B);
  @override
  Color get onPrimary => const Color(0xFFFFFFFF);

  // ── Surfaces
  @override
  Color get scaffoldColor => const Color(0xFFF3F6FD);
  @override
  Color get surface => const Color(0xFFFFFFFF);
  @override
  Color get hoverColor => const Color(0xFFE0E3E9);
  @override
  Color get placeholder => const Color(0xFFE0E0E0);
  @override
  Color get borderLight => const Color(0xFFEEEEEE);

  // ── Text
  @override
  Color get defaultTextColor => const Color(0xFF1B1F3B);
  @override
  Color get secondaryText => const Color(0xFF6B7280);

  // ── Status
  @override
  Color get errorColor => const Color(0xFFE94E4E);
  @override
  Color get shadowColor => const Color(0xFF000000);

  // ── Day / night weather gradients (start = primary / primaryDark)
  @override
  Color get dayGradientEnd => const Color(0xFF56CCF2);
  @override
  Color get nightGradientEnd => const Color(0xFF05060F);
}
