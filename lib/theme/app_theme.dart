import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark theme colors
  static const Color primaryColor = Color(0xFF00A5E0);
  static const Color secondaryColor = Color(0xFF0A1721);
  static const Color accentColor = Color(0xFF0078A8);
  static const Color backgroundColor = Color(0xFF0A1721);
  static const Color cardColor = Color(0xFF162232);
  static const Color textColor = Colors.white;
  static const Color subtitleColor = Color(0xFFAAAAAA);
  static const Color dividerColor = Color(0xFF2A3A4A);

  // Light theme colors
  static const Color lightPrimaryColor = Color(0xFF0078A8);
  static const Color lightSecondaryColor = Color(0xFFE8F5F9);
  static const Color lightAccentColor = Color(0xFF00A5E0);
  static const Color lightBackgroundColor = Color(0xFFF5F9FA);
  static const Color lightCardColor = Colors.white;
  static const Color lightTextColor = Color(0xFF1A1A1A);
  static const Color lightSubtitleColor = Color(0xFF757575);
  static const Color lightDividerColor = Color(0xFFEAEAEA);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: lightPrimaryColor,
        secondary: lightSecondaryColor,
        surface: lightCardColor,
        onPrimary: Colors.white,
        onSecondary: lightTextColor,
        onSurface: lightTextColor,
      ),
      scaffoldBackgroundColor: lightBackgroundColor,
      cardColor: lightCardColor,
      dividerColor: lightDividerColor,
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: lightTextColor,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: lightTextColor,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: lightTextColor,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: lightTextColor,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            color: lightTextColor,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: lightTextColor,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: lightTextColor,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            color: lightTextColor,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(color: lightTextColor),
          bodyMedium: TextStyle(color: lightTextColor),
          bodySmall: TextStyle(color: lightSubtitleColor),
          labelLarge: TextStyle(
            color: lightTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: lightTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: lightTextColor),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightCardColor,
        selectedItemColor: lightPrimaryColor,
        unselectedItemColor: lightSubtitleColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightPrimaryColor,
          side: const BorderSide(color: lightPrimaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightPrimaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      dividerColor: dividerColor,
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(color: textColor),
          bodyMedium: TextStyle(color: textColor),
          bodySmall: TextStyle(color: subtitleColor),
          labelLarge: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: subtitleColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }
}
