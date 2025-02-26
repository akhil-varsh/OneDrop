import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFFD32F2F); // Red
  static const Color secondaryColor = Color(0xFFFFF8E1); // Cream
  static const Color accentColor = Color(0xFFFFCDD2); // Light Red
  static const Color textColor = Color(0xFF212121); // Dark Gray
  static const Color errorColor = Color(0xFFFF5722); // Deep Orange

  // Theme
  static final ThemeData appTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: secondaryColor, // Cream background
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor, // Red app bar
      foregroundColor: secondaryColor, // Cream text/icons on app bar
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor, // Red buttons
        foregroundColor: secondaryColor, // Cream text on buttons
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: accentColor), // Light red for text buttons
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor), // Red border when focused
        borderRadius: BorderRadius.circular(8),
      ),
      labelStyle: TextStyle(color: textColor), // Dark gray labels
      fillColor: secondaryColor, // Cream input background
      filled: true,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: textColor), // Dark gray body text
      bodyMedium: TextStyle(color: textColor),
      headlineSmall: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
      surface: secondaryColor, // Cream surfaces
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: secondaryColor, // Cream drawer background
    ),
  );

  // Other constants
  static const List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
}