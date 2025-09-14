import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_measurements_controller.dart';

class DetailedMeasurementsView extends StatelessWidget {
  DetailedMeasurementsView({super.key});

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
          "Detailed Measurements",
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
                // // Logo
                // Center(
                //   child: Container(
                //     padding: EdgeInsets.all(4),
                //     child: Image.asset(
                //       Constants.logoNoBg,
                //       width: 150.w,
                //       height: 60.h,
                //       color: isLightTheme ? null : ThemeColors.getSecondary(isLightTheme),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Fine-tune your measurements",
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
                    "More precise measurements = better recommendations",
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeColors.getPrimary(isLightTheme).withOpacity(0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Gender-specific measurements
                Expanded(
                  child: SingleChildScrollView(
                    child: Obx(() {
                      if (controller.isMale) {
                        return _buildMaleMeasurements();
                      } else if (controller.isFemale) {
                        return _buildFemaleMeasurements();
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                  ),
                ),

                const SizedBox(height: 20),

                // Action buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.saveMeasurements,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: ThemeColors.getPrimary(isLightTheme),
                    ),
                    child: Obx(() => Text(
                      controller.isUpdateMode.value ? "Update Measurements" : "Save Measurements",
                      style: TextStyle(
                        fontSize: 18,
                        color: ThemeColors.getSecondary(isLightTheme),
                      ),
                    )),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  // Only show skip/cancel button if not in update mode
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

  Widget _buildMaleMeasurements() {
    bool isLightTheme = Get.isDarkMode == false;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Male Measurements",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ThemeColors.getPrimary(isLightTheme),
          ),
        ),
        const SizedBox(height: 20),

        _buildMeasurementField(
          controller: controller.hipsController,
          label: "Hips (cm)",
          icon: Icons.accessibility,
        ),
        const SizedBox(height: 16),
        _buildMeasurementField(
          controller: controller.inseamController,
          label: "Inseam (cm)",
          icon: Icons.accessibility,
        ),
        const SizedBox(height: 16),
        _buildMeasurementField(
          controller: controller.neckController,
          label: "Neck (cm)",
          icon: Icons.accessibility,
        ),
        const SizedBox(height: 16),
        _buildMeasurementField(
          controller: controller.shouldersController,
          label: "Shoulders (cm)",
          icon: Icons.accessibility,
        ),
        const SizedBox(height: 16),
        _buildMeasurementField(
          controller: controller.bicepsController,
          label: "Biceps (cm)",
          icon: Icons.accessibility,
        ),
        const SizedBox(height: 16),
        _buildMeasurementField(
          controller: controller.wristController,
          label: "Wrist (cm)",
          icon: Icons.accessibility,
        ),
      ],
    );
  }

  Widget _buildFemaleMeasurements() {
    bool isLightTheme = Get.isDarkMode == false;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Female Measurements",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ThemeColors.getPrimary(isLightTheme),
          ),
        ),
        const SizedBox(height: 20),
        _buildMeasurementField(
          controller: controller.naturalWaistController,
          label: "Natural Waist (cm)",
          icon: Icons.accessibility,
        ),
        const SizedBox(height: 16),
        _buildMeasurementField(
          controller: controller.hipCircumferenceController,
          label: "Hip Circumference (cm)",
          icon: Icons.accessibility,
        ),
        const SizedBox(height: 16),
        _buildMeasurementField(
          controller: controller.thighController,
          label: "Thigh (cm)",
          icon: Icons.accessibility,
        ),
        const SizedBox(height: 16),
        _buildMeasurementField(
          controller: controller.kneeController,
          label: "Knee (cm)",
          icon: Icons.accessibility,
        ),
        const SizedBox(height: 16),
        _buildMeasurementField(
          controller: controller.calfController,
          label: "Calf (cm)",
          icon: Icons.accessibility,
        ),
        const SizedBox(height: 16),
        _buildMeasurementField(
          controller: controller.ankleController,
          label: "Ankle (cm)",
          icon: Icons.accessibility,
        ),
        const SizedBox(height: 16),
        _buildMeasurementField(
          controller: controller.armLengthController,
          label: "Arm Length (cm)",
          icon: Icons.accessibility,
        ),
        const SizedBox(height: 16),
        _buildMeasurementField(
          controller: controller.shoulderToWaistController,
          label: "Shoulder to Waist (cm)",
          icon: Icons.accessibility,
        ),
        const SizedBox(height: 16),
        _buildMeasurementField(
          controller: controller.waistToHipController,
          label: "Waist to Hip (cm)",
          icon: Icons.accessibility,
        ),
      ],
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
