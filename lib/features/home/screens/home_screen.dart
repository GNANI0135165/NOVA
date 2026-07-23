import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

import '../widgets/background/quantum_background.dart';
import '../widgets/reactor/reactor_core.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const Positioned.fill(
            child: QuantumBackground(),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 18),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.menu_rounded,
                        color: Colors.white70,
                        size: 28,
                      ),

                      const Spacer(),

                      Column(
                        children: [
                          Text(
                            "NOVA",
                            style: AppTextStyles.heading,
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            "• QUANTUM •",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              letterSpacing: 3,
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            "● SYSTEM ONLINE",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 11,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      const Icon(
                        Icons.tune,
                        color: Colors.cyanAccent,
                        size: 26,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 45),

                const Expanded(
                  child: Center(
                    child: ReactorCore(),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Good Afternoon, Boss.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "How can I assist you today?",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}