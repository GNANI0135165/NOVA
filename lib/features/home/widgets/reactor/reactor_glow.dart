import 'package:flutter/material.dart';

class ReactorGlow extends StatelessWidget {
  final double size;

  const ReactorGlow({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFF8A4DFF).withOpacity(.35),
              const Color(0xFF00C8FF).withOpacity(.20),
              Colors.transparent,
            ],
            stops: const [0.15, 0.55, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8A4DFF).withOpacity(.35),
              blurRadius: 50,
              spreadRadius: 10,
            ),
            BoxShadow(
              color: const Color(0xFF00C8FF).withOpacity(.20),
              blurRadius: 80,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
