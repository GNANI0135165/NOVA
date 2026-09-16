import 'package:flutter/foundation.dart';

enum ReactorState {
  idle,
  listening,
  thinking,
  speaking,
}

class ReactorStateBus {
  static final ValueNotifier<ReactorState> state =
      ValueNotifier(ReactorState.idle);

  static void set(ReactorState newState) {
    state.value = newState;
  }
}
