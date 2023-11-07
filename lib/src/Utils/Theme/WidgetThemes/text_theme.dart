import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Constants/colors.dart';

/* -- Light & Dark Text Themes -- */
class MyTextTheme {
  MyTextTheme._();

  /* -- Light Text Theme -- */
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.nunito(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: tDarkColor,
    ),
    displayMedium: GoogleFonts.nunito(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: tDarkColor,
    ),
    displaySmall: GoogleFonts.nunito(
      fontSize: 24.0,
      fontWeight: FontWeight.normal,
      color: tDarkColor,
    ),
    headlineLarge: GoogleFonts.nunito(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      color: tDarkColor,
    ),
    headlineMedium: GoogleFonts.nunito(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: tDarkColor,
    ),
    headlineSmall: GoogleFonts.nunito(
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      color: tDarkColor,
    ),
    bodyLarge: GoogleFonts.nunito(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: tDarkColor,
    ),
    bodyMedium: GoogleFonts.nunito(
      fontSize: 14.0,
      color: tDarkColor.withOpacity(0.8),
    ),
    titleLarge: GoogleFonts.nunito(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: tDarkColor,
    ),
    titleSmall: GoogleFonts.nunito(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: tDarkColor,
    ),
  );

  /* -- Dark Text Theme -- */
  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.nunito(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: tWhiteColor,
    ),
    displayMedium: GoogleFonts.nunito(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: tWhiteColor,
    ),
    displaySmall: GoogleFonts.nunito(
      fontSize: 24.0,
      fontWeight: FontWeight.normal,
      color: tWhiteColor,
    ),
    headlineLarge: GoogleFonts.nunito(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      color: tWhiteColor,
    ),
    headlineMedium: GoogleFonts.nunito(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: tWhiteColor,
    ),
    headlineSmall: GoogleFonts.nunito(
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      color: tWhiteColor,
    ),
    bodyLarge: GoogleFonts.nunito(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: subtitleColor,
    ),
    bodyMedium: GoogleFonts.nunito(
      fontSize: 14.0,
      color: tWhiteColor.withOpacity(0.8),
    ),
    titleLarge: GoogleFonts.nunito(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: tWhiteColor,
    ),
    titleSmall: GoogleFonts.nunito(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: tWhiteColor,
    ),
  );
}
