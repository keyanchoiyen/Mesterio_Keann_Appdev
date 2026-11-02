import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryOrange = Color(0xFFF57C00);
  static const Color darkOrange = Color(0xFFE86A00);
  static const Color yellow = Color(0xFFFFC247);
  static const Color lightYellow = Color(0xFFFFF0CC);
  static const Color background = Color(0xFFFFF9EF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkText = Color(0xFF332211);

  static ThemeData get themeData {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryOrange,
      brightness: Brightness.light,
      primary: primaryOrange,
      onPrimary: white,
      secondary: yellow,
      onSecondary: darkText,
      surface: white,
      onSurface: darkText,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: darkText, fontWeight: FontWeight.w800),
        headlineMedium: TextStyle(color: darkText, fontWeight: FontWeight.w800),
        titleLarge: TextStyle(color: darkText, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: darkText, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: darkText),
        bodyMedium: TextStyle(color: darkText),
        labelLarge: TextStyle(fontWeight: FontWeight.w700),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryOrange, width: 1.5),
        ),
      ),
      dividerColor: lightYellow,
    );
  }
}
