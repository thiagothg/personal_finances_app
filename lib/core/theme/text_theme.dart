import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

TextTheme buildTextTheme({required bool isDark}) {
  final onSurface = isDark ? const Color(0xFFE0E0FF) : const Color(0xFF1E1B4B);
  final body = isDark ? const Color(0xFFC4C4D4) : const Color(0xFF374151);
  final muted = isDark ? const Color(0xFF8884A8) : const Color(0xFF6B7280);

  return GoogleFonts.interTextTheme().copyWith(
    displayLarge: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: onSurface,
      letterSpacing: -0.5,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: onSurface,
      letterSpacing: -0.3,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: onSurface,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: body,
      height: 1.6,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: body,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: muted,
      height: 1.4,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.primary,
      height: 1.2,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: muted,
      letterSpacing: 0.5,
      height: 1.2,
    ),
  );
}
