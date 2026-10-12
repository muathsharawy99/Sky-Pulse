/// The user's wind speed unit — km/h or mph.
enum SpeedUnit {
  kph,
  mph;

  bool get isKph => this == SpeedUnit.kph;
  bool get isMph => this == SpeedUnit.mph;

  /// Saved name → unit; km/h when nothing is saved.
  static SpeedUnit fromName(Object? name) =>
      name == SpeedUnit.mph.name ? SpeedUnit.mph : SpeedUnit.kph;
}
