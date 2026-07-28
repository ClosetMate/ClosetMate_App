import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MyFonts {
  // Anton - Buttons
  static TextStyle get buttonTextStyle => GoogleFonts.anton();

  // Inter SemiBold - Body Text
  static TextStyle get bodyTextStyle => GoogleFonts.inter(fontWeight: FontWeight.w600);
  
  // Inter Regular - Fashion/Marketing Pages
  static TextStyle get fashionTextStyle => GoogleFonts.inter(fontWeight: FontWeight.w400);

  // Satoshi - Numbers/Stats (using TextStyle fallback, assume font might be added to assets later, or fallback to Inter)
  static TextStyle get numberTextStyle => const TextStyle(fontFamily: 'Satoshi').copyWith(fontFamilyFallback: ['Inter']);

  // Inter Medium - General usage
  static TextStyle get mediumTextStyle => GoogleFonts.inter(fontWeight: FontWeight.w500);

  // General mappings
  static TextStyle get getAppFontType => GoogleFonts.inter();

  static TextStyle get headlineTextStyle => GoogleFonts.inter(fontWeight: FontWeight.w700);
  static TextStyle get appBarTextStyle  => GoogleFonts.inter(fontWeight: FontWeight.w600);
  static TextStyle get chipTextStyle  => GoogleFonts.inter(fontWeight: FontWeight.w500);
  static TextStyle get displayTextStyle => GoogleFonts.inter(fontWeight: FontWeight.w700);

  // appbar font size
  static double get appBarTittleSize => 18.sp;

  // body font size
  static double get bodySmallTextSize => 12.sp;
  static double get bodyMediumSize => 14.sp; // default font
  static double get bodyLargeSize => 20.sp;
  
  // display font size
  static double get displayLargeSize => 24.sp;
  static double get displayMediumSize => 18.sp;
  static double get displaySmallSize => 14.sp;

  // body font size
  static double get body1TextSize => 20.sp;
  static double get body2TextSize => 14.sp;

  //button font size
  static double get buttonTextSize => 16.sp;

  //caption font size
  static double get captionTextSize => 13.sp;

  //chip font size
  static double get chipTextSize => 10.sp;
}