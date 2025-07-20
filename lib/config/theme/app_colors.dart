import 'package:flutter/material.dart';

/// Centralized color palette for the entire app
/// This serves as the single source of truth for all colors
class AppColors {
  // Primary Brand Colors
  static const Color primary = Color.fromARGB(255, 0, 0, 0);
  static const Color primaryLight = Color.fromARGB(255, 0, 0, 0);
  static const Color primaryDark = Color.fromARGB(255, 0, 0, 0);
  
  // Secondary Colors
  static const Color secondary = Colors.blue;
  static const Color secondaryLight = Colors.blue;
  static const Color secondaryDark = Colors.blue;
  
  // Accent Colors
  static const Color accent = Color(0xFF40DF9F);
  static const Color accentLight = Color(0xFF6BE8B8);
  static const Color accentDark = Color(0xFF2BC87A);

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
  static const Color cardDark = Color.fromARGB(255, 0, 0, 0);
  
  // Text Colors
  static const Color textPrimaryLight = Color(0xFF30444E);
  static const Color textPrimaryDark = Color(0xFF96A7AF);
  static const Color textSecondaryLight = Color(0xFF686868);
  static const Color textSecondaryDark = Color(0xFF96A7AF);
  
  // Interactive Colors
  static const Color buttonTextLight = Colors.white;
  static const Color buttonTextDark = Colors.black;
  static const Color chipTextLight = Colors.white;
  static const Color chipTextDark = Color(0xFF000000DD);
  
  // Utility function to convert hex to color
  static Color hexToColor(String hex) {
    assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex));
    return Color(int.parse(hex.substring(1), radix: 16) + (hex.length == 7 ? 0xFF000000 : 0x00000000));
  }
} 