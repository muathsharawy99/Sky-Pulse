import 'package:easy_localization/easy_localization.dart';

import '../../../core/extensions/cubit_enums.dart';
import '../../../generated/locale_keys.g.dart';

/// Maps a [ErrorType] to the localized message that should be shown for it —
/// pure lookup logic, kept out of the screen widget.
String resolveErrorMessage(ErrorType errorType) {
  switch (errorType) {
    case ErrorType.emptyCity:
      return LocaleKeys.errors_emptyCity.tr();
    case ErrorType.invalidCity:
      return LocaleKeys.errors_cityNotFound.tr();
    case ErrorType.network:
      return LocaleKeys.errors_network.tr();
    case ErrorType.server:
    case ErrorType.unknown:
    case ErrorType.none:
      return LocaleKeys.errors_unknown.tr();
  }
}
