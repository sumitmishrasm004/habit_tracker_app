import 'package:flutter/material.dart';

class AppTheme {
  ThemeData lightThemeData() {
    return ThemeData(
      colorScheme: const ColorScheme.light(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  ThemeData darkThemeData() {
    return ThemeData(
      colorScheme: const ColorScheme.dark(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
