import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:closet_mate/models/user_measurements.dart';

class MySharedPref {
  // prevent making instance
  MySharedPref._();

  // get storage
  static late SharedPreferences _sharedPreferences;

  // STORING KEYS
  static const String _fcmTokenKey = 'fcm_token';
  static const String _lightThemeKey = 'is_theme_light';
  static const String _userMeasurementsKey = 'user_measurements';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userAvatarPathKey = 'user_avatar_path';
  static const String _userAvatarBytesKey = 'user_avatar_bytes';

  /// init get storage services
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  /// set theme current type as light theme
  static Future<void> setThemeIsLight(bool lightTheme) =>
      _sharedPreferences.setBool(_lightThemeKey, lightTheme);

  /// get if the current theme type is light
  static bool getThemeIsLight() =>
      _sharedPreferences.getBool(_lightThemeKey) ?? true; // todo set the default theme (true for light, false for dark)

  /// save generated fcm token
  static Future<void> setFcmToken(String token) =>
      _sharedPreferences.setString(_fcmTokenKey, token);

  /// get generated fcm token
  static String? getFcmToken() =>
      _sharedPreferences.getString(_fcmTokenKey);

  /// clear all data from shared pref
  static Future<void> clear() async => await _sharedPreferences.clear();

  /// Save user measurements as JSON string
  static Future<void> setUserMeasurements(UserMeasurements measurements) async {
    final String jsonString = jsonEncode(measurements.toJson());
    await _sharedPreferences.setString(_userMeasurementsKey, jsonString);
  }

  /// Get user measurements if exist
  static UserMeasurements? getUserMeasurements() {
    final String? jsonString = _sharedPreferences.getString(_userMeasurementsKey);
    if (jsonString == null) return null;
    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserMeasurements.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  /// Remove saved user measurements
  static Future<void> clearUserMeasurements() async =>
      _sharedPreferences.remove(_userMeasurementsKey);

  /// Clear all user-specific data (measurements, tokens, profile) but preserve app settings (theme)
  static Future<void> clearUserData() async {
    await _sharedPreferences.remove(_fcmTokenKey);
    await _sharedPreferences.remove(_userMeasurementsKey);
    await clearUserProfile();
    // Note: We preserve _lightThemeKey as it's an app preference, not user data
  }

  /// Set integer value
  static Future<void> setInt(String key, int value) =>
      _sharedPreferences.setInt(key, value);

  /// Get integer value
  static int? getInt(String key) => _sharedPreferences.getInt(key);

  /// Set boolean value
  static Future<void> setBool(String key, bool value) =>
      _sharedPreferences.setBool(key, value);

  /// Get boolean value
  static bool? getBool(String key) => _sharedPreferences.getBool(key);

  /// Set string value
  static Future<void> setString(String key, String value) =>
      _sharedPreferences.setString(key, value);

  /// Get string value
  static String? getString(String key) => _sharedPreferences.getString(key);

  /// Save user profile data
  static Future<void> setUserName(String name) =>
      _sharedPreferences.setString(_userNameKey, name);

  static Future<void> setUserEmail(String email) =>
      _sharedPreferences.setString(_userEmailKey, email);

  /// Get user profile data
  static String? getUserName() => _sharedPreferences.getString(_userNameKey);
  static String? getUserEmail() => _sharedPreferences.getString(_userEmailKey);

  /// Clear user profile data
  static Future<void> clearUserProfile() async {
    await _sharedPreferences.remove(_userNameKey);
    await _sharedPreferences.remove(_userEmailKey);
    await _sharedPreferences.remove(_userAvatarPathKey);
    await _sharedPreferences.remove(_userAvatarBytesKey);
  }

}