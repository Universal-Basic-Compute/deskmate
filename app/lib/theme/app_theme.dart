import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color constants
const Color primaryYellow = Color(0xFFFFD100); // Bright yellow
const Color orangeAccent = Color(0xFFFF9500); // Orange
const Color violetAccent = Color(0xFF8A4FFF); // Violet
const Color darkGrey = Color(0xFF303030); // Dark grey
const Color lightGrey = Color(0xFF606060); // Light grey
const Color backgroundGrey = Color(0xFF212121); // Near black

// Gradient definitions
const LinearGradient yellowOrangeGradient = LinearGradient(
  colors: [primaryYellow, orangeAccent],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient violetGradient = LinearGradient(
  colors: [violetAccent, Color(0xFF6A2FDF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Theme data
ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryYellow,
    scaffoldBackgroundColor: backgroundGrey,
    fontFamily: GoogleFonts.notoSans().fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkGrey,
      foregroundColor: primaryYellow,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: primaryYellow,
      secondary: violetAccent,
      tertiary: orangeAccent,
      surface: darkGrey,
      onPrimary: darkGrey,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryYellow,
        foregroundColor: darkGrey,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryYellow,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: lightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryYellow, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.white70),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: primaryYellow, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: primaryYellow, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}
