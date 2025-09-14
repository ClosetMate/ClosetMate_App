import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_measurements_controller.dart';

class BasicMeasurementsView extends StatelessWidget {
  BasicMeasurementsView({super.key});

  final controller = Get.find<UserMeasurementsController>();
  final _formKey = GlobalKey<FormState>();

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
          "Basic Measurements",
          style: TextStyle(
            color: ThemeColors.getPrimary(isLightTheme),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 20),
                // Logo
                // Center(
                //   child: Container(
                //     padding: EdgeInsets.all(4),
                //     child: Image.asset(
                //       Constants.logoNoBg,
                //       width: 150.w,
                //       height: 40.h,
                //       color: isLightTheme ? null : ThemeColors.getSecondary(isLightTheme),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Let's get your basic measurements",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.getPrimary(isLightTheme),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "These help us recommend the right size for you",
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeColors.getPrimary(isLightTheme).withOpacity(0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Basic Measurements
                _buildMeasurementField(
                  controller: controller.heightController,
                  label: "Height (cm)",
                  icon: Icons.height,
                  validator: (value) => value!.isEmpty ? "Enter height" : null,
                ),
                const SizedBox(height: 20),
                _buildMeasurementField(
                  controller: controller.weightController,
                  label: "Weight (kg)",
                  icon: Icons.monitor_weight,
                  validator: (value) => value!.isEmpty ? "Enter weight" : null,
                ),
                const SizedBox(height: 20),

                // Gender-specific measurements
                Obx(() {
                  if (controller.selectedGender.value == 'Male') {
                    return Column(
                      children: [
                        _buildMeasurementField(
                          controller: controller.chestController,
                          label: "Chest (cm)",
                          icon: Icons.accessibility,
                        ),
                        const SizedBox(height: 20),
                        _buildMeasurementField(
                          controller: controller.waistController,
                          label: "Waist (cm)",
                          icon: Icons.accessibility,
                        ),
                      ],
                    );
                  } else if (controller.selectedGender.value == 'Female') {
                    return Column(
                      children: [
                        _buildMeasurementField(
                          controller: controller.bustController,
                          label: "Bust (cm)",
                          icon: Icons.accessibility,
                        ),
                        const SizedBox(height: 20),
                        _buildMeasurementField(
                          controller: controller.underBustController,
                          label: "Under Bust (cm)",
                          icon: Icons.accessibility,
                        ),
                        const SizedBox(height: 20),
                        _buildMeasurementField(
                          controller: controller.lowWaistController,
                          label: "Low Waist (cm)",
                          icon: Icons.accessibility,
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),

                const Spacer(),

                // Action buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.nextToDetailedMeasurements();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: ThemeColors.getPrimary(isLightTheme),
                    ),
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 18,
                        color: ThemeColors.getSecondary(isLightTheme),
                      ),
                    ),
                  ),
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
      ),
    );
  }

  Widget _buildMeasurementField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    bool isLightTheme = Get.isDarkMode == false;
    
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: isLightTheme ? Colors.grey.shade50 : Colors.grey.shade800,
      ),
      validator: validator,
    );
  }
}
