import 'dart:developer';

import 'package:flutter/material.dart';

extension StringContext on String {
  /// `#2F80ED` / `2F80ED` → [Color] (used by `Model.colorFromJson`).
  Color get color {
    try {
      String colorStr = replaceAll("#", "");
      if (colorStr.length == 6) {
        colorStr = "FF$colorStr";
      }
      return Color(int.parse(colorStr, radix: 16));
    } catch (e) {
      log('Error parsing color: $e');
      return Colors.transparent;
    }
  }
}
