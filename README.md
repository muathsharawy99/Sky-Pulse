# Sky Pulse

A clean, minimal weather app built with Flutter. Search any city and get its current conditions — temperature, weather description, and a live condition icon — with a background that shifts between a bright day theme and a dark night theme based on the actual time of day at that location.

## Features

- Search current weather by city name via [WeatherAPI](https://www.weatherapi.com/)
- Weather card with city name, temperature, condition text, and a condition icon
- Loading indicator while a search is in progress
- Error handling for invalid city names and network failures
- Offline support — the last successful search is cached and shown when there's no connection
- Day/night themed background and card, driven by the API's `is_day` value
- Adjustable units: Celsius/Fahrenheit and km/h/mph
- Full English/Arabic localization, including RTL support
- Responsive layout that scales from small phones to tablets

## Tech stack

- **State management:** flutter_bloc (Cubit)
- **Networking:** Dio
- **Dependency injection:** get_it
- **Localization:** easy_localization
- **Persistence:** shared_preferences (last weather result + unit preferences)
- **Image loading:** custom disk-cached network image loader (Dio + crypto for cache keys, magic-byte validation)
- **Responsive sizing:** flutter_screenutil

## Project structure

```
lib/
├── core/                  # Shared infrastructure: DI, caching, networking, theming, base widgets
└── features/
    └── weather/
        ├── data/           # WeatherModel, LocationModel, CurrentModel, ConditionModel
        ├── manager/        # WeatherCubit + WeatherState
        ├── screens/        # WeatherScreen
        ├── service/        # WeatherService (API calls)
        ├── utils/          # Formatters, error message resolver, theme helpers
        └── widgets/        # One widget per file (search field, card, stats, settings sheet, etc.)
```

## Getting started

1. Make sure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
2. Install dependencies:
   ```
   flutter pub get
   ```
3. Run the app:
   ```
   flutter run
   ```

The WeatherAPI key is already configured in `lib/core/services/server_gate.dart` for this task — no `.env` setup needed. In a production app this key would move to a backend/secure config instead of shipping in the client.

## Notes

- No third-party state management beyond flutter_bloc, as required by the task.
- Both bonus features (responsive design, offline caching) are implemented, along with a few extras: localization, unit preferences, and day/night theming.
