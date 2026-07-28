import 'dart:io';
import 'dart:typed_data';
import 'package:closet_mate/app/modules/profile/views/widgets/initial_avatar.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:closet_mate/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    final backgroundColor = isLightTheme ? const Color(0xFFF8FAFB) : ThemeColors.getBackground(isLightTheme);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      Get.toNamed('/settings');
                    },
                    color: ThemeColors.getTextPrimary(isLightTheme),
                  ),
                ],
              ),
            ),

            // Profile Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ThemeColors.getCardBackground(isLightTheme),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Obx(() {
                      Widget avatarContent;
                      if (controller.avatarImage.value != null) {
                        if (kIsWeb && controller.avatarImage.value is Uint8List) {
                          avatarContent = Image.memory(
                            controller.avatarImage.value as Uint8List, 
                            fit: BoxFit.cover
                          );
                        } else if (!kIsWeb && controller.avatarImage.value is File) {
                          avatarContent = Image.file(
                            controller.avatarImage.value as File, 
                            fit: BoxFit.cover
                          );
                        } else {
                          avatarContent = InitialAvatar(name: controller.userName, radius: 44);
                        }
                      } else {
                        avatarContent = InitialAvatar(name: controller.userName, radius: 44);
                      }
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(48),
                        child: avatarContent,
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.userName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.getTextPrimary(isLightTheme),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeColors.getTextSecondary(isLightTheme),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Menu List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.straighten_outlined,
                    label: 'My Measurements',
                    value: '',
                    onTap: () {
                      Get.toNamed(Routes.USER_MEASUREMENTS, arguments: {'isUpdate': true});
                    },
                    isLightTheme: isLightTheme,
                  ),
                  _buildMenuItem(
                    icon: Icons.shopping_bag_outlined,
                    label: 'My Orders',
                    value: '',
                    onTap: () {
                      Get.toNamed(Routes.ORDERS);
                    },
                    isLightTheme: isLightTheme,
                  ),
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    label: 'Shipping Address',
                    value: '',
                    onTap: () {
                      Get.toNamed(Routes.SHIPPING_ADDRESSES);
                    },
                    isLightTheme: isLightTheme,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: InkWell(
                onTap: controller.logout,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(isLightTheme ? 0.05 : 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    required bool isLightTheme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ThemeColors.getCardBackground(isLightTheme),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (isLightTheme)
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isLightTheme ? Colors.grey.shade100 : Colors.white12,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: ThemeColors.getTextPrimary(isLightTheme),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.getTextPrimary(isLightTheme),
                      ),
                    ),
                    if (value.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeColors.getTextSecondary(isLightTheme),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: ThemeColors.getTextSecondary(isLightTheme).withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
