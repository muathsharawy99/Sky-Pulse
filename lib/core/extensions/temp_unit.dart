/// The user's preferred temperature unit, set in settings and persisted.
enum TempUnit {
  celsius,
  fahrenheit;

  bool get isCelsius => this == TempUnit.celsius;

  bool get isFahrenheit => this == TempUnit.fahrenheit;
}
