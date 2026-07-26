import 'package:easy_localization/easy_localization.dart';

import '../../../core/services/server_gate.dart';
import '../../../generated/locale_keys.g.dart';

/// Thin wrapper around [ServerGate] for the one endpoint this app needs.
class WeatherService {
  Future<CustomResponse> getCurrentWeather({required String city}) async {
    final response = await ServerGate.i.getFromServer(
      url: 'current.json',
      params: {
        'q': city,
        // Localizes the condition text to the app's current language.
        'lang': LocaleKeys.static_lang.tr(),
      },
    );
    return response;
  }
}
