import 'package:closet_mate/app/modules/profile/views/widgets/initial_avatar.dart';
import 'package:closet_mate/config/theme/colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                InitialAvatar(name: controller.userName,radius: 35,),
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
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to edit profile page
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.edit, size: 18, color: Colors.grey),
                                SizedBox(width: 2),
                                Text(
                                  "Edit",
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.userEmail,
                        style: TextStyle(color: Colors.grey),
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
                _buildProfileOption(Icons.settings, "Settings", () {}),
                _buildProfileOption(Icons.help_outline, "Help & Support", () {}),
                _buildProfileOption(Icons.logout, "Logout", () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: ColorConstants.appSpecificLight),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
