import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static ThemeData get light{
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      disabledColor: Colors.grey,
      textTheme: GoogleFonts.nunitoSansTextTheme(),
      useMaterial3: true,
    );
  }
}