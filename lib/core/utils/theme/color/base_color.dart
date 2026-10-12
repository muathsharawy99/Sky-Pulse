import 'package:flutter/material.dart';

abstract class BaseColor {
  // Brand
  Color get primary;
  Color get primaryDark;
  Color get onPrimary;

  // Surfaces
  Color get scaffoldColor;
  Color get surface;
  Color get hoverColor;
  Color get placeholder;
  Color get borderLight;

  // Text
  Color get defaultTextColor;
  Color get secondaryText;

  // Status
  Color get errorColor;
  Color get shadowColor;

  // Day / night weather gradients
  Color get dayGradientEnd;
  Color get nightGradientEnd;
}
