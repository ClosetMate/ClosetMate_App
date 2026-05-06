import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'dynamic_color_controller.dart';

/// Theme-aware color provider
/// Automatically provides the correct colors based on the current theme
/// Now supports dynamic custom colors from the color theme controller
class ThemeColors {
  static Color getPrimary(bool isLight) {
    try {
      return DynamicColorController.to.getPrimaryColor(isLight);
    } catch (e) {
      // Fallback to default colors if controller is not initialized
      return AppColors.primary;
    }
  }
  
  static Color getSecondary(bool isLight) {
    try {
      return DynamicColorController.to.getSecondaryColor(isLight);
    } catch (e) {
      return AppColors.secondary;
    }
  }
  
  static Color getAccent(bool isLight) {
    try {
      return DynamicColorController.to.getAccentColor(isLight);
    } catch (e) {
      return AppColors.accent;
    }
  }
  
  // Background colors
  static Color getBackground(bool isLight) {
    try {
      return DynamicColorController.to.getBackgroundColor(isLight);
    } catch (e) {
      return isLight ? AppColors.backgroundLight : AppColors.backgroundDark;
    }
  }
  
  static Color getScaffoldBackground(bool isLight) {
    try {
      return DynamicColorController.to.getBackgroundColor(isLight);
    } catch (e) {
      return isLight ? AppColors.white : AppColors.backgroundDark;
    }
  }
  
  static Color getCardBackground(bool isLight) {
    try {
      return DynamicColorController.to.getCardColor(isLight);
    } catch (e) {
      return isLight ? AppColors.cardLight : AppColors.cardDark;
    }
  }
  
  //currency
  static Color getCurrency(bool isLight) {
    try {
      return DynamicColorController.to.getCurrencyColor(isLight);
    } catch (e) {
      return isLight ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 255, 255, 255);
    }
  }

  // Text colors
  static Color getTextPrimary(bool isLight) {
    try {
      return DynamicColorController.to.getTextColor(isLight);
    } catch (e) {
      return isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark;
    }
  }
  
  static Color getTextSecondary(bool isLight) {
    try {
      return DynamicColorController.to.getTextSecondaryColor(isLight);
    } catch (e) {
      return isLight ? AppColors.textSecondaryLight : AppColors.textSecondaryDark;
    }
  }
  
  static Color getTextHint(bool isLight) {
    try {
      return DynamicColorController.to.getTextHintColor(isLight);
    } catch (e) {
      return AppColors.grey;
    }
  }
  
  // Interactive colors
  static Color getButtonText(bool isLight) {
    try {
      return DynamicColorController.to.getButtonTextColor(isLight);
    } catch (e) {
      return isLight ? AppColors.buttonTextLight : AppColors.buttonTextDark;
    }
  }
  
  static Color getButtonBackground(bool isLight) {
    try {
      return DynamicColorController.to.getButtonBackgroundColor(isLight);
    } catch (e) {
      return isLight ? AppColors.buttonBackgroundLight : AppColors.buttonBackgroundDark;
    }
  }
  
  static Color getChipText(bool isLight) {
    try {
      return DynamicColorController.to.getChipTextColor(isLight);
    } catch (e) {
      return isLight ? AppColors.chipTextLight : AppColors.chipTextDark;
    }
  }
  
  static Color getIcon(bool isLight) {
    try {
      return DynamicColorController.to.getIconColor(isLight);
    } catch (e) {
      return isLight ? AppColors.lightGrey : AppColors.textPrimaryDark;
    }
  }
  
  static Color getAppBarIcon(bool isLight) {
    try {
      return DynamicColorController.to.getAppBarIconColor(isLight);
    } catch (e) {
      return AppColors.white;
    }
  }
  
  // Divider
  static Color getDivider(bool isLight) {
    try {
      return DynamicColorController.to.getDividerColor(isLight);
    } catch (e) {
      return AppColors.primary;
    }
  }
  
  // Progress indicator
  static Color getProgressIndicator(bool isLight) {
    try {
      return DynamicColorController.to.getProgressIndicatorColor(isLight);
    } catch (e) {
      return AppColors.accent;
    }
  }
  
  // Status colors (same for both themes)
  static Color getSuccess() => AppColors.success;
  static Color getWarning() => AppColors.warning;
  static Color getError() => AppColors.error;
  static Color getInfo() => AppColors.info;
} 