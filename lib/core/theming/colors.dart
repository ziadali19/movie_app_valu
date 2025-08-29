import 'package:flutter/material.dart';

class ColorsManager {
  // Dark Cinema Theme Colors
  static const Color primary = Color(0xFFE50914); // Netflix-like red
  static const Color secondary = Color(0xFF141414); // Dark background
  static const Color background = Color(0xFF000000); // Pure black
  static const Color surface = Color(0xFF1E1E1E); // Card backgrounds
  static const Color onPrimary = Color(0xFFFFFFFF); // White text on primary
  static const Color onSecondary = Color(0xFFFFFFFF); // White text
  static const Color textPrimary = Color(0xFFFFFFFF); // Primary text
  static const Color textSecondary = Color(0xFFB3B3B3); // Secondary text
  static const Color cardBackground = Color(
    0xFF2A2A2A,
  ); // Movie card background
  static const Color accentRed = Color(
    0xFFE50914,
  ); // Same as primary for consistency
}

// AppColors alias for favorites feature (to match existing usage)
// class AppColors {
//   static const Color primaryBackground = ColorsManager.background;
//   static const Color cardBackground = ColorsManager.cardBackground;
//   static const Color primaryBlue = Color(0xFF3B82F6); // Blue accent
//   static const Color white = ColorsManager.textPrimary;
//   static const Color lightGray = ColorsManager.textSecondary;
//   static const Color accentRed = ColorsManager.primary;
// }
