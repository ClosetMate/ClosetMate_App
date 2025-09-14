import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:closet_mate/app/data/local/my_shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  late String userName = '';
  late String userEmail = '';
  @override
  void onInit() {
    super.onInit();
    userName = 'Vinay Varma';
    userEmail = 'vinayvarma@gmail.com';
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
