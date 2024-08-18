import 'package:blogify/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPalette.lightBackground,
    primaryColor: AppPalette.lightPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppPalette.lightPrimary,
      secondary: AppPalette.lightAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.lightPrimary,
      foregroundColor: AppPalette.lightText,
    ),
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: AppPalette.lightText,
          displayColor: AppPalette.lightText,
        ),
    inputDecorationTheme: InputDecorationTheme(
      border: _border(AppPalette.lightSurface),
      enabledBorder: _border(AppPalette.lightSurface),
      focusedBorder: _border(AppPalette.lightPrimary),
      errorBorder: _border(AppPalette.error),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppPalette.lightBackground,
      disabledColor: AppPalette.lightSurface,
      selectedColor: AppPalette.lightPrimary,
      secondarySelectedColor: AppPalette.lightAccent,
      labelStyle: TextStyle(color: AppPalette.lightText),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPalette.darkBackground,
    primaryColor: AppPalette.darkPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppPalette.darkPrimary,
      secondary: AppPalette.darkAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.darkBackground,
      foregroundColor: AppPalette.darkText,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: AppPalette.darkText,
          displayColor: AppPalette.darkText,
        ),
    inputDecorationTheme: InputDecorationTheme(
      border: _border(AppPalette.darkSurface),
      enabledBorder: _border(AppPalette.darkSurface),
      focusedBorder: _border(AppPalette.darkPrimary),
      errorBorder: _border(AppPalette.error),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppPalette.darkBackground,
      disabledColor: AppPalette.darkSurface,
      selectedColor: AppPalette.darkPrimary,
      secondarySelectedColor: AppPalette.darkAccent,
      labelStyle: TextStyle(color: AppPalette.darkText),
    ),
  );

  static OutlineInputBorder _border([Color color = AppPalette.lightSurface]) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      );
}
