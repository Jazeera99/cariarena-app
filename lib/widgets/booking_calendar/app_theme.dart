import 'package:flutter/material.dart';

class AppTheme {
  static const Color shadowColor = Color(0xFF000000); // Tambahkan baris ini

  static final ThemeData lightTheme = ThemeData(
    // ... kode tema lainnya
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF388E3C),
      primary: const Color(0xFF388E3C),
      secondary: const Color(0xFF66BB6A),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF212121),
      onSurfaceVariant: const Color(0xFF757575),
      error: const Color(0xFFD32F2F),
      onError: Colors.white,
      surfaceContainerHighest: const Color(0xFFF5F5F5),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.w400,
        fontSize: 10,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF388E3C),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    // ... kode tema lainnya
  );
}
