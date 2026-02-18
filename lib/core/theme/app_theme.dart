import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color cardColor = Color(0xFF16213E);
  static const Color green = Color(0xFF00E676);
  static const Color red = Color(0xFFFF1744);
  static const Color yellow = Color(0xFFFFD600);
  static const Color upperBand = Color(0xFFFF1744);
  static const Color middleBand = Color(0xFF90CAF9);
  static const Color lowerBand = Color(0xFF00E676);
  static const Color priceLine = Color(0xFFFFD600);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF90CAF9),
        secondary: green,
        surface: surface,
        error: red,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: cardColor,
        elevation: 2,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: Color(0xFF90CAF9),
        unselectedItemColor: Colors.grey,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
