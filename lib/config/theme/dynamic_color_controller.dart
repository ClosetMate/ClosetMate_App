import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_colors.dart';
import '../../app/data/local/my_shared_pref.dart';

/// Dynamic Color Controller for managing custom color schemes
/// Integrates with the existing GetX theme system
class DynamicColorController extends GetxController {
  static DynamicColorController get to => Get.find();

  // Observable color properties for Light Theme
  final Rx<Color> _primaryColorLight = AppColors.primaryLight.obs;
  final Rx<Color> _secondaryColorLight = AppColors.secondaryLight.obs;
  final Rx<Color> _accentColorLight = AppColors.accentLight.obs;
  final Rx<Color> _backgroundColorLight = AppColors.backgroundLight.obs;
  final Rx<Color> _cardColorLight = AppColors.cardLight.obs;
  final Rx<Color> _textColorLight = AppColors.textPrimaryLight.obs;
  final Rx<Color> _textSecondaryColorLight = AppColors.textSecondaryLight.obs;
  final Rx<Color> _textHintColorLight = AppColors.grey.obs;
  final Rx<Color> _buttonTextColorLight = AppColors.buttonTextLight.obs;
  final Rx<Color> _buttonBackgroundColorLight = AppColors.buttonBackgroundLight.obs;
  final Rx<Color> _chipTextColorLight = AppColors.chipTextLight.obs;
  final Rx<Color> _iconColorLight = AppColors.lightGrey.obs;
  final Rx<Color> _appBarIconColorLight = AppColors.white.obs;
  final Rx<Color> _dividerColorLight = AppColors.primary.obs;
  final Rx<Color> _progressIndicatorColorLight = AppColors.accent.obs;
  final Rx<Color> _currencyColorLight = const Color.fromARGB(255, 0, 0, 0).obs;

  // Observable color properties for Dark Theme
  final Rx<Color> _primaryColorDark = AppColors.primaryDark.obs;
  final Rx<Color> _secondaryColorDark = AppColors.secondaryDark.obs;
  final Rx<Color> _accentColorDark = AppColors.accentDark.obs;
  final Rx<Color> _backgroundColorDark = AppColors.backgroundDark.obs;
  final Rx<Color> _cardColorDark = AppColors.cardDark.obs;
  final Rx<Color> _textColorDark = AppColors.textPrimaryDark.obs;
  final Rx<Color> _textSecondaryColorDark = AppColors.textSecondaryDark.obs;
  final Rx<Color> _textHintColorDark = AppColors.grey.obs;
  final Rx<Color> _buttonTextColorDark = AppColors.buttonTextDark.obs;
  final Rx<Color> _buttonBackgroundColorDark = AppColors.buttonBackgroundDark.obs;
  final Rx<Color> _chipTextColorDark = AppColors.chipTextDark.obs;
  final Rx<Color> _iconColorDark = AppColors.textPrimaryDark.obs;
  final Rx<Color> _appBarIconColorDark = AppColors.white.obs;
  final Rx<Color> _dividerColorDark = AppColors.primary.obs;
  final Rx<Color> _progressIndicatorColorDark = AppColors.accent.obs;
  final Rx<Color> _currencyColorDark = const Color.fromARGB(255, 255, 255, 255).obs;

  // Getters for reactive colors (Light Theme)
  Color get primaryColorLight => _primaryColorLight.value;
  Color get secondaryColorLight => _secondaryColorLight.value;
  Color get accentColorLight => _accentColorLight.value;
  Color get backgroundColorLight => _backgroundColorLight.value;
  Color get cardColorLight => _cardColorLight.value;
  Color get textColorLight => _textColorLight.value;
  Color get textSecondaryColorLight => _textSecondaryColorLight.value;
  Color get textHintColorLight => _textHintColorLight.value;
  Color get buttonTextColorLight => _buttonTextColorLight.value;
  Color get buttonBackgroundColorLight => _buttonBackgroundColorLight.value;
  Color get chipTextColorLight => _chipTextColorLight.value;
  Color get iconColorLight => _iconColorLight.value;
  Color get appBarIconColorLight => _appBarIconColorLight.value;
  Color get dividerColorLight => _dividerColorLight.value;
  Color get progressIndicatorColorLight => _progressIndicatorColorLight.value;
  Color get currencyColorLight => _currencyColorLight.value;

  // Getters for reactive colors (Dark Theme)
  Color get primaryColorDark => _primaryColorDark.value;
  Color get secondaryColorDark => _secondaryColorDark.value;
  Color get accentColorDark => _accentColorDark.value;
  Color get backgroundColorDark => _backgroundColorDark.value;
  Color get cardColorDark => _cardColorDark.value;
  Color get textColorDark => _textColorDark.value;
  Color get textSecondaryColorDark => _textSecondaryColorDark.value;
  Color get textHintColorDark => _textHintColorDark.value;
  Color get buttonTextColorDark => _buttonTextColorDark.value;
  Color get buttonBackgroundColorDark => _buttonBackgroundColorDark.value;
  Color get chipTextColorDark => _chipTextColorDark.value;
  Color get iconColorDark => _iconColorDark.value;
  Color get appBarIconColorDark => _appBarIconColorDark.value;
  Color get dividerColorDark => _dividerColorDark.value;
  Color get progressIndicatorColorDark => _progressIndicatorColorDark.value;
  Color get currencyColorDark => _currencyColorDark.value;

  // Storage keys for custom colors (Light Theme)
  static const String _primaryColorLightKey = 'custom_primary_color_light';
  static const String _secondaryColorLightKey = 'custom_secondary_color_light';
  static const String _accentColorLightKey = 'custom_accent_color_light';
  static const String _backgroundColorLightKey = 'custom_background_color_light';
  static const String _cardColorLightKey = 'custom_card_color_light';
  static const String _textColorLightKey = 'custom_text_color_light';
  static const String _textSecondaryColorLightKey = 'custom_text_secondary_color_light';
  static const String _textHintColorLightKey = 'custom_text_hint_color_light';
  static const String _buttonTextColorLightKey = 'custom_button_text_color_light';
  static const String _buttonBackgroundColorLightKey = 'custom_button_background_color_light';
  static const String _chipTextColorLightKey = 'custom_chip_text_color_light';
  static const String _iconColorLightKey = 'custom_icon_color_light';
  static const String _appBarIconColorLightKey = 'custom_app_bar_icon_color_light';
  static const String _dividerColorLightKey = 'custom_divider_color_light';
  static const String _progressIndicatorColorLightKey = 'custom_progress_indicator_color_light';
  static const String _currencyColorLightKey = 'custom_currency_color_light';

  // Storage keys for custom colors (Dark Theme)
  static const String _primaryColorDarkKey = 'custom_primary_color_dark';
  static const String _secondaryColorDarkKey = 'custom_secondary_color_dark';
  static const String _accentColorDarkKey = 'custom_accent_color_dark';
  static const String _backgroundColorDarkKey = 'custom_background_color_dark';
  static const String _cardColorDarkKey = 'custom_card_color_dark';
  static const String _textColorDarkKey = 'custom_text_color_dark';
  static const String _textSecondaryColorDarkKey = 'custom_text_secondary_color_dark';
  static const String _textHintColorDarkKey = 'custom_text_hint_color_dark';
  static const String _buttonTextColorDarkKey = 'custom_button_text_color_dark';
  static const String _buttonBackgroundColorDarkKey = 'custom_button_background_color_dark';
  static const String _chipTextColorDarkKey = 'custom_chip_text_color_dark';
  static const String _iconColorDarkKey = 'custom_icon_color_dark';
  static const String _appBarIconColorDarkKey = 'custom_app_bar_icon_color_dark';
  static const String _dividerColorDarkKey = 'custom_divider_color_dark';
  static const String _progressIndicatorColorDarkKey = 'custom_progress_indicator_color_dark';
  static const String _currencyColorDarkKey = 'custom_currency_color_dark';

  static const String _hasCustomColorsKey = 'has_custom_colors';

  @override
  void onInit() {
    super.onInit();
    _loadCustomColors();
  }

  /// Load custom colors from SharedPreferences
  void _loadCustomColors() {
    final hasCustomColors = MySharedPref.getBool(_hasCustomColorsKey) ?? false;
    
    if (hasCustomColors) {
      // Load Light Theme colors
      _primaryColorLight.value = Color(MySharedPref.getInt(_primaryColorLightKey) ?? AppColors.primaryLight.value);
      _secondaryColorLight.value = Color(MySharedPref.getInt(_secondaryColorLightKey) ?? AppColors.secondaryLight.value);
      _accentColorLight.value = Color(MySharedPref.getInt(_accentColorLightKey) ?? AppColors.accentLight.value);
      _backgroundColorLight.value = Color(MySharedPref.getInt(_backgroundColorLightKey) ?? AppColors.backgroundLight.value);
      _cardColorLight.value = Color(MySharedPref.getInt(_cardColorLightKey) ?? AppColors.cardLight.value);
      _textColorLight.value = Color(MySharedPref.getInt(_textColorLightKey) ?? AppColors.textPrimaryLight.value);
      _textSecondaryColorLight.value = Color(MySharedPref.getInt(_textSecondaryColorLightKey) ?? AppColors.textSecondaryLight.value);
      _textHintColorLight.value = Color(MySharedPref.getInt(_textHintColorLightKey) ?? AppColors.grey.value);
      _buttonTextColorLight.value = Color(MySharedPref.getInt(_buttonTextColorLightKey) ?? AppColors.buttonTextLight.value);
      _buttonBackgroundColorLight.value = Color(MySharedPref.getInt(_buttonBackgroundColorLightKey) ?? AppColors.buttonBackgroundLight.value);
      _chipTextColorLight.value = Color(MySharedPref.getInt(_chipTextColorLightKey) ?? AppColors.chipTextLight.value);
      _iconColorLight.value = Color(MySharedPref.getInt(_iconColorLightKey) ?? AppColors.lightGrey.value);
      _appBarIconColorLight.value = Color(MySharedPref.getInt(_appBarIconColorLightKey) ?? AppColors.white.value);
      _dividerColorLight.value = Color(MySharedPref.getInt(_dividerColorLightKey) ?? AppColors.primaryLight.value);
      _progressIndicatorColorLight.value = Color(MySharedPref.getInt(_progressIndicatorColorLightKey) ?? AppColors.accentLight.value);
      _currencyColorLight.value = Color(MySharedPref.getInt(_currencyColorLightKey) ?? const Color.fromARGB(255, 0, 0, 0).value);

      // Load Dark Theme colors
      _primaryColorDark.value = Color(MySharedPref.getInt(_primaryColorDarkKey) ?? AppColors.primaryDark.value);
      _secondaryColorDark.value = Color(MySharedPref.getInt(_secondaryColorDarkKey) ?? AppColors.secondaryDark.value);
      _accentColorDark.value = Color(MySharedPref.getInt(_accentColorDarkKey) ?? AppColors.accentDark.value);
      _backgroundColorDark.value = Color(MySharedPref.getInt(_backgroundColorDarkKey) ?? AppColors.backgroundDark.value);
      _cardColorDark.value = Color(MySharedPref.getInt(_cardColorDarkKey) ?? AppColors.cardDark.value);
      _textColorDark.value = Color(MySharedPref.getInt(_textColorDarkKey) ?? AppColors.textPrimaryDark.value);
      _textSecondaryColorDark.value = Color(MySharedPref.getInt(_textSecondaryColorDarkKey) ?? AppColors.textSecondaryDark.value);
      _textHintColorDark.value = Color(MySharedPref.getInt(_textHintColorDarkKey) ?? AppColors.grey.value);
      _buttonTextColorDark.value = Color(MySharedPref.getInt(_buttonTextColorDarkKey) ?? AppColors.buttonTextDark.value);
      _buttonBackgroundColorDark.value = Color(MySharedPref.getInt(_buttonBackgroundColorDarkKey) ?? AppColors.buttonBackgroundDark.value);
      _chipTextColorDark.value = Color(MySharedPref.getInt(_chipTextColorDarkKey) ?? AppColors.chipTextDark.value);
      _iconColorDark.value = Color(MySharedPref.getInt(_iconColorDarkKey) ?? AppColors.textPrimaryDark.value);
      _appBarIconColorDark.value = Color(MySharedPref.getInt(_appBarIconColorDarkKey) ?? AppColors.white.value);
      _dividerColorDark.value = Color(MySharedPref.getInt(_dividerColorDarkKey) ?? AppColors.primaryDark.value);
      _progressIndicatorColorDark.value = Color(MySharedPref.getInt(_progressIndicatorColorDarkKey) ?? AppColors.accentDark.value);
      _currencyColorDark.value = Color(MySharedPref.getInt(_currencyColorDarkKey) ?? const Color.fromARGB(255, 255, 255, 255).value);
    }
  }

  /// Save custom colors to SharedPreferences
  Future<void> _saveCustomColors() async {
    // Save Light Theme colors
    await MySharedPref.setInt(_primaryColorLightKey, _primaryColorLight.value.value);
    await MySharedPref.setInt(_secondaryColorLightKey, _secondaryColorLight.value.value);
    await MySharedPref.setInt(_accentColorLightKey, _accentColorLight.value.value);
    await MySharedPref.setInt(_backgroundColorLightKey, _backgroundColorLight.value.value);
    await MySharedPref.setInt(_cardColorLightKey, _cardColorLight.value.value);
    await MySharedPref.setInt(_textColorLightKey, _textColorLight.value.value);
    await MySharedPref.setInt(_textSecondaryColorLightKey, _textSecondaryColorLight.value.value);
    await MySharedPref.setInt(_textHintColorLightKey, _textHintColorLight.value.value);
    await MySharedPref.setInt(_buttonTextColorLightKey, _buttonTextColorLight.value.value);
    await MySharedPref.setInt(_buttonBackgroundColorLightKey, _buttonBackgroundColorLight.value.value);
    await MySharedPref.setInt(_chipTextColorLightKey, _chipTextColorLight.value.value);
    await MySharedPref.setInt(_iconColorLightKey, _iconColorLight.value.value);
    await MySharedPref.setInt(_appBarIconColorLightKey, _appBarIconColorLight.value.value);
    await MySharedPref.setInt(_dividerColorLightKey, _dividerColorLight.value.value);
    await MySharedPref.setInt(_progressIndicatorColorLightKey, _progressIndicatorColorLight.value.value);
    await MySharedPref.setInt(_currencyColorLightKey, _currencyColorLight.value.value);

    // Save Dark Theme colors
    await MySharedPref.setInt(_primaryColorDarkKey, _primaryColorDark.value.value);
    await MySharedPref.setInt(_secondaryColorDarkKey, _secondaryColorDark.value.value);
    await MySharedPref.setInt(_accentColorDarkKey, _accentColorDark.value.value);
    await MySharedPref.setInt(_backgroundColorDarkKey, _backgroundColorDark.value.value);
    await MySharedPref.setInt(_cardColorDarkKey, _cardColorDark.value.value);
    await MySharedPref.setInt(_textColorDarkKey, _textColorDark.value.value);
    await MySharedPref.setInt(_textSecondaryColorDarkKey, _textSecondaryColorDark.value.value);
    await MySharedPref.setInt(_textHintColorDarkKey, _textHintColorDark.value.value);
    await MySharedPref.setInt(_buttonTextColorDarkKey, _buttonTextColorDark.value.value);
    await MySharedPref.setInt(_buttonBackgroundColorDarkKey, _buttonBackgroundColorDark.value.value);
    await MySharedPref.setInt(_chipTextColorDarkKey, _chipTextColorDark.value.value);
    await MySharedPref.setInt(_iconColorDarkKey, _iconColorDark.value.value);
    await MySharedPref.setInt(_appBarIconColorDarkKey, _appBarIconColorDark.value.value);
    await MySharedPref.setInt(_dividerColorDarkKey, _dividerColorDark.value.value);
    await MySharedPref.setInt(_progressIndicatorColorDarkKey, _progressIndicatorColorDark.value.value);
    await MySharedPref.setInt(_currencyColorDarkKey, _currencyColorDark.value.value);

    await MySharedPref.setBool(_hasCustomColorsKey, true);
  }

  /// Update primary color for specific theme
  void updatePrimaryColor(Color color, bool isLight) {
    if (isLight) {
      _primaryColorLight.value = color;
    } else {
      _primaryColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }

  /// Update secondary color for specific theme
  void updateSecondaryColor(Color color, bool isLight) {
    if (isLight) {
      _secondaryColorLight.value = color;
    } else {
      _secondaryColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }

  /// Update accent color for specific theme
  void updateAccentColor(Color color, bool isLight) {
    if (isLight) {
      _accentColorLight.value = color;
    } else {
      _accentColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }

  /// Update background color for specific theme
  void updateBackgroundColor(Color color, bool isLight) {
    if (isLight) {
      _backgroundColorLight.value = color;
    } else {
      _backgroundColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }

  /// Update card color for specific theme
  void updateCardColor(Color color, bool isLight) {
    if (isLight) {
      _cardColorLight.value = color;
    } else {
      _cardColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }

  /// Update text color for specific theme
  void updateTextColor(Color color, bool isLight) {
    if (isLight) {
      _textColorLight.value = color;
    } else {
      _textColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }

  /// Update text secondary color for specific theme
  void updateTextSecondaryColor(Color color, bool isLight) {
    if (isLight) {
      _textSecondaryColorLight.value = color;
    } else {
      _textSecondaryColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }

  /// Update text hint color for specific theme
  void updateTextHintColor(Color color, bool isLight) {
    if (isLight) {
      _textHintColorLight.value = color;
    } else {
      _textHintColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }

  /// Update button text color for specific theme
  void updateButtonTextColor(Color color, bool isLight) {
    if (isLight) {
      _buttonTextColorLight.value = color;
    } else {
      _buttonTextColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }
  
  /// Update button background color for specific theme
  void updateButtonBackgroundColor(Color color, bool isLight) {
    if (isLight) {
      _buttonBackgroundColorLight.value = color;
    } else {
      _buttonBackgroundColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }
  
  /// Update chip text color for specific theme
  void updateChipTextColor(Color color, bool isLight) {
    if (isLight) {
      _chipTextColorLight.value = color;
    } else {
      _chipTextColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }

  /// Update icon color for specific theme
  void updateIconColor(Color color, bool isLight) {
    if (isLight) {
      _iconColorLight.value = color;
    } else {
      _iconColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }

  /// Update app bar icon color for specific theme
  void updateAppBarIconColor(Color color, bool isLight) {
    if (isLight) {
      _appBarIconColorLight.value = color;
    } else {
      _appBarIconColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }

  /// Update divider color for specific theme
  void updateDividerColor(Color color, bool isLight) {
    if (isLight) {
      _dividerColorLight.value = color;
    } else {
      _dividerColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }

  /// Update progress indicator color for specific theme
  void updateProgressIndicatorColor(Color color, bool isLight) {
    if (isLight) {
      _progressIndicatorColorLight.value = color;
    } else {
      _progressIndicatorColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }
  
  /// Update currency color for specific theme
  void updateCurrencyColor(Color color, bool isLight) {
    if (isLight) {
      _currencyColorLight.value = color;
    } else {
      _currencyColorDark.value = color;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }

  /// Apply a complete color scheme for specific theme
  void applyColorScheme({
    required Color primary,
    required Color secondary,
    required Color accent,
    required Color background,
    required Color card,
    required Color text,
    required bool isLight,
  }) {
    if (isLight) {
      _primaryColorLight.value = primary;
      _secondaryColorLight.value = secondary;
      _accentColorLight.value = accent;
      _backgroundColorLight.value = background;
      _cardColorLight.value = card;
      _textColorLight.value = text;
    } else {
      _primaryColorDark.value = primary;
      _secondaryColorDark.value = secondary;
      _accentColorDark.value = accent;
      _backgroundColorDark.value = background;
      _cardColorDark.value = card;
      _textColorDark.value = text;
    }
    _saveCustomColors();
    _notifyThemeUpdate();
  }

  /// Reset to default colors
  Future<void> resetToDefaultColors() async {
    // Reset Light Theme colors
    _primaryColorLight.value = AppColors.primaryLight;
    _secondaryColorLight.value = AppColors.secondaryLight;
    _accentColorLight.value = AppColors.accentLight;
    _backgroundColorLight.value = AppColors.backgroundLight;
    _cardColorLight.value = AppColors.cardLight;
    _textColorLight.value = AppColors.textPrimaryLight;
    _textSecondaryColorLight.value = AppColors.textSecondaryLight;
    _textHintColorLight.value = AppColors.grey;
    _buttonTextColorLight.value = AppColors.buttonTextLight;
    _buttonBackgroundColorLight.value = AppColors.buttonBackgroundLight;
    _chipTextColorLight.value = AppColors.chipTextLight;
    _iconColorLight.value = AppColors.lightGrey;
    _appBarIconColorLight.value = AppColors.white;
    _dividerColorLight.value = AppColors.primaryLight;
    _progressIndicatorColorLight.value = AppColors.accentLight;
    _currencyColorLight.value = const Color.fromARGB(255, 0, 0, 0);

    // Reset Dark Theme colors
    _primaryColorDark.value = AppColors.primaryDark;
    _secondaryColorDark.value = AppColors.secondaryDark;
    _accentColorDark.value = AppColors.accentDark;
    _backgroundColorDark.value = AppColors.backgroundDark;
    _cardColorDark.value = AppColors.cardDark;
    _textColorDark.value = AppColors.textPrimaryDark;
    _textSecondaryColorDark.value = AppColors.textSecondaryDark;
    _textHintColorDark.value = AppColors.grey;
    _buttonTextColorDark.value = AppColors.buttonTextDark;
    _buttonBackgroundColorDark.value = AppColors.buttonBackgroundDark;
    _chipTextColorDark.value = AppColors.chipTextDark;
    _iconColorDark.value = AppColors.textPrimaryDark;
    _appBarIconColorDark.value = AppColors.white;
    _dividerColorDark.value = AppColors.primaryDark;
    _progressIndicatorColorDark.value = AppColors.accentDark;
    _currencyColorDark.value = const Color.fromARGB(255, 255, 255, 255);
    
    await MySharedPref.setBool(_hasCustomColorsKey, false);
    _notifyThemeUpdate();
  }

  /// Check if custom colors are being used
  bool get hasCustomColors => MySharedPref.getBool(_hasCustomColorsKey) ?? false;

  /// Notify the app to update theme
  void _notifyThemeUpdate() {
    // Trigger a theme rebuild by updating the current theme mode
    final isLight = MySharedPref.getThemeIsLight();
    Get.changeThemeMode(isLight ? ThemeMode.light : ThemeMode.dark);
  }

  /// Get colors based on theme mode
  Color getPrimaryColor(bool isLight) => hasCustomColors 
      ? (isLight ? primaryColorLight : primaryColorDark) 
      : (isLight ? AppColors.primaryLight : AppColors.primaryDark);
      
  Color getSecondaryColor(bool isLight) => hasCustomColors 
      ? (isLight ? secondaryColorLight : secondaryColorDark) 
      : (isLight ? AppColors.secondaryLight : AppColors.secondaryDark);
      
  Color getAccentColor(bool isLight) => hasCustomColors 
      ? (isLight ? accentColorLight : accentColorDark) 
      : (isLight ? AppColors.accentLight : AppColors.accentDark);
      
  Color getBackgroundColor(bool isLight) => hasCustomColors 
      ? (isLight ? backgroundColorLight : backgroundColorDark) 
      : (isLight ? AppColors.backgroundLight : AppColors.backgroundDark);
      
  Color getCardColor(bool isLight) => hasCustomColors 
      ? (isLight ? cardColorLight : cardColorDark) 
      : (isLight ? AppColors.cardLight : AppColors.cardDark);
      
  Color getTextColor(bool isLight) => hasCustomColors 
      ? (isLight ? textColorLight : textColorDark) 
      : (isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark);

  Color getTextSecondaryColor(bool isLight) => hasCustomColors 
      ? (isLight ? textSecondaryColorLight : textSecondaryColorDark) 
      : (isLight ? AppColors.textSecondaryLight : AppColors.textSecondaryDark);

  Color getTextHintColor(bool isLight) => hasCustomColors 
      ? (isLight ? textHintColorLight : textHintColorDark) 
      : AppColors.grey;

  Color getButtonTextColor(bool isLight) => hasCustomColors 
      ? (isLight ? buttonTextColorLight : buttonTextColorDark) 
      : (isLight ? AppColors.buttonTextLight : AppColors.buttonTextDark);

  Color getButtonBackgroundColor(bool isLight) => hasCustomColors 
      ? (isLight ? buttonBackgroundColorLight : buttonBackgroundColorDark) 
      : (isLight ? AppColors.buttonBackgroundLight : AppColors.buttonBackgroundDark);

  Color getChipTextColor(bool isLight) => hasCustomColors 
      ? (isLight ? chipTextColorLight : chipTextColorDark) 
      : (isLight ? AppColors.chipTextLight : AppColors.chipTextDark);

  Color getIconColor(bool isLight) => hasCustomColors 
      ? (isLight ? iconColorLight : iconColorDark) 
      : (isLight ? AppColors.lightGrey : AppColors.textPrimaryDark);

  Color getAppBarIconColor(bool isLight) => hasCustomColors 
      ? (isLight ? appBarIconColorLight : appBarIconColorDark) 
      : AppColors.white;

  Color getDividerColor(bool isLight) => hasCustomColors 
      ? (isLight ? dividerColorLight : dividerColorDark) 
      : (isLight ? AppColors.primaryLight : AppColors.primaryDark);

  Color getProgressIndicatorColor(bool isLight) => hasCustomColors 
      ? (isLight ? progressIndicatorColorLight : progressIndicatorColorDark) 
      : (isLight ? AppColors.accentLight : AppColors.accentDark);

  Color getCurrencyColor(bool isLight) => hasCustomColors 
      ? (isLight ? currencyColorLight : currencyColorDark) 
      : (isLight ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 255, 255, 255));
}

