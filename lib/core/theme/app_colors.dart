import 'package:flutter/material.dart';

class AppColors {
  // ── Dark Mode Palette (Default) ───────────────────────────────────────────
  static const background = Color(0xFF0F0E1A);
  static const surface = Color(0xFF1A1830);
  static const surface2 = Color(0xFF252243);
  static const primary = Color(0xFF4F46E5);
  static const primaryMid = Color(0xFF7C3AED);
  static const primaryLight = Color(0xFFA855F7);
  static const accent = Color(0xFF818CF8);
  static const pink = Color(0xFFF472B6);
  static const pinkDark = Color(0xFFEC4899);
  static const textPrimary = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF94A3B8);
  static const textMuted = Color(0xFF64748B);
  static const textDim = Color(0xFF475569);
  static const success = Color(0xFF34D399);
  static const error = Color(0xFFF87171);
  static const warning = Color(0xFFFBBF24);

  // ── Light Mode Palette Tokens ─────────────────────────────────────────────
  static const lightBackground = Color(0xFFF8FAFC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurface2 = Color(0xFFF1F5F9);
  static const lightTextPrimary = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF64748B);
  static const lightTextMuted = Color(0xFF94A3B8);
  static const lightTextDim = Color(0xFFCBD5E1);
  static const lightAccent = Color(0xFF6366F1);
  static const lightBorder = Color(0xFFE2E8F0);

  // ── Context-aware dynamic color getters ───────────────────────────────────
  static Color backgroundOf(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? background : lightBackground;
  }

  static Color surfaceOf(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? surface : lightSurface;
  }

  static Color surface2Of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? surface2 : lightSurface2;
  }

  static Color textPrimaryOf(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? textPrimary : lightTextPrimary;
  }

  static Color textSecondaryOf(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? textSecondary : lightTextSecondary;
  }

  static Color accentOf(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? accent : lightAccent;
  }

  static Color borderOf(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? surface2 : lightBorder;
  }

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFA855F7)],
  );

  static const gradientPink = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF472B6), Color(0xFFEC4899)],
  );

  static const gradientTeal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), Color(0xFF0D9488)],
  );

  static const gradientViolet = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
  );

  static const gradientCoral = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEC4899), Color(0xFFF97316)],
  );
}
