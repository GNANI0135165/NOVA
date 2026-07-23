import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle heading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
  );

  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );
}