/// Same idea as [TempUnit] but for wind speed — kph vs mph.
enum SpeedUnit {
  kph,
  mph;

  bool get isKph => this == SpeedUnit.kph;

  bool get isMph => this == SpeedUnit.mph;
}
