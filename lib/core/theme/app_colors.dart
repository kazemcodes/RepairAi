import 'package:flutter/material.dart';

/// Modern app color scheme - Desktop optimized
class AppColors {
  AppColors._();

  // Primary Colors - Modern Blue gradient base
  static const Color primary = Color(0xFF3B82F6);        // Blue 500
  static const Color primaryDark = Color(0xFF1D4ED8);     // Blue 700
  static const Color primaryLight = Color(0xFF60A5FA);   // Blue 400
  
  // Accent Colors - Purple for AI features
  static const Color accent = Color(0xFF8B5CF6);          // Violet 500
  static const Color accentDark = Color(0xFF7C3AED);     // Violet 600

  // Secondary Colors - Modern Green
  static const Color secondary = Color(0xFF10B981);       // Emerald 500
  static const Color secondaryDark = Color(0xFF059669);  // Emerald 600
  static const Color secondaryLight = Color(0xFF34D399); // Emerald 400

  // Background Colors - Modern dark grays
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50
  static const Color backgroundDark = Color(0xFF0F172A);  // Slate 900
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);    // Slate 800
  static const Color surfaceDark2 = Color(0xFF334155);   // Slate 700

  // Sidebar Colors
  static const Color sidebarLight = Color(0xFFF1F5F9);   // Slate 100
  static const Color sidebarDark = Color(0xFF0F172A);    // Slate 900
  static const Color sidebarSelectedLight = Color(0xFFE0E7FF); // Indigo 100
  static const Color sidebarSelectedDark = Color(0xFF312E81); // Indigo 900

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1E293B);   // Slate 800
  static const Color textSecondaryLight = Color(0xFF64748B); // Slate 500
  static const Color textPrimaryDark = Color(0xFFF8FAFC);    // Slate 50
  static const Color textSecondaryDark = Color(0xFF94A3B8);  // Slate 400

  // Error Colors
  static const Color error = Color(0xFFEF4444);           // Red 500
  static const Color errorDark = Color(0xFFDC2626);       // Red 600

  // Success Colors
  static const Color success = Color(0xFF10B981);        // Emerald 500
  static const Color successLight = Color(0xFF34D399);   // Emerald 400
  
  // Warning Colors
  static const Color warning = Color(0xFFF59E0B);         // Amber 500
  static const Color warningLight = Color(0xFFFBBF24);   // Amber 400

  // Chat Colors - Modern styling
  static const Color userMessage = Color(0xFF3B82F6);   // Blue 500
  static const Color aiMessage = Color(0xFF334155);      // Slate 700
  static const Color userMessageDark = Color(0xFF1D4ED8); // Blue 700
  static const Color aiMessageDark = Color(0xFF475569);  // Slate 600

  // Severity Colors - More modern, softer colors
  static const Color easy = Color(0xFF22C55E);           // Green 500
  static const Color medium = Color(0xFFF59E0B);         // Amber 500
  static const Color hard = Color(0xFFEF4444);           // Red 500

  // Card Colors with subtle shadows
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E293B);       // Slate 800
  
  // Border Colors
  static const Color borderLight = Color(0xFFE2E8F0);     // Slate 200
  static const Color borderDark = Color(0xFF334155);      // Slate 700

  // Gradient for modern look
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
