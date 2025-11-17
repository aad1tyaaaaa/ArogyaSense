// core/theme/app_theme.dart
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.cyanAccent,
  scaffoldBackgroundColor: const Color(0xFF181A20),
  cardColor: const Color(0xFF23242B),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
  ),
  colorScheme: ColorScheme.dark(
    primary: Colors.cyanAccent,
    secondary: Colors.greenAccent,
    background: Color(0xFF181A20),
    surface: Color(0xFF23242B),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF23242B),
    selectedItemColor: Colors.cyanAccent,
    unselectedItemColor: Colors.white54,
    showUnselectedLabels: true,
  ),
);
