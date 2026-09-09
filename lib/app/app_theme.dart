import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color primaryColor = Color(0xFF4F8FD8);
  static const Color backgroundColor = Color(0xFFFFF8E7);
  static const Color foregroundColor = Color(0xFF293241);
  static const Color buttonForegroundColor = Colors.white;

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      surface: backgroundColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: foregroundColor),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: buttonForegroundColor,
          minimumSize: const Size(200, 56),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
