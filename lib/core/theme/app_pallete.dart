import 'package:flutter/material.dart';

class BlogColorPaletteLight {
  static const List<Color> colors = [
    Color(0xFFB0C4FF), // Soft Blue matching light background
    Color(0xFFFFE0B2), // Soft Orange matching light background
    Color(0xFFF9E79F), // Soft Yellow with a muted tone
    Color(0xFFAED581), // Light Green to match light background
    Color(0xFFFFB3B3), // Soft Pink but with more warmth
    Color(0xFFF5B7B1), // Muted Red-Pink
    Color(0xFFD1C4E9), // Soft Purple that complements light surfaces
    Color(0xFFFFE4B2), // Soft Peach with a warmer tone
    Color(0xFFB3E5FC), // Light Aqua with more pastel tone
    Color(0xFFFFF8E1), // Soft Cream with high brightness
  ];

  static Color getColor(int index) {
    return colors[index % colors.length];
  }
}

class BlogColorPaletteDark {
  static const List<Color> colors = [
    Color(0xFF546E7A), // Muted Blue-Grey to blend with dark background
    Color(0xFF616161), // Darker Grey matching dark surfaces
    Color(0xFF37474F), // Darker Blue-Grey for stronger contrast
    Color(0xFF455A64), // Medium Blue-Grey, complementary tone
    Color(0xFF607D8B), // Light Slate Grey with subtlety
    Color(0xFF78909C), // Cool Grey that’s not too bright
    Color(0xFF90A4AE), // Lighter Grey with reduced brightness
    Color(0xFFA1887F), // Muted Brown for warm tone
    Color(0xFFB0BEC5), // Silver Grey that is not too harsh
    Color(0xFFD7CCC8), // Pale Brown that still contrasts well
  ];

  static Color getColor(int index) {
    return colors[index % colors.length];
  }
}

class AppPalette {
  // Light theme colors
  static const lightPrimary = Color(0xFF6C63FF); // Soft Violet
  static const lightAccent = Color(0xFFFF6584); // Coral Pink
  static const lightBackground = Color(0xFFF2F6FF); // Light Blue-Gray
  static const lightSurface = Color(0xFFFFFFFF); // White
  static const lightText = Color(0xFF333A56); // Deep Indigo

  // Dark theme colors
  static const darkPrimary = Color(0xFF7366FF); // Bright Indigo
  static const darkAccent = Color(0xFFFF77A9); // Soft Pink
  static const darkBackground = Color(0xFF2A2E45); // Dark Blue-Gray
  static const darkSurface = Color(0xFF393F60); // Deep Blue
  static const darkText = Color(0xFFE0E6FF); // Soft Blue-Gray

  // Common colors
  static const error = Color(0xFFFF4C4C); // Red
  static const success = Color(0xFF4CAF50); // Green
  static const warning = Color(0xFFFFC107); // Amber
  static const info = Color(0xFF2196F3); // Blue
  static const transparent = Colors.transparent;
}
