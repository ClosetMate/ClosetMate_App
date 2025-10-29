import 'package:closet_mate/app/modules/profile/views/widgets/initial_avatar.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
    @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeColors.getCardBackground(isLightTheme),
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                InitialAvatar(name: controller.userName, radius: 35),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              controller.userName,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ThemeColors.getTextPrimary(isLightTheme)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to edit profile page
                            },
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18, color: ThemeColors.getTextPrimary(isLightTheme)),
                                SizedBox(width: 2),
                                Text(
                                  "Edit",
                                  style: TextStyle(fontSize: 14, color: ThemeColors.getTextPrimary(isLightTheme)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.userEmail,
                        style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildProfileOption(Icons.shopping_bag, "My Orders", () {}),
                _buildProfileOption(Icons.location_on, "Shipping Address", () {}),
                _buildProfileOption(Icons.settings, "Settings", () {
                  Get.toNamed('/settings');
                }),
                _buildProfileOption(Icons.help_outline, "Help & Support", () {}),
                _buildProfileOption(Icons.palette, "Color Theme Controller", () {
                  Get.toNamed('/color-theme-controller');
                }),
                _buildProfileOption(Icons.logout, "Logout", controller.logout),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    bool isLightTheme = Get.isDarkMode == false;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: ThemeColors.getCardBackground(isLightTheme),
      child: ListTile(
        leading: Icon(icon, color: ThemeColors.getTextPrimary(isLightTheme)),
        title: Text(title, style: TextStyle(fontSize: 18, color: ThemeColors.getTextPrimary(isLightTheme))),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
