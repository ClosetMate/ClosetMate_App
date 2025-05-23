import 'package:closet_mate/config/theme/colors.dart';
import 'package:flutter/material.dart';

class LightThemeColors
{
  //dark swatch
  static final Color primaryColor = hexToColor('#ee8b60');
  static const Color accentColor = Color(0xFFD9EDE1);

  //APPBAR
  static final Color appBarColor = primaryColor;

  //SCAFFOLD
  static const Color scaffoldBackgroundColor = Colors.white;
  static const Color backgroundColor = Color(0xFFEDF1FA);
  static final Color dividerColor = primaryColor;
  static const Color cardColor = Color(0xfffafafa);

  //ICONS
  static const Color appBarIconsColor = Colors.white;
  static const Color iconColor = Color(0xFF899A96);

  //BUTTON
  static final Color buttonColor = primaryColor;
  static const Color buttonTextColor = Colors.white;
  static const Color buttonDisabledColor = Colors.grey;
  static const Color buttonDisabledTextColor = Colors.black;

  //TEXT
  static const Color bodyTextColor = Color(0xFF30444E);
  static const Color displayTextColor = Colors.black;
  static const Color bodySmallTextColor = Color(0xFF30444E);
  static const Color hintTextColor =  Color(0xff686868);

  //chip
  static final Color chipBackground = primaryColor;
  static const Color chipTextColor = Colors.white;

  // progress bar indicator
  static const Color progressIndicatorColor = Color(0xFF40DF9F);

  static const Color closeIconColor = Color(0xFF899A96);
}