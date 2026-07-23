import 'package:flutter/material.dart';

class ReactorGlow extends StatelessWidget {
  final double size;

  const ReactorGlow({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 2.0,
      height: size * 2.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Large purple nebula
          Container(
            width: size * 1.85,
            height: size * 1.85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8A4DFF).withOpacity(.25),
                  const Color(0xFF4720B8).withOpacity(.10),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Blue energy field
          Container(
            width: size * 1.35,
            height: size * 1.35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF00C8FF).withOpacity(.28),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Soft bloom
          Container(
            width: size * 1.05,
            height: size * 1.05,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00C8FF).withOpacity(.35),
                  blurRadius: 90,
                  spreadRadius: 12,
                ),
                BoxShadow(
                  color: const Color(0xFF8A4DFF).withOpacity(.28),
                  blurRadius: 120,
                  spreadRadius: 25,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}