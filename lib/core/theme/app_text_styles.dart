import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle display(
    double size, {
    FontWeight w = FontWeight.w800,
    Color? color,
    double? letterSpacing,
    double? height,
  }) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: w,
        color: color ?? AppColors.textPrimary,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle body(
    double size, {
    FontWeight w = FontWeight.w400,
    Color? color,
    double? letterSpacing,
    double? height,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: w,
        color: color ?? AppColors.textPrimary,
        letterSpacing: letterSpacing,
        height: height,
      );
}
