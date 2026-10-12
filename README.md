# Sky Pulse

A clean, minimal weather app built with Flutter. Search any city and get its current conditions — temperature, weather description, and a live condition icon — with a background that shifts between a bright day theme and a dark night theme based on the actual time of day at that location. It is available in **English and Arabic**.

## Features

- Search current weather by city name via [WeatherAPI](https://www.weatherapi.com/)
- Weather card with city name, temperature, condition text, condition icon, feels-like, humidity and wind
- Loading indicator while a search is in progress
- Error handling for empty input, invalid city names and network failures
- Offline support — the last successful search is cached and shown when there's no connection
- Day/night themed background and card, driven by the API's `is_day` value
- Adjustable units: Celsius/Fahrenheit and km/h/mph
- Full English/Arabic localization, including RTL support
- Responsive layout that scales from small phones to tablets

## Tech stack

| Concern | Package / approach |
|---|---|
| State management | `flutter_bloc` (Cubit) + `equatable` |
| Architecture | MVVM per feature: `service` → `manager` (cubit) → `screens` / `widgets` |
| Networking | `dio` behind a `ServerGate` singleton returning `CustomResponse<T>` |
| Dependency injection | `get_it` |
| Routing | Named routes (`NamedRoutes` + `AppRoutes`) |
| Local storage | `shared_preferences` via `CacheHelper` (last weather + unit preferences) |
| Localization | `easy_localization` with generated `LocaleKeys` |
| Responsive sizes | `flutter_screenutil` |
| Assets | `flutter_gen` |
| Images | `CustomImage` with a disk-cached network loader (Dio + `crypto` cache keys, magic-byte validation, `shimmer` placeholder) |

## Project structure

```
lib/
  core/
    blocs/          # safe Cubit + app-wide settings cubit (units)
    extensions/     # context, widget and string extensions (unified_extensions.dart barrel)
    resources/      # API constants, app constants, sizes, font sizes
    services/       # ServerGate (Dio), service locator, cache, bloc observer
    shared/         # enums (units, image type), base model, routes, reusable widgets
    utils/          # theme, colors, logger, phoenix, unfocus
  features/
    weather/
      data/models/  # WeatherModel, LocationModel, CurrentModel, ConditionModel
      manager/      # WeatherCubit + WeatherState
      screens/      # WeatherScreen
      service/      # WeatherService (API + offline cache)
      utils/        # formatters, error messages, day/night gradients
      widgets/      # search field, card, stats, settings sheet…
  gen/              # generated files — don't edit by hand
  main.dart
assets/
  images/  translations/ (en.json, ar.json)
```

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart run easy_localization:generate -S assets/translations -f keys -O lib/gen -o locale_keys.g.dart
flutter run
```

Before committing:

```bash
flutter analyze
```

The WeatherAPI key is configured in `lib/core/resources/api_constants.dart` for this task — no `.env` setup needed. In a production app this key would move to a backend/secure config instead of shipping in the client.

## Adding text

1. Add the key to **both** `assets/translations/en.json` and `ar.json`.
2. Regenerate the keys (command above).
3. Use it as `LocaleKeys.<key>.tr()`.

## Git

All work happens directly on `main` — no feature branches. Commits and pushes are done by the author.

## Author

**Muath Sharawy** — Flutter developer

- Email: muath0sharawy@gmail.com
- LinkedIn: [linkedin.com/in/muathsharawy99](https://linkedin.com/in/muathsharawy99)
- GitHub: [github.com/muathsharawy99](https://github.com/muathsharawy99)
- Portfolio: [muathsharawy.web.app](https://muathsharawy.web.app)
