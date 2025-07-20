import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/data/local/my_shared_pref.dart';
import 'theme_colors.dart';
import 'my_styles.dart';

class MyTheme {
  static getThemeData({required bool isLight}) {
    return ThemeData(
      useMaterial3: true,
      // main color (app bar,tabs..etc)
      primaryColor: ThemeColors.getPrimary(isLight),
      // secondary color (for checkbox,float button, radio..etc)
      // secondary & background color
      colorScheme: ColorScheme.fromSwatch(
        accentColor: ThemeColors.getAccent(isLight),
        backgroundColor: ThemeColors.getBackground(isLight),
        brightness: isLight ? Brightness.light : Brightness.dark,
      ).copyWith(
        secondary: ThemeColors.getSecondary(isLight),
      ),
      // color contrast (if the theme is dark text should be white for example)
      brightness: isLight ? Brightness.light : Brightness.dark,
      // card widget background color
      cardColor: ThemeColors.getCardBackground(isLight),
      // hint text color
      hintColor: ThemeColors.getTextHint(isLight),
      // divider color
      dividerTheme: DividerThemeData(
        color: ThemeColors.getDivider(isLight),
      ),
      // app background color
      scaffoldBackgroundColor: ThemeColors.getScaffoldBackground(isLight),

      // progress bar theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: ThemeColors.getProgressIndicator(isLight),
      ),

      // appBar theme
      appBarTheme: MyStyles.getAppBarTheme(isLightTheme: isLight),

      // elevated button theme
      elevatedButtonTheme: MyStyles.getElevatedButtonTheme(
        isLightTheme: isLight,
      ),

      // text theme
      textTheme: MyStyles.getTextTheme(isLightTheme: isLight),

      // chip theme
      chipTheme: MyStyles.getChipTheme(isLightTheme: isLight),

      // icon theme
      iconTheme: MyStyles.getIconTheme(isLightTheme: isLight),
    );
  }

  /// update app theme and save theme type to shared pref
  /// (so when the app is killed and up again theme will remain the same)
  static changeTheme(bool isLightTheme) {
    // *) check if the current theme is light (default is light)
    // bool isTheme = isLightTheme! ? isLightTheme : MySharedPref.getThemeIsLight();
    // *) store the new theme mode on get storage
    MySharedPref.setThemeIsLight(isLightTheme);
    // *) let GetX change theme
    Get.changeThemeMode(isLightTheme ? ThemeMode.light : ThemeMode.dark);
  }

  /// check if the theme is light or dark
  bool get getThemeIsLight => MySharedPref.getThemeIsLight();
}
