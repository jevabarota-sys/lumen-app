import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // New color palette based on Eva's logo design - extracted from the gradient
  static const Color deepNavy = Color(0xFF0F1419);     // Darkest navy from logo edges
  static const Color darkBlue = Color(0xFF1A237E);     // Dark blue from gradient
  static const Color royalBlue = Color(0xFF3F51B5);    // Medium blue from gradient center
  static const Color brightBlue = Color(0xFF5C6BC0);   // Bright blue from gradient
  static const Color lavender = Color(0xFF9C27B0);     // Purple/lavender from logo symbol glow
  static const Color lightLavender = Color(0xFFE1BEE7); // Light purple accent
  static const Color warmGray = Color(0xFF6B7280);
  static const Color lightGray = Color(0xFFF7FAFC);  // Slightly cooler light background
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A202C);      // Slightly warmer dark text

  static const Color primary = brightBlue;     // Main brand color - brighter for inverse
  static const Color secondary = lightLavender; // Light purple accent for inverse
  static const Color accent = royalBlue;        // Royal blue for highlights
  static const Color backgroundGradientStart = lightLavender;  // Light gradient start
  static const Color backgroundGradientEnd = brightBlue;       // Light gradient end
  static const Color neutral = warmGray;
  static const Color background = white;        // White background as requested
  static const Color surface = lightGray;       // Light surface
  static const Color onPrimary = white;         // White text on bright primary
  static const Color onSecondary = deepNavy;    // Dark text on light secondary
  static const Color onSurface = black;         // Dark text on light surface
  static const Color onBackground = black;      // Dark text on white background

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        tertiary: accent,
        surface: surface,
        background: background,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
        onSurface: onSurface,
        onBackground: onBackground,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neutral.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neutral.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
