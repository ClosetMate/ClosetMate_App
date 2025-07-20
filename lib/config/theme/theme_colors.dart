import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Theme-aware color provider
/// Automatically provides the correct colors based on the current theme
class ThemeColors {
  static Color getPrimary(bool isLight) => AppColors.primary;
  static Color getSecondary(bool isLight) => AppColors.secondary;
  static Color getAccent(bool isLight) => AppColors.accent;
  
  // Background colors
  static Color getBackground(bool isLight) => 
      isLight ? AppColors.backgroundLight : AppColors.backgroundDark;
  static Color getScaffoldBackground(bool isLight) => 
      isLight ? AppColors.white : AppColors.backgroundDark;
  static Color getCardBackground(bool isLight) => 
      isLight ? AppColors.cardLight : AppColors.cardDark;
  
  //currency
  static Color getCurrency(bool isLight) => 
      isLight ? AppColors.currencyLight : AppColors.currencyDark;

  // Text colors
  static Color getTextPrimary(bool isLight) => 
      isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark;
  static Color getTextSecondary(bool isLight) => 
      isLight ? AppColors.textSecondaryLight : AppColors.textSecondaryDark;
  static Color getTextHint(bool isLight) => AppColors.grey;
  
  // Interactive colors
  static Color getButtonText(bool isLight) => 
      isLight ? AppColors.buttonTextLight : AppColors.buttonTextDark;
  static Color getChipText(bool isLight) => 
      isLight ? AppColors.chipTextLight : AppColors.chipTextDark;
  static Color getIcon(bool isLight) => 
      isLight ? AppColors.lightGrey : AppColors.textPrimaryDark;
  static Color getAppBarIcon(bool isLight) => AppColors.white;
  
  // Divider
  static Color getDivider(bool isLight) => AppColors.primary;
  
  // Progress indicator
  static Color getProgressIndicator(bool isLight) => AppColors.accent;
  
  // Status colors (same for both themes)
  static Color getSuccess() => AppColors.success;
  static Color getWarning() => AppColors.warning;
  static Color getError() => AppColors.error;
  static Color getInfo() => AppColors.info;
} 