import 'package:flutter/material.dart';

import '../widgets/background/quantum_background.dart';
import '../widgets/bottom_menu.dart';
import '../widgets/reactor/reactor_core.dart';
import '../widgets/talk_button.dart';
import '../widgets/voice_mode_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning, Boss.';
    } else if (hour < 17) {
      return 'Good Afternoon, Boss.';
    } else {
      return 'Good Evening, Boss.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010208),
      body: Stack(
        children: [
          const QuantumBackground(),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final height = constraints.maxHeight;

                return Column(
                  children: [
                    // ═══════════════════════════════════
                    // TOP HEADER
                    // ═══════════════════════════════════

                    SizedBox(
                      height: 110,
                      child: Stack(
                        children: [
                          // MENU
                          Positioned(
                            left: 22,
                            top: 42,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.menu_rounded,
                                color: Colors.white70,
                                size: 29,
                              ),
                            ),
                          ),

                          // SETTINGS
                          Positioned(
                            right: 22,
                            top: 42,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.tune_rounded,
                                color: Color(0xFF00E5FF),
                                size: 25,
                              ),
                            ),
                          ),

                          // NOVA BRAND
                          const Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.only(top: 22),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'NOVA',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                  ),

                                  SizedBox(height: 1),

                                  Text(
                                    '•  Q U A N T U M  •',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                      letterSpacing: 3,
                                    ),
                                  ),

                                  SizedBox(height: 5),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: Color(0xFF55F2B0),
                                        size: 9,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'SYSTEM ONLINE',
                                        style: TextStyle(
                                          color: Color(0xFF55F2B0),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ═══════════════════════════════════
                    // MAIN CONTENT
                    // ═══════════════════════════════════

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // REACTOR
                            SizedBox(
                              height: height < 750 ? 305 : 335,
                              child: const Center(
                                child: ReactorCore(),
                              ),
                            ),

                            // GREETING
                            Text(
                              _greeting(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 29,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -.5,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // SUBTITLE
                            Text(
                              'How can I assist you today?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(.68),
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 26),

                            // TALK BUTTON
                            const TalkButton(),

                            const SizedBox(height: 18),

                            const VoiceModeButton(),

                            const SizedBox(height: 32),

                            // FEATURE CARDS
                            const BottomMenu(),

                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
