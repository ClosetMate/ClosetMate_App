import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:closet_mate/app/components/custom_button.dart';
import '../controllers/virtual_tryon_controller.dart';
import '../utils/file_helper.dart';

// Conditional import for File (only on non-web)
// ignore: unused_import
import 'dart:io' if (dart.library.html) 'dart:html' as io;

class VirtualTryOnView extends GetView<VirtualTryOnController> {
  const VirtualTryOnView({super.key});

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
            Icons.arrow_back_ios_new_rounded,
            color: ThemeColors.getTextPrimary(isLightTheme),
          ),
          onPressed: () => controller.goBack(),
        ),
        title: Text(
          'Virtual Try-On',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(isLightTheme),
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: ThemeColors.getPrimary(isLightTheme),
                ),
                20.verticalSpace,
                Text(
                  'Generating your virtual try-on...',
                  style: TextStyle(
                    color: ThemeColors.getTextSecondary(isLightTheme),
                    fontSize: 16.sp,
                  ),
                ),
                10.verticalSpace,
                Text(
                  'This may take a few moments',
                  style: TextStyle(
                    color: ThemeColors.getTextHint(isLightTheme),
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          );
        }

        // Error state
        if (controller.errorMessage.value.isNotEmpty && controller.tryOnResult.value == null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: ThemeColors.getError(),
                  ),
                  20.verticalSpace,
                  Text(
                    'Error',
                    style: TextStyle(
                      color: ThemeColors.getTextPrimary(isLightTheme),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ThemeColors.getTextSecondary(isLightTheme),
                      fontSize: 16.sp,
                    ),
                  ),
                  30.verticalSpace,
                  CustomButton(
                    text: 'Retry',
                    onPressed: controller.retry,
                    backgroundColor: ThemeColors.getButtonBackground(isLightTheme),
                    foregroundColor: ThemeColors.getButtonText(isLightTheme),
                    fontSize: 16.sp,
                    radius: 12.r,
                    verticalPadding: 12.h,
                  ),
                  20.verticalSpace,
                  CustomButton(
                    text: 'Select Different Image',
                    onPressed: controller.pickPersonImage,
                    backgroundColor: ThemeColors.getCardBackground(isLightTheme),
                    foregroundColor: ThemeColors.getTextPrimary(isLightTheme),
                    fontSize: 16.sp,
                    radius: 12.r,
                    verticalPadding: 12.h,
                    borderColor: ThemeColors.getPrimary(isLightTheme),
                  ),
                ],
              ),
            ),
          );
        }

        // No image selected state
        if (controller.selectedPersonImage.value == null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 80.sp,
                    color: ThemeColors.getPrimary(isLightTheme),
                  ),
                  30.verticalSpace,
                  Text(
                    'Select Your Photo',
                    style: TextStyle(
                      color: ThemeColors.getTextPrimary(isLightTheme),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    'Choose a photo of yourself to see how this product looks on you',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ThemeColors.getTextSecondary(isLightTheme),
                      fontSize: 16.sp,
                    ),
                  ),
                  40.verticalSpace,
                  CustomButton(
                    text: 'Select Photo',
                    onPressed: controller.pickPersonImage,
                    backgroundColor: ThemeColors.getButtonBackground(isLightTheme),
                    foregroundColor: ThemeColors.getButtonText(isLightTheme),
                    fontSize: 18.sp,
                    radius: 12.r,
                    verticalPadding: 16.h,
                    icon: Icon(
                      Icons.camera_alt,
                      color: ThemeColors.getButtonText(isLightTheme),
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Results state
        if (controller.tryOnResult.value != null && controller.tryOnResult.value!.hasImages) {
          return _buildResultsView(isLightTheme);
        }

        // Default state (image selected but not processed)
        return _buildImageSelectedView(isLightTheme);
      }),
    );
  }

  Widget _buildImageSelectedView(bool isLightTheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Selected person image preview
          Container(
            height: 300.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: ThemeColors.getPrimary(isLightTheme).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: _buildImagePreview(controller.selectedPersonImage.value!),
            ),
          ),
          30.verticalSpace,
          Text(
            'Ready to Try On',
            style: TextStyle(
              color: ThemeColors.getTextPrimary(isLightTheme),
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
          Text(
            'Tap the button below to generate your virtual try-on',
            style: TextStyle(
              color: ThemeColors.getTextSecondary(isLightTheme),
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
          40.verticalSpace,
          CustomButton(
            text: 'Generate Try-On',
            onPressed: controller.generateTryOn,
            backgroundColor: ThemeColors.getButtonBackground(isLightTheme),
            foregroundColor: ThemeColors.getButtonText(isLightTheme),
            fontSize: 18.sp,
            radius: 12.r,
            verticalPadding: 16.h,
          ),
          20.verticalSpace,
          CustomButton(
            text: 'Change Photo',
            onPressed: controller.pickPersonImage,
            backgroundColor: ThemeColors.getCardBackground(isLightTheme),
            foregroundColor: ThemeColors.getTextPrimary(isLightTheme),
            fontSize: 16.sp,
            radius: 12.r,
            verticalPadding: 12.h,
            borderColor: ThemeColors.getPrimary(isLightTheme),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(bool isLightTheme) {
    final result = controller.tryOnResult.value!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Results title
          Text(
            'Your Virtual Try-On',
            style: TextStyle(
              color: ThemeColors.getTextPrimary(isLightTheme),
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          20.verticalSpace,
          
          // Result images gallery
          ...result.images.asMap().entries.map((entry) {
            final int index = entry.key;
            final imageBytes = entry.value;
            
            return Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.memory(
                        imageBytes,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  // Individual save button for each image (Download on web, Save on mobile)
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: kIsWeb ? 'Download Image ${index + 1}' : 'Save Image ${index + 1}',
                      onPressed: () => controller.saveImageToGallery(imageBytes, index: index),
                      backgroundColor: ThemeColors.getButtonBackground(isLightTheme),
                      foregroundColor: ThemeColors.getButtonText(isLightTheme),
                      fontSize: 14.sp,
                      radius: 10.r,
                      verticalPadding: 10.h,
                      icon: Icon(
                        Icons.download,
                        color: ThemeColors.getButtonText(isLightTheme),
                        size: 18.sp,
                      ),
                      borderColor: ThemeColors.getButtonBackground(isLightTheme),
                    ),
                  ),
                ],
              ),
            );
          }),
          
          30.verticalSpace,
          
          // Save all button (Download on web, Save to Gallery on mobile)
          CustomButton(
            text: kIsWeb ? 'Download All Images' : 'Save All to Gallery',
            onPressed: controller.saveToGallery,
            backgroundColor: ThemeColors.getButtonBackground(isLightTheme),
            foregroundColor: ThemeColors.getButtonText(isLightTheme),
            fontSize: 16.sp,
            radius: 12.r,
            verticalPadding: 12.h,
            icon: Icon(
              Icons.download,
              color: ThemeColors.getButtonText(isLightTheme),
              size: 20.sp,
            ),
          ),
          20.verticalSpace,
          
          // Action buttons
          CustomButton(
            text: 'Try Another Photo',
            onPressed: () {
              controller.clear();
              controller.pickPersonImage();
            },
            backgroundColor: ThemeColors.getButtonBackground(isLightTheme),
            foregroundColor: ThemeColors.getButtonText(isLightTheme),
            fontSize: 16.sp,
            radius: 12.r,
            verticalPadding: 12.h,
          ),
          20.verticalSpace,
          CustomButton(
            text: 'Back to Product',
            onPressed: controller.goBack,
            backgroundColor: ThemeColors.getCardBackground(isLightTheme),
            foregroundColor: ThemeColors.getTextPrimary(isLightTheme),
            fontSize: 16.sp,
            radius: 12.r,
            verticalPadding: 12.h,
            borderColor: ThemeColors.getPrimary(isLightTheme),
          ),
        ],
      ),
    );
  }

  /// Build image preview widget that works on both web and mobile
  Widget _buildImagePreview(dynamic imageData) {
    if (kIsWeb) {
      // On web, imageData is Uint8List
      if (imageData is Uint8List) {
        return Image.memory(
          imageData,
          fit: BoxFit.cover,
        );
      }
    } else {
      // On mobile, imageData is File from dart:io
      // Use dynamic access to avoid type conflicts with web File type
      if (imageData != null && !kIsWeb) {
        try {
          // Access path property dynamically
          final path = (imageData as dynamic).path;
          if (path is String) {
            // Create File object using platform-specific helper
            final file = createFileFromPath(path);
            if (file != null) {
              return Image.file(
                file,
                fit: BoxFit.cover,
              );
            }
          }
        } catch (e) {
          // Fallback if access fails
        }
      }
    }
    
    // Fallback
    return Container(
      color: Colors.grey[300],
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
        size: 50,
      ),
    );
  }
}

