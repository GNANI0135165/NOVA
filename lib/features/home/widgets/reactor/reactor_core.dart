import 'package:flutter/material.dart';

import 'reactor_controller.dart';
import 'reactor_glow.dart';
import 'reactor_ring.dart';
import 'plasma_core.dart';
import 'orbit_particles.dart';

class ReactorCore extends StatefulWidget {
  const ReactorCore({super.key});

  @override
  State<ReactorCore> createState() => _ReactorCoreState();
}

class _ReactorCoreState extends State<ReactorCore>
    with TickerProviderStateMixin {
  late ReactorController controller;

  @override
  void initState() {
    super.initState();
    controller = ReactorController(vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double reactorSize = 260;

    return SizedBox(
      width: reactorSize,
      height: reactorSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const ReactorGlow(size: reactorSize),

          ReactorRing(
            size: reactorSize,
            rotation: controller.rotationController,
            strokeWidth: 5,
            color: Colors.cyanAccent,
          ),

          ReactorRing(
            size: reactorSize * 0.82,
            rotation: ReverseAnimation(controller.rotationController),
            strokeWidth: 4,
            color: Colors.deepPurpleAccent,
          ),

          ReactorRing(
            size: reactorSize * 0.65,
            rotation: controller.rotationController,
            strokeWidth: 3,
            color: Colors.lightBlueAccent,
          ),

          OrbitParticles(
            size: reactorSize,
            animation: controller.orbitController,
          ),

          PlasmaCore(
            size: reactorSize * 0.30,
            pulse: controller.pulseController,
          ),
        ],
      ),
    );
  }
}