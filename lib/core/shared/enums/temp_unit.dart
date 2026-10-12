/// The user's temperature unit, set in settings and persisted.
enum TempUnit {
  celsius,
  fahrenheit;

  bool get isCelsius => this == TempUnit.celsius;
  bool get isFahrenheit => this == TempUnit.fahrenheit;

  /// Saved name → unit; celsius when nothing is saved.
  static TempUnit fromName(Object? name) =>
      name == TempUnit.fahrenheit.name ? TempUnit.fahrenheit : TempUnit.celsius;
}
