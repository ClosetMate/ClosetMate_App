import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'theme_colors.dart';
import 'my_fonts.dart';

class MyStyles {
  ///icons theme
  static IconThemeData getIconTheme({required bool isLightTheme}) =>
      IconThemeData(
        color: ThemeColors.getIcon(isLightTheme),
      );

  ///app bar theme
  static AppBarTheme getAppBarTheme({required bool isLightTheme}) =>
      AppBarTheme(
        elevation: 0,
        titleTextStyle:
        getTextTheme(isLightTheme: isLightTheme).bodyMedium!.copyWith(
          color: Colors.white,
          fontSize: MyFonts.appBarTittleSize,
        ),
        iconTheme: IconThemeData(
            color: ThemeColors.getAppBarIcon(isLightTheme)),
        backgroundColor: ThemeColors.getPrimary(isLightTheme),
      );

  ///text theme
  static TextTheme getTextTheme({required bool isLightTheme}) => TextTheme(
    labelLarge: MyFonts.buttonTextStyle.copyWith(
      fontSize: MyFonts.buttonTextSize,
    ),
    bodyLarge: (MyFonts.bodyTextStyle).copyWith(
      fontWeight: FontWeight.bold,
      fontSize: MyFonts.bodyLargeSize,
      color: ThemeColors.getTextPrimary(isLightTheme),
    ),
    bodyMedium: (MyFonts.bodyTextStyle).copyWith(
      fontSize: MyFonts.bodyMediumSize,
      color: ThemeColors.getTextPrimary(isLightTheme),
    ),
    displayLarge: (MyFonts.displayTextStyle).copyWith(
      fontSize: MyFonts.displayLargeSize,
      fontWeight: FontWeight.bold,
      color: ThemeColors.getTextPrimary(isLightTheme),
    ),
    bodySmall: TextStyle(
        color: ThemeColors.getTextSecondary(isLightTheme),
        fontSize: MyFonts.bodySmallTextSize),
    displayMedium: (MyFonts.displayTextStyle).copyWith(
        fontSize: MyFonts.displayMediumSize,
        fontWeight: FontWeight.bold,
        color: ThemeColors.getTextPrimary(isLightTheme)),
    displaySmall: (MyFonts.displayTextStyle).copyWith(
      fontSize: MyFonts.displaySmallSize,
      fontWeight: FontWeight.bold,
      color: ThemeColors.getTextPrimary(isLightTheme),
    ),
  );

  static ChipThemeData getChipTheme({required bool isLightTheme}) {
    return ChipThemeData(
      backgroundColor: ThemeColors.getPrimary(isLightTheme),
      brightness: Brightness.light,
      labelStyle: getChipTextStyle(isLightTheme: isLightTheme),
      secondaryLabelStyle: getChipTextStyle(isLightTheme: isLightTheme),
      selectedColor: Colors.black,
      disabledColor: Colors.green,
      padding: const EdgeInsets.all(5),
      secondarySelectedColor: Colors.purple,
    );
  }

  ///Chips text style
  static TextStyle getChipTextStyle({required bool isLightTheme}) {
    return MyFonts.chipTextStyle.copyWith(
      fontSize: MyFonts.chipTextSize,
      color: ThemeColors.getChipText(isLightTheme),
    );
  }

  // elevated button text style
  static WidgetStateProperty<TextStyle?>? getElevatedButtonTextStyle(
      bool isLightTheme,
      {bool isBold = true,
      double? fontSize}) {
    return WidgetStateProperty.resolveWith<TextStyle>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return MyFonts.buttonTextStyle.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: fontSize ?? MyFonts.buttonTextSize,
              color: ThemeColors.getButtonText(isLightTheme));
        } else if (states.contains(WidgetState.disabled)) {
          return MyFonts.buttonTextStyle.copyWith(
              fontSize: fontSize ?? MyFonts.buttonTextSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: AppColors.grey);
        }
        return MyFonts.buttonTextStyle.copyWith(
            fontSize: fontSize ?? MyFonts.buttonTextSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: ThemeColors.getButtonText(isLightTheme));
      },
    );
  }

  //elevated button theme data
  static ElevatedButtonThemeData getElevatedButtonTheme(
          {required bool isLightTheme}) =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          elevation: WidgetStateProperty.all(0),
          padding:
              WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 8.h)),
          textStyle: getElevatedButtonTextStyle(isLightTheme),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return ThemeColors.getPrimary(isLightTheme).withOpacity(0.5);
              } else if (states.contains(WidgetState.disabled)) {
                return AppColors.grey;
              }
              return ThemeColors.getPrimary(isLightTheme);
            },
          ),
        ),
      );
}
