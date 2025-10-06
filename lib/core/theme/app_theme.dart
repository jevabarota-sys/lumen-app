import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color palette based on Eva's logo: pink, white, and royal blue
  static const Color royalBlue =
      Color(0xFF1E3A8A); // Deep royal blue from logo background
  static const Color mediumBlue = Color(0xFF3B82F6); // Medium royal blue
  static const Color lightBlue = Color(0xFF60A5FA); // Light royal blue
  static const Color pink = Color(0xFFEC4899); // Pink from logo mandala glow
  static const Color lightPink = Color(0xFFF9A8D4); // Light pink accent
  static const Color softPink = Color(0xFFFCE7F3); // Very light pink
  static const Color lightPurple =
      Color(0xFFE9D5FF); // Light purple for background
  static const Color lightRoyalBlue =
      Color(0xFFDDD6FE); // Light royal blue for background gradient
  static const Color white = Color(0xFFFFFFFF); // Pure white from logo symbol
  static const Color lightGray = Color(0xFFF8FAFC); // Very light gray
  static const Color darkGray = Color(0xFF374151); // Dark gray for text
  static const Color black = Color(0xFF111827); // Deep black for contrast

  static const Color primary = royalBlue; // Royal blue as main brand color
  static const Color secondary = pink; // Pink as secondary accent color
  static const Color accent = mediumBlue; // Medium blue for highlights
  static const Color backgroundGradientStart =
      royalBlue; // Royal blue gradient start
  static const Color backgroundGradientEnd =
      mediumBlue; // Medium blue gradient end
  static const Color neutral = darkGray;
  static const Color background =
      royalBlue; // Royal blue background as requested
  static const Color surface = white; // White surface for cards
  static const Color onPrimary = white; // White text on royal blue primary
  static const Color onSecondary = white; // White text on pink secondary
  static const Color onSurface = black; // Dark text on light surface
  static const Color onBackground =
      white; // White text on royal blue background
  
  // Additional theme properties for notifications
  static const Color error = Color(0xFFEF4444); // Red for error states
  static const Color success = Color(0xFF10B981); // Green for success states
  static const Color border = Color(0xFFE5E7EB); // Light gray for borders

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
