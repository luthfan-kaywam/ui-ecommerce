import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // ── Color Tokens ──────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0F0E1A);
  static const Color surface = Color(0xFF1A1830);
  static const Color surface2 = Color(0xFF252243);
  static const Color accentGlow = Color(0xFF818CF8);
  static const Color highlight = Color(0xFFF472B6);
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textDark = Color(0xFF475569);
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFF87171);

  // ── Light Mode Tokens ─────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurface2 = Color(0xFFF1F5F9);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightAccent = Color(0xFF6366F1);

  // ── Gradient Tokens ───────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient135 = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFA855F7)],
    begin: Alignment(-0.8, -0.8),
    end: Alignment(0.8, 0.8),
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1830), Color(0xFF252243)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient priceGradient = LinearGradient(
    colors: [Color(0xFF818CF8), Color(0xFFC084FC)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient discountGradient = LinearGradient(
    colors: [Color(0xFFF472B6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient banner1Gradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF0D9488)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Elevation Shadows ─────────────────────────────────────────────────────
  static final List<BoxShadow> level1Shadow = [
    BoxShadow(
      color: const Color(0xFF4F46E5).withValues(alpha: 0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static final List<BoxShadow> level2Shadow = [
    BoxShadow(
      color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
      blurRadius: 40,
      spreadRadius: -8,
    ),
  ];

  static final List<BoxShadow> glowShadow = [
    BoxShadow(
      color: const Color(0xFF818CF8).withValues(alpha: 0.5),
      blurRadius: 24,
      spreadRadius: 2,
    ),
  ];

  static final List<BoxShadow> subtleGlow = [
    BoxShadow(
      color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
      blurRadius: 12,
    ),
  ];

  // ── Border Radius Tokens ──────────────────────────────────────────────────
  static const double radiusCard = 20.0;
  static const double radiusChip = 50.0;
  static const double radiusButton = 16.0;
  static const double radiusModal = 28.0;

  static final BorderRadius cardRadius = BorderRadius.circular(radiusCard);
  static final BorderRadius chipRadius = BorderRadius.circular(radiusChip);
  static final BorderRadius buttonRadius = BorderRadius.circular(radiusButton);
  static final BorderRadius modalRadius = const BorderRadius.vertical(
    top: Radius.circular(radiusModal),
  );

  // ── Typography ────────────────────────────────────────────────────────────
  // Display & Headers: Plus Jakarta Sans
  static TextStyle displayBold({
    double fontSize = 28,
    Color color = textPrimary,
    double letterSpacing = -0.5,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle headingBold({
    double fontSize = 20,
    Color color = textPrimary,
    double letterSpacing = -0.3,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle headingSemiBold({
    double fontSize = 15,
    Color color = textPrimary,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  // Body: Inter
  static TextStyle bodyRegular({
    double fontSize = 14,
    Color color = textSecondary,
    double height = 1.5,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
      height: height,
    );
  }

  static TextStyle bodyMedium({
    double fontSize = 14,
    Color color = textPrimary,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Numbers & Price: Space Grotesk
  static TextStyle priceBold({
    double fontSize = 16,
    Color color = textPrimary,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  static TextStyle priceSemiBold({
    double fontSize = 14,
    Color color = textPrimary,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  // ── ThemeData ─────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: const Color(0xFF4F46E5),
      cardColor: surface,
      dividerColor: surface2,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4F46E5),
        secondary: Color(0xFF7C3AED),
        surface: surface,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: const Color(0xFF6366F1),
      cardColor: lightSurface,
      dividerColor: AppColors.lightBorder,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF6366F1),
        secondary: Color(0xFF4F46E5),
        surface: lightSurface,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: lightTextPrimary),
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ),
    );
  }
}
