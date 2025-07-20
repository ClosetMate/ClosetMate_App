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
          (_) => Scaffold(
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
                    Text(
                      'Theme Mode',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.getTextPrimary(isLightTheme),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.onThemeChange(true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: isLightTheme ? ThemeColors.getTextPrimary(isLightTheme) : Colors.transparent,
                                border: Border.all(color: ThemeColors.getTextPrimary(isLightTheme)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Light',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isLightTheme ? Colors.white : ThemeColors.getTextPrimary(isLightTheme),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.onThemeChange(false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: !isLightTheme ? ThemeColors.getTextPrimary(isLightTheme) : Colors.transparent,
                                border: Border.all(color: ThemeColors.getTextPrimary(isLightTheme)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Dark',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: !isLightTheme ? Colors.white : ThemeColors.getTextPrimary(isLightTheme),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
  }
}
