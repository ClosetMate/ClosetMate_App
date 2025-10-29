import 'package:flutter/material.dart';

/// Centralized color palette for the entire app
/// This serves as the single source of truth for all colors
class AppColors {
  // Primary Brand Colors
  static const Color primary = Colors.black;
  static const Color primaryLight = Colors.white;
  static const Color primaryDark = Colors.black;
  
  // Secondary Colors
  static const Color secondary = Colors.black;
  static const Color secondaryLight = Colors.black;
  static const Color secondaryDark = Colors.white;
  
  // Accent Colors
  static const Color accent = Colors.deepPurple;
  static const Color accentLight = Colors.deepPurple;
  static const Color accentDark = Colors.deepPurple;

    // Accent Colors
  static const Color currency = Color(0xFF00cc00);
  static const Color currencyLight = Color(0xFF00cc00);
  static const Color currencyDark = Color(0xFF00cc00);
  
  // Neutral Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF686868);
  static const Color lightGrey = Color(0xFF899A96);
  static const Color darkGrey = Color(0xFF30444E);
  
  // Status Colors
  static const Color success = Color(0xFF15D374);
  static const Color warning = Color(0xFFFF9933);
  static const Color error = Color(0xFFFF636B);
  static const Color info = Color(0xFF33C0FF);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFEDF1FA);
  static const Color backgroundDark = Color(0xFF1F2E35);
  static const Color cardLight = Color(0xFFfafafa);
  static const Color cardDark = Color.fromARGB(0, 255, 255, 255);
  
  // Text Colors
  static const Color textPrimaryLight = Colors.black;
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryLight = Color.fromARGB(143, 0, 0, 0);
  static const Color textSecondaryDark = Color.fromARGB(143, 255, 255, 255);
  
  // Interactive Colors
  static const Color buttonTextLight = Colors.white;
  static const Color buttonTextDark = Colors.black;
  static const Color buttonBackgroundLight = Colors.black;
  static const Color buttonBackgroundDark = Colors.white;
  static const Color chipTextLight = Colors.white;
  static const Color chipTextDark = Color.fromARGB(0, 255, 255, 255);
  
  // Utility function to convert hex to color
  static Color hexToColor(String hex) {
    assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex));
    return Color(int.parse(hex.substring(1), radix: 16) + (hex.length == 7 ? 0xFF000000 : 0x00000000));
  }
} 