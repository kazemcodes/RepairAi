import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Modern desktop theme configuration
class AppTheme {
  AppTheme._();

  /// Light theme - Modern clean look
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      
      // AppBar - Modern flat design
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryLight,
        ),
      ),

      // Cards - Modern with subtle borders
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Buttons - Modern styling
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),

      // Input fields - Modern design
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.textSecondaryLight,
          fontSize: 14,
        ),
      ),

      // Navigation Rail - For desktop sidebar
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.sidebarLight,
        selectedIconTheme: const IconThemeData(color: AppColors.primary),
        unselectedIconTheme: IconThemeData(color: AppColors.textSecondaryLight),
        selectedLabelTextStyle: GoogleFonts.inter(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelTextStyle: GoogleFonts.inter(
          color: AppColors.textSecondaryLight,
          fontSize: 12,
        ),
        indicatorColor: AppColors.sidebarSelectedLight,
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),

      // Text theme
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: AppColors.textPrimaryLight),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimaryLight),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondaryLight),
        labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  /// Dark theme - Modern dark look
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        tertiary: AppColors.accent,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: AppColors.textPrimaryDark,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.textSecondaryDark,
          fontSize: 14,
        ),
      ),

      // Navigation Rail
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.sidebarDark,
        selectedIconTheme: const IconThemeData(color: AppColors.primaryLight),
        unselectedIconTheme: IconThemeData(color: AppColors.textSecondaryDark),
        selectedLabelTextStyle: GoogleFonts.inter(
          color: AppColors.primaryLight,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelTextStyle: GoogleFonts.inter(
          color: AppColors.textSecondaryDark,
          fontSize: 12,
        ),
        indicatorColor: AppColors.sidebarSelectedDark,
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),

      // Text theme
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: AppColors.textPrimaryDark),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimaryDark),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondaryDark),
        labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }
}
