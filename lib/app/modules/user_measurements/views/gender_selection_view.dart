import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:closet_mate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/user_measurements_controller.dart';

class GenderSelectionView extends StatelessWidget {
  GenderSelectionView({super.key});

  final controller = Get.find<UserMeasurementsController>();

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Get.isDarkMode == false;
    
    return Scaffold(
      backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
      appBar: AppBar(
        backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ThemeColors.getPrimary(isLightTheme),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Gender Selection",
          style: TextStyle(
            color: ThemeColors.getPrimary(isLightTheme),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Logo and welcome text
              Center(
                child: Container(
                  padding: EdgeInsets.all(4),
                  child: Image.asset(
                    Constants.logoNoBg,
                    width: 200.w,
                    height: 80.h,
                    color: isLightTheme ? null : ThemeColors.getSecondary(isLightTheme),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Let's get to know you better!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ThemeColors.getPrimary(isLightTheme),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "Select your gender to personalize your experience",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeColors.getPrimary(isLightTheme).withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Gender Selection
              Text(
                "Select your gender:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ThemeColors.getPrimary(isLightTheme),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildGenderCard(
                      'Male',
                      Icons.male,
                      Colors.blue,
                      controller.selectedGender.value == 'Male',
                      () => controller.selectGender('Male'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGenderCard(
                      'Female',
                      Icons.female,
                      Colors.pink,
                      controller.selectedGender.value == 'Female',
                      () => controller.selectGender('Female'),
                    ),
                  ),
                ],
              )),

              const Spacer(),

              // Action buttons
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.selectedGender.value.isNotEmpty 
                      ? controller.nextToBasicMeasurements 
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: controller.selectedGender.value.isNotEmpty 
                        ? ThemeColors.getPrimary(isLightTheme)
                        : Colors.grey,
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 18,
                      color: controller.selectedGender.value.isNotEmpty 
                          ? ThemeColors.getSecondary(isLightTheme)
                          : Colors.white,
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 16),
              Obx(() {
                // Only show skip button if not in update mode
                if (controller.isUpdateMode.value) {
                  return const SizedBox.shrink();
                }
                return SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: controller.skipMeasurements,
                    child: Text(
                      "Skip for now",
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeColors.getPrimary(isLightTheme),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard(String gender, IconData icon, Color color, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 50,
              color: isSelected ? color : Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              gender,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
