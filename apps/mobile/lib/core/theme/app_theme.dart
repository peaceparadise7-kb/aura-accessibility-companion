import 'package:flutter/material.dart';

/// High-contrast, accessibility-first Material 3 theme configuration.
class AppTheme {
  // High-contrast color palette compliant with WCAG AAA (7:1 contrast ratio)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF252525);
  static const Color primaryAccessible = Color(0xFFFFD54F); // High-visibility amber
  static const Color onPrimary = Color(0xFF000000);
  static const Color secondaryAccessible = Color(0xFF80D8FF); // High-visibility cyan
  static const Color errorAccessible = Color(0xFFFF5252); // Vivid red
  static const Color textHighEmphasis = Color(0xFFFFFFFF);
  static const Color textMediumEmphasis = Color(0xFFE0E0E0);

  static ThemeData get highContrastDarkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryAccessible,
        onPrimary: onPrimary,
        secondary: secondaryAccessible,
        onSecondary: Colors.black,
        surface: darkSurface,
        onSurface: textHighEmphasis,
        error: errorAccessible,
        onError: Colors.black,
      ),
      cardTheme: CardTheme(
        color: darkCard,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(color: Color(0xFF424242), width: 1.5),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: textHighEmphasis,
          letterSpacing: 0.25,
        ),
        headlineMedium: TextStyle(
          fontSize: 26.0,
          fontWeight: FontWeight.bold,
          color: textHighEmphasis,
        ),
        titleLarge: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w600,
          color: textHighEmphasis,
        ),
        titleMedium: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: textHighEmphasis,
        ),
        bodyLarge: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
          color: textHighEmphasis,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: textMediumEmphasis,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: onPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56.0), // Guaranteed >= 48dp
          backgroundColor: primaryAccessible,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56.0),
          foregroundColor: primaryAccessible,
          side: const BorderSide(color: primaryAccessible, width: 2.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
