import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:closet_mate/app/services/virtual_tryon_service.dart';
import 'package:closet_mate/config/google_cloud_config.dart';
import 'package:closet_mate/models/tryon_result.dart';
import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/modules/virtual_tryon/utils/file_helper.dart';

// Conditional imports for platform-specific code
// On mobile: io = dart:io, html = stub
// On web: io = dart:html, html = dart:html
// Note: These imports are used conditionally via file_helper.dart
// ignore: avoid_web_libraries_in_flutter
// ignore: unused_import
import 'dart:io' if (dart.library.html) 'dart:html' as io;
// Import dart:html on web, use stub for non-web platforms
// Default to stub, but use dart:html if available
import '../utils/html_stub.dart' if (dart.library.html) 'dart:html' as html;

class VirtualTryOnController extends GetxController {
  final VirtualTryOnService _tryOnService = VirtualTryOnService();
  final ImagePicker _imagePicker = ImagePicker();

  // State
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<TryOnResult?> tryOnResult = Rx<TryOnResult?>(null);
  // Use dynamic to support both File (mobile) and Uint8List (web)
  final Rx<dynamic> selectedPersonImage = Rx<dynamic>(null);
  
  // Product data
  CmProductModel? product;
  
  // Configuration - These should ideally come from app config or environment
  String? _projectId;
  String? _region;
  String? _accessToken;

  @override
  void onInit() {
    super.onInit();
    // Get product from arguments
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      product = args['product'] as CmProductModel?;
      _projectId = args['projectId'] as String? ?? GoogleCloudConfig.projectId;
      _region = args['region'] as String? ?? GoogleCloudConfig.region;
      _accessToken = args['accessToken'] as String?;
      
      // Initialize service if credentials are provided
      // Note: Service may already be initialized globally in main.dart
      if (_projectId != null && _region != null) {
        // Only initialize if not already done (service is singleton)
        // The service will use existing initialization if already set
        _tryOnService.initialize(
          projectId: _projectId!,
          region: _region!,
          serviceAccountKey: args['serviceAccountKey'] as String?,
        );
      }
    } else {
      // Use config values as fallback
      _projectId = GoogleCloudConfig.projectId;
      _region = GoogleCloudConfig.region;
    }
  }

  /// Show image picker dialog and let user choose camera or gallery
  Future<void> pickPersonImage() async {
    try {
      ImageSource? source;
      
      // Always show dialog with both options
      // On mobile browsers, camera will be available
      // On desktop web, camera option will fail gracefully and user can use gallery
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

      // Pick image
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          // On web (including mobile browsers), read bytes directly from XFile
          final Uint8List imageBytes = await pickedFile.readAsBytes();
          selectedPersonImage.value = imageBytes;
        } else {
          // On native mobile app, use File from dart:io
          final filePath = pickedFile.path;
          selectedPersonImage.value = createFileFromPath(filePath);
        }
        // Automatically start try-on process
        await generateTryOn();
      }
    } catch (e) {
      errorMessage.value = 'Error picking image: $e';
      print('Image picker error: $e');
      
      // Provide more helpful error messages
      String errorMsg = 'Failed to pick image';
      if (e.toString().contains('camera') || e.toString().contains('permission')) {
        errorMsg = 'Camera access denied. Please allow camera permission and try again.';
      } else if (e.toString().contains('cancel')) {
        // User cancelled - don't show error
        return;
      }
      
      Get.snackbar(
        'Error',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    }
  }

  /// Generate virtual try-on images
  Future<void> generateTryOn() async {
    if (selectedPersonImage.value == null) {
      errorMessage.value = 'Please select a person image first';
      Get.snackbar(
        'Error',
        'Please select a person image first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (product == null || product!.images.isEmpty) {
      errorMessage.value = 'Product information is missing';
      Get.snackbar(
        'Error',
        'Product information is missing',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      tryOnResult.value = null;

      // Get product image - API requires exactly 1 product image
      // Use the first/main product image
      if (product!.images.isEmpty) {
        errorMessage.value = 'Product has no images';
        Get.snackbar(
          'Error',
          'Product has no images available for try-on',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      // API requires exactly 1 product image, so we use the first one
      final String productImageUrl = product!.images.first;

      // Generate try-on
      final result = await _tryOnService.generateTryOn(
        personImage: selectedPersonImage.value!,
        productImages: [productImageUrl], // Send only 1 image as required by API
        sampleCount: 1, // Generate 1 image by default
        accessToken: _accessToken,
      );

      tryOnResult.value = result;

      if (!result.hasImages) {
        errorMessage.value = 'No images were generated';
        Get.snackbar(
          'Error',
          'No images were generated. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on VirtualTryOnException catch (e) {
      errorMessage.value = e.message;
      Get.snackbar(
        'Error',
        'Failed to generate try-on: ${e.message}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Unexpected error: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Retry try-on generation
  Future<void> retry() async {
    await generateTryOn();
  }

  /// Clear selected image and results
  void clear() {
    selectedPersonImage.value = null;
    tryOnResult.value = null;
    errorMessage.value = '';
  }

  /// Save try-on result images to gallery (mobile) or download (web)
  Future<void> saveToGallery() async {
    if (tryOnResult.value == null || !tryOnResult.value!.hasImages) {
      Get.snackbar(
        'Error',
        'No images to save',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      final tryOnResultData = tryOnResult.value!;
      
      if (kIsWeb) {
        // On web, download images using browser download
        for (int i = 0; i < tryOnResultData.images.length; i++) {
          final Uint8List imageBytes = tryOnResultData.images[i];
          final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          final String fileName = 'closet_mate_tryon_${timestamp}_${i + 1}.png';
          await _downloadImageOnWeb(imageBytes, fileName);
        }
        
        isLoading.value = false;
        Get.snackbar(
          'Success',
          '${tryOnResultData.images.length} image(s) downloaded',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        // On mobile, save to gallery
        final List<String> savedPaths = [];
        
        // Save each image
        for (int i = 0; i < tryOnResultData.images.length; i++) {
          final Uint8List imageBytes = tryOnResultData.images[i];
          
          // Generate filename with timestamp
          final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          final String fileName = 'closet_mate_tryon_${timestamp}_${i + 1}.png';
          
          // Save to gallery
          final saveResult = await ImageGallerySaver.saveImage(
            imageBytes,
            name: fileName,
            quality: 100,
            isReturnImagePathOfIOS: true,
          );
          
          if (saveResult['isSuccess'] == true) {
            final String? filePath = saveResult['filePath'] as String?;
            if (filePath != null) {
              savedPaths.add(filePath);
            }
          }
        }
        
        isLoading.value = false;
        
        if (savedPaths.isNotEmpty) {
          Get.snackbar(
            'Success',
            '${savedPaths.length} image(s) saved to gallery',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to save images to gallery',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to save images: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }
  

  /// Save a specific image to gallery (mobile) or download (web)
  Future<void> saveImageToGallery(Uint8List imageBytes, {int? index}) async {
    try {
      isLoading.value = true;
      
      // Generate filename with timestamp
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = index != null
          ? 'closet_mate_tryon_${timestamp}_$index.png'
          : 'closet_mate_tryon_$timestamp.png';
      
      if (kIsWeb) {
        // On web, download image
        await _downloadImageOnWeb(imageBytes, fileName);
        isLoading.value = false;
        Get.snackbar(
          'Success',
          'Image downloaded',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        // On mobile, save to gallery
        final saveResult = await ImageGallerySaver.saveImage(
          imageBytes,
          name: fileName,
          quality: 100,
          isReturnImagePathOfIOS: true,
        );
        
        isLoading.value = false;
        
        if (saveResult['isSuccess'] == true) {
          Get.snackbar(
            'Success',
            'Image saved to gallery',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to save image to gallery',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to save image: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  /// Download image on web platform using browser download
  Future<void> _downloadImageOnWeb(Uint8List imageBytes, String fileName) async {
    if (!kIsWeb) return;
    
    try {
      // Create a blob URL and trigger download
      final blob = html.Blob([imageBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName);
      anchor.click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      throw Exception('Failed to download image on web: $e');
    }
  }

  /// Go back to product details
  void goBack() {
    Get.back();
  }
}

