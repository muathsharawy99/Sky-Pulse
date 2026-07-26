/// Generic request status shared by cubit states — an enum instead of a
/// pile of booleans, so you can't end up with isLoading + isError both true.
enum RequestState {
  initial,
  loading,
  done,
  error,
  empty;

  bool get isLoading => this == RequestState.loading;

  bool get isDone => this == RequestState.done;

  bool get isError => this == RequestState.error;

  bool get isInitial => this == RequestState.initial;

  bool get isEmpty => this == RequestState.empty;
}

/// What kind of error happened, so the UI shows a matching message
/// instead of one generic "something broke" for everything.
enum ErrorType {
  network,
  emptyCity,
  invalidCity,
  server,
  unknown,
  none;

  bool get isNetwork => this == ErrorType.network;

  bool get isEmptyCity => this == ErrorType.emptyCity;

  bool get isInvalidCity => this == ErrorType.invalidCity;

  bool get isServer => this == ErrorType.server;

  bool get isUnknown => this == ErrorType.unknown;

  bool get isNone => this == ErrorType.none;
}
