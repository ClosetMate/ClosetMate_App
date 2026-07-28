import 'package:flutter/material.dart';

/// Centralized color palette for the entire app
/// This serves as the single source of truth for all colors
class AppColors {
  // New Brand Palette
  static const Color matteBlack = Color(0xFF0A0A0A);
  static const Color softWhite = Color(0xFFF5F5F5);
  static const Color graphiteGray = Color(0xFF2A2A2A);
  static const Color customLightGray = Color(0xFFD9D9D9);
  static const Color charcoal = Color(0xFF1A1A1A);
  static const Color pureWhite = Color(0xFFFFFFFF);

  // Primary Brand Colors
  static const Color primary = matteBlack;
  static const Color primaryLight = pureWhite;
  static const Color primaryDark = matteBlack;
  
  // Secondary Colors
  static const Color secondary = graphiteGray;
  static const Color secondaryLight = customLightGray;
  static const Color secondaryDark = graphiteGray;
  
  // Accent Colors
  static const Color accent = pureWhite;
  static const Color accentLight = matteBlack;
  static const Color accentDark = pureWhite;

  static const Color currency = Color(0xFF00cc00);
  static const Color currencyLight = Color(0xFF00cc00);
  static const Color currencyDark = Color(0xFF00cc00);
  
  // Neutral Colors
  static const Color white = pureWhite;
  static const Color black = matteBlack;
  static const Color grey = customLightGray;
  static const Color lightGrey = customLightGray;
  static const Color darkGrey = graphiteGray;
  
  // Status Colors
  static const Color success = Color(0xFF15D374);
  static const Color warning = Color(0xFFFF9933);
  static const Color error = Color(0xFFFF636B);
  static const Color info = Color(0xFF33C0FF);
  
  // Background Colors
  static const Color backgroundLight = softWhite;
  static const Color backgroundDark = matteBlack;
  static const Color cardLight = pureWhite;
  static const Color cardDark = charcoal;
  
  // Text Colors
  static const Color textPrimaryLight = matteBlack;
  static const Color textPrimaryDark = pureWhite;
  static const Color textSecondaryLight = graphiteGray;
  static const Color textSecondaryDark = customLightGray;
  
  // Interactive Colors
  static const Color buttonTextLight = pureWhite;
  static const Color buttonTextDark = matteBlack; // Or Pure White if button is Graphite
  static const Color buttonBackgroundLight = matteBlack;
  static const Color buttonBackgroundDark = pureWhite; // Or Graphite Gray
  static const Color chipTextLight = matteBlack;
  static const Color chipTextDark = pureWhite;
  
  // Utility function to convert hex to color
  static Color hexToColor(String hex) {
    assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex));
    return Color(int.parse(hex.substring(1), radix: 16) + (hex.length == 7 ? 0xFF000000 : 0x00000000));
  }
}