import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_measurements_controller.dart';

class UserMeasurementsView extends StatelessWidget {
  UserMeasurementsView({super.key});

  final controller = Get.find<UserMeasurementsController>();

  @override
  Widget build(BuildContext context) {
    // Redirect to the appropriate view based on the flow
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.isUpdateMode.value) {
        // For updates from settings, go to gender selection
        Get.offNamed(Routes.GENDER_SELECTION, arguments: {'isUpdate': true});
      } else {
        // For new users from signup, go to gender selection
        Get.offNamed(Routes.GENDER_SELECTION);
      }
    });

    // Return a loading screen while redirecting
    return Scaffold(
      backgroundColor: ThemeColors.getScaffoldBackground(Get.isDarkMode == false),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}
