import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Font Configuration
//  Pairs headings and body typography using Google Fonts.
// ════════════════════════════════════════════════════════════════════════════

class FontConfig {
  final String headingFontName;
  final String bodyFontName;
  final TextTheme Function(TextTheme baseTextTheme) textThemeBuilder;

  const FontConfig({
    required this.headingFontName,
    required this.bodyFontName,
    required this.textThemeBuilder,
  });

  // Pre-configured font combinations for the 4 themes

  // Combo 1: Poppins (Heading) + Inter (Body)
  static final fontIndigo = FontConfig(
    headingFontName: 'Poppins',
    bodyFontName: 'Inter',
    textThemeBuilder: (base) => GoogleFonts.interTextTheme(base).copyWith(
      displayLarge: GoogleFonts.poppins(textStyle: base.displayLarge, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.poppins(textStyle: base.displayMedium, fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.poppins(textStyle: base.displaySmall, fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.poppins(textStyle: base.headlineLarge, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.poppins(textStyle: base.headlineMedium, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.poppins(textStyle: base.headlineSmall, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.poppins(textStyle: base.titleLarge, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.poppins(textStyle: base.titleMedium, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.poppins(textStyle: base.titleSmall, fontWeight: FontWeight.w500),
    ),
  );

  // Combo 2: Nunito (Heading) + Lato (Body)
  static final fontEmerald = FontConfig(
    headingFontName: 'Nunito',
    bodyFontName: 'Lato',
    textThemeBuilder: (base) => GoogleFonts.latoTextTheme(base).copyWith(
      displayLarge: GoogleFonts.nunito(textStyle: base.displayLarge, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.nunito(textStyle: base.displayMedium, fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.nunito(textStyle: base.headlineLarge, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.nunito(textStyle: base.headlineMedium, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.nunito(textStyle: base.titleLarge, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.nunito(textStyle: base.titleMedium, fontWeight: FontWeight.w600),
    ),
  );

  // Combo 3: Raleway (Heading) + Roboto (Body)
  static final fontRose = FontConfig(
    headingFontName: 'Raleway',
    bodyFontName: 'Roboto',
    textThemeBuilder: (base) => GoogleFonts.robotoTextTheme(base).copyWith(
      displayLarge: GoogleFonts.raleway(textStyle: base.displayLarge, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.raleway(textStyle: base.displayMedium, fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.raleway(textStyle: base.headlineLarge, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.raleway(textStyle: base.headlineMedium, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.raleway(textStyle: base.titleLarge, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.raleway(textStyle: base.titleMedium, fontWeight: FontWeight.w600),
    ),
  );

  // Combo 4: Outfit (Heading) + Source Sans 3 (Body)
  static final fontOcean = FontConfig(
    headingFontName: 'Outfit',
    bodyFontName: 'Source Sans 3',
    textThemeBuilder: (base) => GoogleFonts.sourceSans3TextTheme(base).copyWith(
      displayLarge: GoogleFonts.outfit(textStyle: base.displayLarge, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.outfit(textStyle: base.displayMedium, fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.outfit(textStyle: base.headlineLarge, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.outfit(textStyle: base.headlineMedium, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.outfit(textStyle: base.titleLarge, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.outfit(textStyle: base.titleMedium, fontWeight: FontWeight.w600),
    ),
  );
}
