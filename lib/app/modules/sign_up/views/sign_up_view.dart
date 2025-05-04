import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('SignUpView'), centerTitle: true),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Name Field
                    TextFormField(
                      controller: controller.nameController,
                      style: TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(fontSize: 14),
                        border:
                            OutlineInputBorder(), // This is used as the default
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ), // Light border before focus
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ), // Border color on focus
                        ),
                      ),
                      validator:
                          (value) => value!.isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 16),
                    // Email Field
                    TextFormField(
                      controller: controller.emailController,
                      style: TextStyle(
                        fontSize: 14,
                      ), // Reduced input text font size
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ), // Reduced label font size
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      validator:
                          (value) =>
                              value != null && value.contains('@')
                                  ? null
                                  : 'Enter a valid email',
                    ),
                    const SizedBox(height: 16),
                    // Password Field
                    TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.obscurePassword,
                      style: TextStyle(fontSize: 14), // Reduced text font size
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ), // Reduced label font size
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            controller.togglePasswordVisibility();
                          },
                        ),
                      ),
                      validator:
                          (value) =>
                              value != null && value.length < 6
                                  ? 'Password must be at least 6 characters'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    // Confirm Password Field
                    TextFormField(
                      controller: controller.confirmPasswordController,
                      obscureText: controller.obscureConfirmPassword,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(fontSize: 14),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            controller.toggleConfirmPasswordVisibility();
                          },
                        ),
                      ),
                      validator:
                          (value) =>
                              value != controller.passwordController.text
                                  ? 'Passwords do not match'
                                  : null,
                    ),
                    const SizedBox(height: 24),

                    // Sign Up Button
                    ElevatedButton(
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          // TODO: Handle sign up logic
                          print('Signing up...');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to login screen
                          },
                          child: const Text("Log In"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
