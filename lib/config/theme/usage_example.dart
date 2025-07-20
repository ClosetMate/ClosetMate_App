import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_colors.dart';
import 'theme_colors.dart';

/// Example showing how to use centralized colors in widgets
class ColorUsageExample extends StatelessWidget {
  const ColorUsageExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current theme state
    bool isLightTheme = Get.isDarkMode == false;
    
    return Scaffold(
      backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
      appBar: AppBar(
        title: Text('Color Usage Example'),
        backgroundColor: ThemeColors.getPrimary(isLightTheme),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Using theme-aware colors
            Text(
              'Primary Text',
              style: TextStyle(
                color: ThemeColors.getTextPrimary(isLightTheme),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 16),
            
            // Using status colors (same for both themes)
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ThemeColors.getSuccess(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Success Message',
                style: TextStyle(color: Colors.white),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Using direct app colors
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Warning Message',
                style: TextStyle(color: Colors.white),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Button with theme-aware colors
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColors.getPrimary(isLightTheme),
                foregroundColor: ThemeColors.getButtonText(isLightTheme),
              ),
              child: Text('Theme-Aware Button'),
            ),
            
            SizedBox(height: 16),
            
            // Chip with theme-aware colors
            Chip(
              label: Text(
                'Theme Chip',
                style: TextStyle(
                  color: ThemeColors.getChipText(isLightTheme),
                ),
              ),
              backgroundColor: ThemeColors.getPrimary(isLightTheme),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extension for easier color access in widgets
extension ColorExtension on BuildContext {
  bool get isLightTheme => Theme.of(this).brightness == Brightness.light;
  
  Color get primaryColor => ThemeColors.getPrimary(isLightTheme);
  Color get textColor => ThemeColors.getTextPrimary(isLightTheme);
  Color get backgroundColor => ThemeColors.getScaffoldBackground(isLightTheme);
  Color get successColor => ThemeColors.getSuccess();
  Color get errorColor => ThemeColors.getError();
  Color get warningColor => ThemeColors.getWarning();
  Color get infoColor => ThemeColors.getInfo();
} 