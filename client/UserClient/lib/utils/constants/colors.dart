import 'package:flutter/material.dart';

class MyAppColors {
  MyAppColors._();

  // App Baisc Colors
  static const Color primary = Color(0xFF4B68FF);
  static const Color secondary = Color(0xFFFFE24B);
  static const Color accent = Color(0xFFb0c7ff);

  // Gradient Colors
  static const Gradient linearGradient = LinearGradient(
      begin: Alignment(0.0, 0.0),
      end: Alignment(0.707, -0.707),
      colors: [
        Color(0xffff9a9e),
        Color(0xfffad0c4),
        Color(0xfffad0c4),
      ]);

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6c757D);
  static const Color textWhite = Colors.white;

  // Background Colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  // Background Container Colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static final Color darkContainer = Colors.white.withOpacity(0.1);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF4b68ff);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // Border Colors
  static const Color borderPrimary = Color(0xFF4b68ff);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0XFF1976D2);

  // Neutral Shades
  static const Color darkBlack = Color.fromARGB(255, 0, 0, 0);
  static const Color black = Color(0XFF232323);
  static const Color darkishGrey = Color.fromARGB(255, 65, 63, 63);
  static const Color darkerGrey = Color(0XFF4F4F4F);
  static const Color darkGrey = Color(0XFF939393);
  static const Color grey = Color(0XFFE0E0E0);

  static const Color transperant = Colors.transparent;
  static const Color red = Colors.red;
  static const Color amber = Colors.amber;
  static const Color yellow = Colors.yellow;
  static const Color blue = Color.fromARGB(255, 45, 157, 249);
}
