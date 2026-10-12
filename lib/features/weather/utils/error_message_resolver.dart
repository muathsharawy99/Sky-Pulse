import 'package:easy_localization/easy_localization.dart';
import 'package:weather_app/core/extensions/cubit_enums.dart';
import 'package:weather_app/gen/locale_keys.g.dart';

/// The localized message shown for an [ErrorType].
String resolveErrorMessage(ErrorType errorType) => switch (errorType) {
  ErrorType.emptyCity => LocaleKeys.errors_emptyCity.tr(),
  ErrorType.invalidCity => LocaleKeys.errors_cityNotFound.tr(),
  ErrorType.network => LocaleKeys.errors_network.tr(),
  _ => LocaleKeys.errors_unknown.tr(),
};
