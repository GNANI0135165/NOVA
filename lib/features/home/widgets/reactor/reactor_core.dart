import 'package:flutter/material.dart';

import 'quantum_reactor_painter.dart';
import 'reactor_controller.dart';

class ReactorCore extends StatefulWidget {
  const ReactorCore({super.key});

  @override
  State<ReactorCore> createState() => _ReactorCoreState();
}

class _ReactorCoreState extends State<ReactorCore>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    ReactorStateBus.state.addListener(_stateChanged);
  }

  void _stateChanged() {
    final state = ReactorStateBus.state.value;

    switch (state) {
      case ReactorState.idle:
        controller.duration = const Duration(seconds: 20);
        break;

      case ReactorState.listening:
        controller.duration = const Duration(seconds: 11);
        break;

      case ReactorState.thinking:
        controller.duration = const Duration(seconds: 5);
        break;

      case ReactorState.speaking:
        controller.duration = const Duration(seconds: 8);
        break;
    }

    controller
      ..reset()
      ..repeat();
  }

  @override
  void dispose() {
    ReactorStateBus.state.removeListener(_stateChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final state = ReactorStateBus.state.value;

        final pulse = state == ReactorState.thinking
            ? (controller.value * 12) % 1
            : (controller.value * 4) % 1;

        return SizedBox(
          width: 360,
          height: 360,
          child: CustomPaint(
            painter: QuantumReactorPainter(
              rotation: controller.value,
              pulse: pulse,
              state: state,
            ),
          ),
        );
      },
    );
  }
}
