import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:closet_mate/app/data/local/my_shared_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  String userName = '';
  String userEmail = '';
  final Rx<dynamic> avatarImage = Rx<dynamic>(null); // Can be File (mobile) or Uint8List (web) or null
  
  @override
  void onInit() {
    super.onInit();
    _loadProfileData();
  }
  
  /// Load profile data from storage
  Future<void> loadProfileData() async {
    userName = MySharedPref.getUserName() ?? 'Vinay Varma';
    userEmail = MySharedPref.getUserEmail() ?? 'vinayvarma@gmail.com';
    await _loadAvatar();
    update();
  }
  
  /// Private method called on init
  void _loadProfileData() {
    userName = MySharedPref.getUserName() ?? 'Vinay Varma';
    userEmail = MySharedPref.getUserEmail() ?? 'vinayvarma@gmail.com';
    _loadAvatar();
  }
  
  /// Load avatar from storage
  Future<void> _loadAvatar() async {
    try {
      final avatarPath = MySharedPref.getString('user_avatar_path');
      if (avatarPath != null && avatarPath.isNotEmpty) {
        if (kIsWeb) {
          // On web, load as base64 string and decode
          final avatarBytesBase64 = MySharedPref.getString('user_avatar_bytes');
          if (avatarBytesBase64 != null) {
            try {
              // Decode base64 string to bytes
              final bytes = base64Decode(avatarBytesBase64);
              avatarImage.value = bytes;
            } catch (e) {
              print('Error decoding avatar base64: $e');
            }
          }
        } else {
          // On mobile, load as File
          final file = File(avatarPath);
          if (await file.exists()) {
            avatarImage.value = file;
          }
        }
      }
    } catch (e) {
      print('Error loading avatar: $e');
    }
  }

  void logout() async {
    try {
      // Clear all user-specific data (measurements, tokens) but preserve app settings
      await MySharedPref.clearUserData();
      
      // Show success message
      Get.snackbar(
        "Success",
        "Logged out successfully. All user data cleared.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to login screen
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      // Show error message if clearing data fails
      Get.snackbar(
        "Error",
        "Failed to clear user data. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
