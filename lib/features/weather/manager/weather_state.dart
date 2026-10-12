import 'package:equatable/equatable.dart';
import 'package:weather_app/core/extensions/cubit_enums.dart';

import '../data/models/weather_model.dart';

/// `status` drives which section shows; `isOffline` means "done, but this
/// is cached data" (normal card + a badge).
class WeatherState extends Equatable {
  const WeatherState({
    this.status = RequestState.initial,
    this.msg = '',
    this.errorType = ErrorType.none,
    this.isOffline = false,
    this.weather,
  });

  final RequestState status;
  final String msg;
  final ErrorType errorType;
  final bool isOffline;

  /// The last weather shown. Kept through loading / errors so the
  /// background keeps the previous city's day / night colors.
  final WeatherModel? weather;

  WeatherState copyWith({
    RequestState? status,
    String? msg,
    ErrorType? errorType,
    bool? isOffline,
    WeatherModel? weather,
  }) => WeatherState(
    status: status ?? this.status,
    msg: msg ?? this.msg,
    errorType: errorType ?? this.errorType,
    isOffline: isOffline ?? this.isOffline,
    weather: weather ?? this.weather,
  );

  @override
  List<Object?> get props => [
    status,
    msg,
    errorType,
    isOffline,
    weather?.toString(),
  ];
}
