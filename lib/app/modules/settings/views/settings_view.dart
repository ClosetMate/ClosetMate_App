import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return 
      GetBuilder<SettingsController>(
        builder:
          (controller) => Scaffold(
          appBar: AppBar(title: Text('Settings', style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),),
          backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme), iconTheme: IconThemeData(color: ThemeColors.getTextPrimary(isLightTheme)),),
          body: Builder(
            builder: (context) {
              bool isLightTheme = Theme.of(context).brightness == Brightness.light;
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Theme Mode',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.getTextPrimary(isLightTheme),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: ThemeColors.getCardBackground(isLightTheme),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => controller.onThemeChange(true),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isLightTheme 
                                      ? ThemeColors.getButtonBackground(isLightTheme)
                                      : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.light_mode,
                                    color: isLightTheme 
                                      ? Colors.white
                                      : ThemeColors.getButtonBackground(isLightTheme),
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => controller.onThemeChange(false),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: !isLightTheme 
                                      ? ThemeColors.getPrimary(isLightTheme)
                                      : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.dark_mode,
                                    color: !isLightTheme 
                                      ? Colors.white
                                      : ThemeColors.getTextSecondary(isLightTheme),
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.getTextPrimary(isLightTheme),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingsCard(
                      title: 'Update Measurements',
                      subtitle: 'Change your body measurements for better fit recommendations',
                      icon: Icons.accessibility,
                      onTap: () => controller.navigateToMeasurements(),
                      isLightTheme: isLightTheme,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
  }

  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required bool isLightTheme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: ThemeColors.getCardBackground(isLightTheme),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ThemeColors.getTextPrimary(isLightTheme).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: ThemeColors.getTextPrimary(isLightTheme),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.getTextPrimary(isLightTheme),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeColors.getTextSecondary(isLightTheme),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: ThemeColors.getTextSecondary(isLightTheme),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
