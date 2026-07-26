import 'package:flutter_bloc/flutter_bloc.dart' as bloc;

/// Wrapper around `Cubit` that no-ops `emit` after close instead of
/// throwing — avoids a crash when an async call resolves after the screen
/// (and its cubit) is already disposed.
abstract class Cubit<State> extends bloc.Cubit<State> {
  Cubit(super.initialState);

  @override
  void emit(State state) {
    if (isClosed) return;
    super.emit(state);
  }
}
