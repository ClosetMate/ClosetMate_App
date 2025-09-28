import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_measurements_controller.dart';

class BasicMeasurementsView extends StatelessWidget {
  BasicMeasurementsView({super.key});

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
          child: Column(
            children: [
              // Header section
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

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Measurements
                      _buildMeasurementSlider(
                        value: controller.height,
                        label: "Height (cm)",
                        icon: Icons.height,
                        min: 120.0,
                        max: 220.0,
                        divisions: 100,
                      ),
                      const SizedBox(height: 16),
                      _buildMeasurementSlider(
                        value: controller.weight,
                        label: "Weight (kg)",
                        icon: Icons.monitor_weight,
                        min: 30.0,
                        max: 150.0,
                        divisions: 120,
                      ),
                      const SizedBox(height: 16),

                      // Gender-specific measurements
                      Obx(() {
                        if (controller.selectedGender.value == 'Male') {
                          return Column(
                            children: [
                              _buildMeasurementSlider(
                                value: controller.chest,
                                label: "Chest (cm)",
                                icon: Icons.accessibility,
                                min: 60.0,
                                max: 150.0,
                                divisions: 90,
                              ),
                              const SizedBox(height: 16),
                              _buildMeasurementSlider(
                                value: controller.waist,
                                label: "Waist (cm)",
                                icon: Icons.accessibility,
                                min: 50.0,
                                max: 150.0,
                                divisions: 100,
                              ),
                            ],
                          );
                        } else if (controller.selectedGender.value == 'Female') {
                          return Column(
                            children: [
                              _buildMeasurementSlider(
                                value: controller.bust,
                                label: "Bust (cm)",
                                icon: Icons.accessibility,
                                min: 60.0,
                                max: 150.0,
                                divisions: 90,
                              ),
                              const SizedBox(height: 16),
                              _buildMeasurementSlider(
                                value: controller.underBust,
                                label: "Under Bust (cm)",
                                icon: Icons.accessibility,
                                min: 50.0,
                                max: 140.0,
                                divisions: 90,
                              ),
                              const SizedBox(height: 16),
                              _buildMeasurementSlider(
                                value: controller.lowWaist,
                                label: "Low Waist (cm)",
                                icon: Icons.accessibility,
                                min: 50.0,
                                max: 150.0,
                                divisions: 100,
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      const SizedBox(height: 30), // Extra space before buttons
                    ],
                  ),
                ),
              ),

              // Action buttons (fixed at bottom)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.nextToDetailedMeasurements();
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
