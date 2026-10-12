enum RequestState {
  initial,
  loading,
  done,
  error,
  empty;

  bool get isInitial => this == RequestState.initial;
  bool get isLoading => this == RequestState.loading;
  bool get isDone => this == RequestState.done;
  bool get isError => this == RequestState.error;
  bool get isEmpty => this == RequestState.empty;
}

enum ErrorType {
  network,
  server,
  backEndValidation,
  unknown,
  none,
  unAuth,
  canceled,
  empty,

  /// The search field was empty.
  emptyCity,

  /// WeatherAPI couldn't find the city.
  invalidCity;

  bool get isNetwork => this == ErrorType.network;
  bool get isServer => this == ErrorType.server;
  bool get isUnknown => this == ErrorType.unknown;
  bool get isNone => this == ErrorType.none;
  bool get isEmptyCity => this == ErrorType.emptyCity;
  bool get isInvalidCity => this == ErrorType.invalidCity;
}
