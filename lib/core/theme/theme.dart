import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF55C173);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryGreen),

    scaffoldBackgroundColor: Colors.white,

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),

    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      color: Colors.white, elevation: 1,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
