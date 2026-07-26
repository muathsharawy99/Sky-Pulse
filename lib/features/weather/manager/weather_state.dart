part of 'weather_cubit.dart';

/// Everything the weather screen needs to render. `status` drives which
/// section shows; `isOffline` is separate since "done, but this is cached
/// data" still shows the normal card, just with a badge on top.
class WeatherState extends Equatable {
  const WeatherState({
    this.status = RequestState.initial,
    this.message = '',
    this.errorType = ErrorType.none,
    this.isOffline = false,
  });

  final RequestState status;
  final String message;
  final ErrorType errorType;

  // True when showing cached data because the live request failed.
  final bool isOffline;

  WeatherState copyWith({
    RequestState? status,
    String? message,
    ErrorType? errorType,
    bool? isOffline,
  }) {
    return WeatherState(
      status: status ?? this.status,
      message: message ?? this.message,
      errorType: errorType ?? this.errorType,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [status, message, errorType, isOffline];
}
