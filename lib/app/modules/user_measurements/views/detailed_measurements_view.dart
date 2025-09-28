import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_measurements_controller.dart';

class DetailedMeasurementsView extends StatelessWidget {
  DetailedMeasurementsView({super.key});

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
          child: Column(
            children: [
              // Header section
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

              // Scrollable content
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

              // Action buttons (fixed at bottom)
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

        _buildMeasurementSlider(
          value: controller.hips,
          label: "Hips (cm)",
          icon: Icons.accessibility,
          min: 70.0,
          max: 150.0,
          divisions: 80,
        ),
        const SizedBox(height: 12),
        _buildMeasurementSlider(
          value: controller.inseam,
          label: "Inseam (cm)",
          icon: Icons.accessibility,
          min: 50.0,
          max: 120.0,
          divisions: 70,
        ),
        const SizedBox(height: 12),
        _buildMeasurementSlider(
          value: controller.neck,
          label: "Neck (cm)",
          icon: Icons.accessibility,
          min: 30.0,
          max: 60.0,
          divisions: 30,
        ),
        const SizedBox(height: 12),
        _buildMeasurementSlider(
          value: controller.shoulders,
          label: "Shoulders (cm)",
          icon: Icons.accessibility,
          min: 30.0,
          max: 70.0,
          divisions: 40,
        ),
        const SizedBox(height: 12),
        _buildMeasurementSlider(
          value: controller.biceps,
          label: "Biceps (cm)",
          icon: Icons.accessibility,
          min: 20.0,
          max: 60.0,
          divisions: 40,
        ),
        const SizedBox(height: 12),
        _buildMeasurementSlider(
          value: controller.wrist,
          label: "Wrist (cm)",
          icon: Icons.accessibility,
          min: 12.0,
          max: 30.0,
          divisions: 18,
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
        _buildMeasurementSlider(
          value: controller.naturalWaist,
          label: "Natural Waist (cm)",
          icon: Icons.accessibility,
          min: 50.0,
          max: 150.0,
          divisions: 100,
        ),
        const SizedBox(height: 12),
        _buildMeasurementSlider(
          value: controller.hipCircumference,
          label: "Hip Circumference (cm)",
          icon: Icons.accessibility,
          min: 70.0,
          max: 150.0,
          divisions: 80,
        ),
        const SizedBox(height: 12),
        _buildMeasurementSlider(
          value: controller.thigh,
          label: "Thigh (cm)",
          icon: Icons.accessibility,
          min: 30.0,
          max: 80.0,
          divisions: 50,
        ),
        const SizedBox(height: 12),
        _buildMeasurementSlider(
          value: controller.knee,
          label: "Knee (cm)",
          icon: Icons.accessibility,
          min: 20.0,
          max: 60.0,
          divisions: 40,
        ),
        const SizedBox(height: 12),
        _buildMeasurementSlider(
          value: controller.calf,
          label: "Calf (cm)",
          icon: Icons.accessibility,
          min: 20.0,
          max: 60.0,
          divisions: 40,
        ),
        const SizedBox(height: 12),
        _buildMeasurementSlider(
          value: controller.ankle,
          label: "Ankle (cm)",
          icon: Icons.accessibility,
          min: 15.0,
          max: 35.0,
          divisions: 20,
        ),
        const SizedBox(height: 12),
        _buildMeasurementSlider(
          value: controller.armLength,
          label: "Arm Length (cm)",
          icon: Icons.accessibility,
          min: 40.0,
          max: 80.0,
          divisions: 40,
        ),
        const SizedBox(height: 12),
        _buildMeasurementSlider(
          value: controller.shoulderToWaist,
          label: "Shoulder to Waist (cm)",
          icon: Icons.accessibility,
          min: 20.0,
          max: 60.0,
          divisions: 40,
        ),
        const SizedBox(height: 12),
        _buildMeasurementSlider(
          value: controller.waistToHip,
          label: "Waist to Hip (cm)",
          icon: Icons.accessibility,
          min: 10.0,
          max: 40.0,
          divisions: 30,
        ),
      ],
    );
  }

  Widget _buildMeasurementSlider({
    required RxDouble value,
    required String label,
    required IconData icon,
    required double min,
    required double max,
    required int divisions,
  }) {
    bool isLightTheme = Get.isDarkMode == false;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isLightTheme ? Colors.grey.shade50 : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLightTheme ? Colors.grey.shade300 : Colors.grey.shade600,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: ThemeColors.getPrimary(isLightTheme),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ThemeColors.getPrimary(isLightTheme),
                    ),
                  ),
                ],
              ),
              Obx(() => Text(
                '${value.value.toStringAsFixed(1)} cm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.getPrimary(isLightTheme),
                ),
              )),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Slider(
            value: value.value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: ThemeColors.getPrimary(isLightTheme),
            inactiveColor: ThemeColors.getPrimary(isLightTheme).withOpacity(0.3),
            onChanged: (newValue) {
              value.value = newValue;
            },
          )),
        ],
      ),
    );
  }
}
