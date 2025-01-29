import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayMedium: GoogleFonts.outfit(color: Colors.black),
    titleSmall: GoogleFonts.satisfy(
        color: Colors.black, fontSize: 30, fontWeight: FontWeight.w200),
    bodyLarge: GoogleFonts.outfit(color: Colors.black, fontSize: 16),
    bodySmall: GoogleFonts.satisfy(color: Colors.black, fontSize: 18),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayMedium: GoogleFonts.montserrat(color: Colors.white70),
    titleSmall: GoogleFonts.poppins(color: Colors.white60, fontSize: 24),
  );
}
