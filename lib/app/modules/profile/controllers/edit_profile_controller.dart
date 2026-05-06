import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:closet_mate/app/data/local/my_shared_pref.dart';
import 'package:closet_mate/app/modules/profile/controllers/profile_controller.dart';
import 'package:closet_mate/app/modules/profile/views/crop_image_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  // Avatar state - can be File (mobile) or Uint8List (web) or String (path)
  final Rx<dynamic> avatarImage = Rx<dynamic>(null);
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize with current profile data
    nameController.text = profileController.userName;
    emailController.text = profileController.userEmail;
    
    // Load saved avatar if exists
    _loadAvatar();
  }
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
  
  /// Load avatar from storage
  Future<void> _loadAvatar() async {
    try {
      final avatarPath = MySharedPref.getString('user_avatar_path');
      if (avatarPath != null && avatarPath.isNotEmpty) {
        if (kIsWeb) {
          // On web, load as base64 string and decode
          final avatarBytesBase64 = MySharedPref.getString('user_avatar_bytes');
          if (avatarBytesBase64 != null) {
            try {
              // Decode base64 string to bytes
              final bytes = base64Decode(avatarBytesBase64);
              avatarImage.value = bytes;
            } catch (e) {
              print('Error decoding avatar base64: $e');
            }
          }
        } else {
          // On mobile, load as File
          final file = File(avatarPath);
          if (await file.exists()) {
            avatarImage.value = file;
          }
        }
      }
    } catch (e) {
      print('Error loading avatar: $e');
    }
  }
  
  /// Crop the selected image using extended_image
  Future<void> _cropImage(XFile pickedFile) async {
    try {
      // Prepare image source for crop screen
      dynamic imageSource;
      if (kIsWeb) {
        // On web, read bytes directly
        imageSource = await pickedFile.readAsBytes();
      } else {
        // On mobile, use File
        imageSource = File(pickedFile.path);
      }

      // Navigate to crop screen
      final croppedResult = await Get.to<dynamic>(
        () => CropImageView(imageSource: imageSource),
      );

      if (croppedResult != null) {
        // Set cropped image
        avatarImage.value = croppedResult;
      } else {
        // User cancelled cropping, use original image
        if (kIsWeb) {
          final Uint8List imageBytes = await pickedFile.readAsBytes();
          avatarImage.value = imageBytes;
        } else {
          avatarImage.value = File(pickedFile.path);
        }
      }
    } catch (e) {
      // If cropping fails, use the original image
      try {
        if (kIsWeb) {
          final Uint8List imageBytes = await pickedFile.readAsBytes();
          avatarImage.value = imageBytes;
        } else {
          avatarImage.value = File(pickedFile.path);
        }
      } catch (readError) {
        Get.snackbar(
          'Error',
          'Failed to process image: $readError',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      // Show error message only if it's not a cancellation
      final errorString = e.toString().toLowerCase();
      if (!errorString.contains('cancel') && !errorString.contains('cancelled')) {
        Get.snackbar(
          'Warning',
          'Image cropping failed, using original image',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }
  }

  /// Show image picker dialog and let user choose camera or gallery
  Future<void> pickAvatarImage() async {
    try {
      ImageSource? source;
      
      source = await Get.dialog<ImageSource>(
        AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Crop the image after picking
        await _cropImage(pickedFile);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  /// Save profile updates
  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    isLoading.value = true;
    
    try {
      // Update profile controller
      profileController.userName = nameController.text.trim();
      profileController.userEmail = emailController.text.trim();
      
      // Save to SharedPreferences
      await MySharedPref.setString('user_name', profileController.userName);
      await MySharedPref.setString('user_email', profileController.userEmail);
      
      // Save avatar
      if (avatarImage.value != null) {
        if (kIsWeb) {
          // On web, save as base64 string
          if (avatarImage.value is Uint8List) {
            final bytes = avatarImage.value as Uint8List;
            // Convert bytes to base64 for storage
            final base64String = base64Encode(bytes);
            await MySharedPref.setString('user_avatar_bytes', base64String);
            await MySharedPref.setString('user_avatar_path', 'web_avatar');
            // Also update profile controller avatar
            profileController.avatarImage.value = bytes;
          }
        } else {
          // On mobile, save file path
          if (avatarImage.value is File) {
            final file = avatarImage.value as File;
            await MySharedPref.setString('user_avatar_path', file.path);
            // Also update profile controller avatar
            profileController.avatarImage.value = file;
          }
        }
      }
      
      // Update profile controller
      profileController.update();
      
      Get.back();
      
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
