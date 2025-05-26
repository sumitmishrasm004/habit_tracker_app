import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppColors {
  // static const Color primaryColor = Colors
  static const Color primaryBlue = Color(0xff3371FF);
  static const Color primaryPurple = Color(0xff8426D6);
  static const Color textRedColor = Color(0xFFFF6B6B);
  static const Color inputFieldBlue = Color(0xFF3F80FF);
  static const Color arrowButtonBlue = Color(0xFF003EB7);
  static const Color white = Color.fromRGBO(255, 255, 255, 1.0);
  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color red = Color.fromRGBO(255, 0, 0, 0.7);
  static const Color lightGreen = Color.fromRGBO(106, 160, 47, 1);
  static const Color grey = Color.fromRGBO(213, 213, 213, 1);
  static const Color blue = Color.fromRGBO(33, 72, 112, 1);
  static const Color shadowGrey = Color.fromRGBO(237, 237, 237, 1);

  static const LinearGradient linearGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    tileMode: TileMode.repeated,
    colors: [
      primaryBlue,
      primaryPurple,
    ],
  );
}