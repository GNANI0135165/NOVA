import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/screens/home_screen.dart';

void main() {
  runApp(const NovaApp());
}

class NovaApp extends StatelessWidget {
  const NovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NOVA Quantum',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}