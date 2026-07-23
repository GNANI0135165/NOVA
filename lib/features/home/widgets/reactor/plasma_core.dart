import 'package:flutter/material.dart';

class PlasmaCore extends StatelessWidget {
  final double size;
  final Animation<double> pulse;

  const PlasmaCore({
    super.key,
    required this.size,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (context, child) {
        return Transform.scale(
          scale: pulse.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFF80D8FF),
                  Color(0xFF00B8FF),
                  Color(0xFF0050FF),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF00E5FF),
                  blurRadius: 30,
                  spreadRadius: 8,
                ),
                BoxShadow(
                  color: Color(0xFF7B61FF),
                  blurRadius: 60,
                  spreadRadius: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}