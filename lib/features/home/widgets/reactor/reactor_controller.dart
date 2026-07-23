// lib/features/home/widgets/reactor/reactor_controller.dart

import 'package:flutter/material.dart';

enum ReactorState {
  idle,
  listening,
  thinking,
  speaking,
}

class ReactorController {
  ReactorState state = ReactorState.idle;

  late final AnimationController rotationController;
  late final AnimationController pulseController;
  late final AnimationController orbitController;

  ReactorController({
    required TickerProvider vsync,
  }) {
    rotationController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 18),
    )..repeat();

    pulseController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1800),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true);

    orbitController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  void setState(ReactorState newState) {
    state = newState;

    switch (state) {
      case ReactorState.idle:
        rotationController.duration = const Duration(seconds: 18);
        break;

      case ReactorState.listening:
        rotationController.duration = const Duration(seconds: 10);
        break;

      case ReactorState.thinking:
        rotationController.duration = const Duration(seconds: 4);
        break;

      case ReactorState.speaking:
        rotationController.duration = const Duration(seconds: 7);
        break;
    }

    rotationController
      ..reset()
      ..repeat();
  }

  void dispose() {
    rotationController.dispose();
    pulseController.dispose();
    orbitController.dispose();
  }
}