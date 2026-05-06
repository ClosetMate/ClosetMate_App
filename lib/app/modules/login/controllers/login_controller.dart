import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void loginWithEmail() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.length < 6) {
      Get.snackbar("Error", "Invalid email or password");
      return;
    }

    // print("Email Login: $email | $password");
    Get.snackbar("Success", "Logged in successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white);
    Get.offNamed(Routes.BASE);
  }

  void signup() {
    Get.offNamed(Routes.SIGNUP);
  }

  void loginWithPhone() {
    print("Phone login");
  }

  void loginWithGoogle() {
    print("Google login");
  }

  void loginWithFacebook() {
    print("Facebook login");
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}