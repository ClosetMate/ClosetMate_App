import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SignUpController extends GetxController {
  //TODO: Implement SignUpController

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void onInit() {
    super.onInit();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    update();
  }
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
    update();
  }
  void signUp() {
    if (formKey.currentState!.validate()) {
      // Perform sign-up logic here
      Get.snackbar('Success', 'Sign-up successful');
    }
  }
}
