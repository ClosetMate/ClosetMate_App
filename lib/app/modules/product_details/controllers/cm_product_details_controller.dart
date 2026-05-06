import 'dart:typed_data';
import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/services/products_service.dart';
import 'package:closet_mate/app/services/virtual_tryon_service.dart';
import 'package:closet_mate/app/services/tryon_storage_service.dart';
import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:closet_mate/config/google_cloud_config.dart';
import 'package:closet_mate/app/modules/virtual_tryon/utils/file_helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CmProductDetailsController extends GetxController {
  final ProductsService _productsService = ProductsService();
  final VirtualTryOnService _tryOnService = VirtualTryOnService();
  final TryOnStorageService _tryOnStorage = TryOnStorageService();
  final ImagePicker _imagePicker = ImagePicker();
  
  // Product data
  final Rx<CmProductModel?> product = Rx<CmProductModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  
  // UI state
  PageController pageController = PageController();
  final RxString selectedSize = ''.obs;
  final RxString selectedColor = ''.obs;
  final RxInt selectedQuantity = 1.obs;
  final RxInt currentPageIndex = 0.obs;
  
  // Try-on results storage - list of try-on result images (prepended to original images)
  final RxList<Uint8List> tryOnResultImages = <Uint8List>[].obs;
  // Track unique IDs for each try-on result (index-based mapping)
  final RxMap<int, String> tryOnResultIds = <int, String>{}.obs;
  final RxBool isTryOnLoading = false.obs;
  // Track saved status per try-on result index
  final RxMap<int, bool> savedTryOnStatus = <int, bool>{}.obs;
  // Flag to track if try-on generation should be cancelled
  bool _isTryOnCancelled = false;
  
  // Reactive trigger to notify GetX when try-on results change
  final RxInt _tryOnUpdateTrigger = 0.obs;
  
  // Get product ID from arguments
  String get productId => Get.arguments as String;

  @override
  void onInit() {
    super.onInit();
    _initializeTryOnService();
    _loadProductDetails().then((_) {
      // Load saved status after product is loaded
      _loadSavedStatus();
    });
  }
  
  Future<void> _loadSavedStatus() async {
    if (product.value == null) return;
    
    try {
      // Load all saved try-on IDs for this product
      final savedTryOnIds = await _tryOnStorage.getSavedTryOnIdsForProduct(product.value!.id);
      
      // Load each saved try-on image
      for (final tryOnId in savedTryOnIds) {
        final savedImage = await _tryOnStorage.getTryOnImageById(tryOnId);
        if (savedImage != null) {
          final index = tryOnResultImages.length;
          tryOnResultImages.add(savedImage);
          tryOnResultIds[index] = tryOnId;
          savedTryOnStatus[index] = true;
        }
      }
      
      if (savedTryOnIds.isNotEmpty) {
        _tryOnUpdateTrigger.value++;
      }
    } catch (e) {
      print('Error loading saved try-on images: $e');
    }
  }
  
  Future<void> _initializeTryOnService() async {
    try {
      await _tryOnService.initialize(
        projectId: GoogleCloudConfig.projectId,
        region: GoogleCloudConfig.region,
      );
    } catch (e) {
      print('Error initializing try-on service: $e');
    }
  }

  Future<void> _loadProductDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final productData = await _productsService.getProductById(productId);
      
      if (productData != null) {
        product.value = productData;
        // Set default selections
        if (productData.variants.isNotEmpty) {
          selectedColor.value = productData.variants.first.color;
          selectedSize.value = productData.variants.first.size;
        }
        // Saved try-ons are loaded in _loadSavedStatus() after product is set
      } else {
        errorMessage.value = 'Product not found';
      }
      
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error loading product details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get available sizes for selected color
  List<String> get availableSizes {
    if (product.value == null) return [];
    return product.value!.variants
        .where((variant) => variant.color == selectedColor.value)
        .map((variant) => variant.size)
        .toList();
  }

  // Get available colors
  List<String> get availableColors {
    if (product.value == null) return [];
    return product.value!.variants
        .map((variant) => variant.color)
        .toSet()
        .toList();
  }

  // Get stock for selected variant
  int get selectedVariantStock {
    if (product.value == null) return 0;
    final variant = product.value!.variants.firstWhere(
      (v) => v.color == selectedColor.value && v.size == selectedSize.value,
      orElse: () => ProductVariant(color: '', size: '', sku: '', stock: 0),
    );
    return variant.stock;
  }

  // Check if selected variant is available
  bool get isVariantAvailable {
    return selectedVariantStock > 0;
  }

  // Change selected color
  void changeSelectedColor(String color) {
    if (color == selectedColor.value) return;
    selectedColor.value = color;
    
    // Reset size if not available for new color
    if (!availableSizes.contains(selectedSize.value)) {
      selectedSize.value = availableSizes.isNotEmpty ? availableSizes.first : '';
    }
  }

  // Change selected size
  void changeSelectedSize(String size) {
    if (size == selectedSize.value) return;
    selectedSize.value = size;
  }

  // Change quantity
  void changeQuantity(int quantity) {
    if (quantity < 1) return;
    if (quantity > selectedVariantStock) return;
    selectedQuantity.value = quantity;
  }

  // Toggle favorite
  void toggleFavorite() {
    // TODO: Implement favorite functionality
    // This would typically update a favorites service or local storage
  }

  // Add to cart
  void addToCart() {
    if (!isVariantAvailable) {
      Get.snackbar(
        'Out of Stock',
        'This variant is currently out of stock',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // TODO: Implement add to cart functionality
    Get.snackbar(
      'Added to Cart',
      '${product.value?.name} (${selectedColor.value}, ${selectedSize.value}) added to cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Refresh product details
  Future<void> refreshProduct() async {
    await _loadProductDetails();
  }

  /// Navigate to virtual try-on page
  /// 
  /// Uses GoogleCloudConfig values by default. You can override them if needed.
  /// [projectId] - Google Cloud project ID (optional, defaults to config)
  /// [region] - Google Cloud region (optional, defaults to config)
  /// [accessToken] - Access token for API authentication (optional)
  /// [serviceAccountKey] - Service account key JSON string (optional)
  void navigateToTryOn({
    String? projectId,
    String? region,
    String? accessToken,
    String? serviceAccountKey,
  }) {
    if (product.value == null) {
      Get.snackbar(
        'Error',
        'Product information is not available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Use config values as defaults
    Get.toNamed(
      Routes.VIRTUAL_TRYON,
      arguments: {
        'product': product.value,
        'projectId': projectId ?? GoogleCloudConfig.projectId,
        'region': region ?? GoogleCloudConfig.region,
        if (accessToken != null) 'accessToken': accessToken,
        if (serviceAccountKey != null) 'serviceAccountKey': serviceAccountKey,
      },
    );
  }

  /// Show image picker dialog and generate try-on inline
  Future<void> generateTryOn() async {
    if (product.value == null || product.value!.images.isEmpty) {
      Get.snackbar(
        'Error',
        'Product information is not available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Show image picker dialog
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

    try {
      // Pick image
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      // Convert to appropriate format
      dynamic personImage;
      if (kIsWeb) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        personImage = imageBytes;
      } else {
        final filePath = pickedFile.path;
        personImage = createFileFromPath(filePath);
      }

      // Get current product image (from current slide)
      final currentImageIndex = currentPageIndex.value;
      
      // If current index is a try-on result, we need to use the first original product image
      // Otherwise use the current product image
      String productImageUrl;
      if (isTryOnResult(currentImageIndex)) {
        // Use first original product image
        productImageUrl = product.value!.images[0];
      } else {
        // Get the original index
        final originalIndex = currentImageIndex - tryOnResultImages.length;
        if (originalIndex >= 0 && originalIndex < product.value!.images.length) {
          productImageUrl = product.value!.images[originalIndex];
        } else {
          productImageUrl = product.value!.images[0];
        }
      }

      // Reset cancellation flag
      _isTryOnCancelled = false;
      
      // Set loading state
      isTryOnLoading.value = true;

      // Generate try-on
      final result = await _tryOnService.generateTryOn(
        personImage: personImage,
        productImages: [productImageUrl],
        sampleCount: 1,
      );

      // Check if process was cancelled
      if (_isTryOnCancelled) {
        return;
      }

      // Add result to first position
      if (result.hasImages && result.images.isNotEmpty) {
        await addTryOnResult(result.images.first);
        
        // Check again if cancelled after adding result
        if (_isTryOnCancelled) {
          return;
        }
        
        Get.snackbar(
          'Success',
          'Try-on image generated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        // Check if cancelled before showing error
        if (_isTryOnCancelled) {
          return;
        }
        
        Get.snackbar(
          'Error',
          'No images were generated. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // Check if cancelled before showing error
      if (_isTryOnCancelled) {
        return;
      }
      
      String errorMsg = 'Failed to generate try-on';
      if (e.toString().contains('camera') || e.toString().contains('permission')) {
        errorMsg = 'Camera access denied. Please allow camera permission and try again.';
      } else if (e.toString().contains('cancel')) {
        // User cancelled - don't show error
        return;
      } else {
        errorMsg = 'Unexpected error: $e';
      }
      
      Get.snackbar(
        'Error',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } finally {
      if (!_isTryOnCancelled) {
        isTryOnLoading.value = false;
      }
      _isTryOnCancelled = false;
    }
  }

  /// Generate unique ID for a try-on result
  String _generateTryOnId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return '${product.value?.id ?? "product"}_${timestamp}_$random';
  }

  /// Add try-on result to the first position
  /// This should be called when returning from the try-on page with results
  Future<void> addTryOnResult(Uint8List result) async {
    // Shift existing IDs
    final shiftedIds = <int, String>{};
    final shiftedStatus = <int, bool>{};
    
    for (var entry in tryOnResultIds.entries) {
      shiftedIds[entry.key + 1] = entry.value;
    }
    for (var entry in savedTryOnStatus.entries) {
      shiftedStatus[entry.key + 1] = entry.value;
    }
    
    tryOnResultIds.clear();
    tryOnResultIds.addAll(shiftedIds);
    savedTryOnStatus.clear();
    savedTryOnStatus.addAll(shiftedStatus);
    
    // Generate unique ID for new try-on result
    final tryOnId = _generateTryOnId();
    tryOnResultImages.insert(0, result);
    tryOnResultIds[0] = tryOnId;
    savedTryOnStatus[0] = false; // New try-on is not saved by default
    
    _tryOnUpdateTrigger.value++;
    
    // Move slider to position 0 (the new try-on result)
    if (pageController.hasClients) {
      await pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    currentPageIndex.value = 0;
  }

  /// Get all display images (try-on results first, then original product images)
  List<dynamic> getAllDisplayImages() {
    if (product.value == null) return [];
    
    final List<dynamic> images = [];
    // Add try-on results first
    images.addAll(tryOnResultImages);
    // Add original product images
    images.addAll(product.value!.images);
    return images;
  }

  /// Get total count of all display images
  int get totalDisplayImageCount {
    if (product.value == null) return 0;
    return tryOnResultImages.length + product.value!.images.length;
  }

  /// Get image data at display index
  /// Returns Uint8List for try-on results, String for original images
  dynamic getDisplayImage(int index) {
    if (index < tryOnResultImages.length) {
      return tryOnResultImages[index];
    } else {
      final originalIndex = index - tryOnResultImages.length;
      if (product.value != null && originalIndex < product.value!.images.length) {
        return product.value!.images[originalIndex];
      }
    }
    return null;
  }

  /// Check if image at index is a try-on result
  bool isTryOnResult(int index) {
    return index < tryOnResultImages.length;
  }

  /// Check if there are any try-on results
  bool get hasTryOnResults => tryOnResultImages.isNotEmpty;
  
  /// Get the reactive trigger value for try-on updates
  int get tryOnUpdateTrigger => _tryOnUpdateTrigger.value;

  /// Save try-on result image to local cache
  Future<bool> saveTryOnImage(int imageIndex) async {
    if (product.value == null) return false;
    
    // Check if this is a try-on result
    if (!isTryOnResult(imageIndex)) return false;
    
    final imageData = getDisplayImage(imageIndex);
    if (imageData == null || imageData is! Uint8List) return false;
    
    try {
      // Get or generate try-on ID
      String tryOnId = tryOnResultIds[imageIndex] ?? _generateTryOnId();
      if (!tryOnResultIds.containsKey(imageIndex)) {
        tryOnResultIds[imageIndex] = tryOnId;
      }
      
      final success = await _tryOnStorage.saveTryOnWithId(tryOnId, imageData);
      
      if (success) {
        savedTryOnStatus[imageIndex] = true;
        Get.snackbar(
          'Success',
          'Try-on image saved',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to save try-on image',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      
      return success;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// Unsave (remove) try-on result image
  Future<bool> unsaveTryOnImage(int imageIndex) async {
    if (product.value == null) return false;
    
    // Check if this is a try-on result
    if (!isTryOnResult(imageIndex)) return false;
    
    try {
      final tryOnId = tryOnResultIds[imageIndex];
      if (tryOnId == null) {
        Get.snackbar(
          'Error',
          'Try-on ID not found',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
      
      final success = await _tryOnStorage.removeTryOnById(tryOnId);
      
      if (success) {
        savedTryOnStatus[imageIndex] = false;
        Get.snackbar(
          'Success',
          'Try-on image removed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to remove try-on image',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      
      return success;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// Check if current image is a saved try-on
  bool isTryOnSaved(int imageIndex) {
    if (product.value == null || !isTryOnResult(imageIndex)) return false;
    return savedTryOnStatus[imageIndex] ?? false;
  }

  /// Handle back navigation with confirmation if try-on is in progress
  /// Returns true if navigation should proceed, false otherwise
  Future<bool> handleBackNavigation() async {
    if (isTryOnLoading.value) {
      // Show confirmation dialog
      final shouldCancel = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Cancel Try-On Generation?'),
          content: const Text(
            'Try-on generation is in progress. If you go back now, this process will be cancelled.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Continue'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Cancel & Go Back'),
            ),
          ],
        ),
      );

      if (shouldCancel == true) {
        // Cancel the try-on process
        cancelTryOnGeneration();
        return true; // Allow navigation to proceed
      }
      return false; // Don't navigate, stay on page
    } else {
      // No try-on in progress, allow navigation
      return true;
    }
  }

  /// Cancel the try-on generation process
  void cancelTryOnGeneration() {
    _isTryOnCancelled = true;
    isTryOnLoading.value = false;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
