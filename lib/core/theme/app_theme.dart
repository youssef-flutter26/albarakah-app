import 'package:flutter/material.dart';

class AppTheme {
  static const ink = Color(0xFF15110E);
  static const gold = Color(0xFFC49A5A);
  static const cream = Color(0xFFF8F4EE);
  static const muted = Color(0xFF756D66);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: gold,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        primary: ink,
        secondary: gold,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: AppTheme.ink,
      fontFamily: 'sans',
      appBarTheme: const AppBarTheme(
        backgroundColor: cream,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ink,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}
