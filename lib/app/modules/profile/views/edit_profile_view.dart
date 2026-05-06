import 'dart:io';
import 'dart:typed_data';
import 'package:closet_mate/app/modules/profile/views/widgets/initial_avatar.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
        ),
        backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
        iconTheme: IconThemeData(color: ThemeColors.getTextPrimary(isLightTheme)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              
              // Avatar Section
              Obx(() => GestureDetector(
                onTap: controller.pickAvatarImage,
                child: Stack(
                  children: [
                    if (controller.avatarImage.value != null)
                      CircleAvatar(
                        radius: 60.r,
                        backgroundColor: ThemeColors.getCardBackground(isLightTheme),
                        backgroundImage: kIsWeb
                            ? (controller.avatarImage.value is Uint8List
                                ? MemoryImage(controller.avatarImage.value as Uint8List)
                                : null)
                            : (controller.avatarImage.value is File
                                ? FileImage(controller.avatarImage.value as File)
                                : null),
                        child: controller.avatarImage.value == null
                            ? InitialAvatar(
                                name: controller.nameController.text,
                                radius: 60.r,
                              )
                            : null,
                      )
                    else
                      InitialAvatar(
                        name: controller.nameController.text,
                        radius: 60.r,
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: ThemeColors.getPrimary(isLightTheme),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ThemeColors.getScaffoldBackground(isLightTheme),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: ThemeColors.getTextPrimary(isLightTheme),
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              
              SizedBox(height: 8.h),
              Text(
                'Tap to change avatar',
                style: TextStyle(
                  color: ThemeColors.getTextSecondary(isLightTheme),
                  fontSize: 12.sp,
                ),
              ),
              
              SizedBox(height: 40.h),
              
              // Name Field
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: 'User Name',
                  labelStyle: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: ThemeColors.getTextPrimary(isLightTheme),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: ThemeColors.getTextSecondary(isLightTheme).withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: ThemeColors.getPrimary(isLightTheme),
                      width: 2,
                    ),
                  ),
                ),
                style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 20.h),
              
              // Email Field
              TextFormField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: ThemeColors.getTextPrimary(isLightTheme),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: ThemeColors.getTextSecondary(isLightTheme).withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: ThemeColors.getPrimary(isLightTheme),
                      width: 2,
                    ),
                  ),
                ),
                style: TextStyle(color: ThemeColors.getTextPrimary(isLightTheme)),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!GetUtils.isEmail(value.trim())) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 40.h),
              
              // Save Button
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    backgroundColor: ThemeColors.getButtonBackground(isLightTheme),
                    disabledBackgroundColor: ThemeColors.getPrimary(isLightTheme).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.getButtonText(isLightTheme),
                          ),
                        ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
