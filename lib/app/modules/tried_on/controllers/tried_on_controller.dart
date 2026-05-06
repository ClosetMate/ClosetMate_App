import 'dart:typed_data';
import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/services/products_service.dart';
import 'package:closet_mate/app/services/tryon_storage_service.dart';
import 'package:get/get.dart';

class TriedOnController extends GetxController {
  final ProductsService _productsService = ProductsService();
  final TryOnStorageService _tryOnStorage = TryOnStorageService();
  
  final RxBool isLoading = true.obs;
  final RxList<CmProductModel> products = <CmProductModel>[].obs;
  final RxMap<String, Uint8List> tryOnImages = <String, Uint8List>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedTryOns();
  }

  Future<void> loadSavedTryOns() async {
    try {
      isLoading.value = true;
      
      // Get all saved try-on IDs (new system)
      final allSavedTryOnIds = await _tryOnStorage.getAllSavedTryOnIds();
      
      if (allSavedTryOnIds.isEmpty) {
        // Fallback to old system for backward compatibility
        final savedProductIds = await _tryOnStorage.getSavedProductIds();
        if (savedProductIds.isEmpty) {
          products.value = [];
          isLoading.value = false;
          return;
        }
        
        // Load using old system
        await _loadUsingOldSystem(savedProductIds);
        return;
      }

      // Group try-on IDs by product ID
      final Map<String, List<String>> productTryOnsMap = {};
      for (final tryOnId in allSavedTryOnIds) {
        final productId = _tryOnStorage.extractProductIdFromTryOnId(tryOnId);
        if (productId != null) {
          if (!productTryOnsMap.containsKey(productId)) {
            productTryOnsMap[productId] = [];
          }
          productTryOnsMap[productId]!.add(tryOnId);
        }
      }

      // Fetch products and try-on images
      final List<CmProductModel> loadedProducts = [];
      final Map<String, Uint8List> loadedImages = {};
      
      for (final entry in productTryOnsMap.entries) {
        final productId = entry.key;
        final tryOnIds = entry.value;
        
        try {
          // Fetch product
          final product = await _productsService.getProductById(productId);
          if (product != null) {
            // Get the latest try-on image (first in the list, or most recent)
            // For now, we'll use the first try-on ID (which should be the most recent based on our insertion logic)
            final latestTryOnId = tryOnIds.first;
            final tryOnImage = await _tryOnStorage.getTryOnImageById(latestTryOnId);
            
            if (tryOnImage != null) {
              // Add try-on image as first image in product images
              final updatedImages = [tryOnImage, ...product.images];
              // Create updated product with try-on image as first
              final updatedProduct = CmProductModel(
                name: product.name,
                description: product.description,
                brand: product.brand,
                price: product.price,
                currency: product.currency,
                images: updatedImages.map((img) => img is Uint8List ? 'tryon_$productId' : img as String).toList(),
                variants: product.variants,
                tags: product.tags,
                id: product.id,
                createdAt: product.createdAt,
                updatedAt: product.updatedAt,
              );
              loadedProducts.add(updatedProduct);
              loadedImages[productId] = tryOnImage;
            } else {
              // Product exists but no try-on image, still add it
              loadedProducts.add(product);
            }
          }
        } catch (e) {
          print('Error loading product $productId: $e');
        }
      }
      
      products.value = loadedProducts;
      tryOnImages.value = loadedImages;
    } catch (e) {
      print('Error loading saved try-ons: $e');
      Get.snackbar(
        'Error',
        'Failed to load saved try-ons',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load saved try-ons using old system (for backward compatibility)
  Future<void> _loadUsingOldSystem(List<String> savedProductIds) async {
    final List<CmProductModel> loadedProducts = [];
    final Map<String, Uint8List> loadedImages = {};
    
    for (final productId in savedProductIds) {
      try {
        // Fetch product
        final product = await _productsService.getProductById(productId);
        if (product != null) {
          // Get try-on image using old method
          final tryOnImage = await _tryOnStorage.getTryOnImage(productId);
          if (tryOnImage != null) {
            // Add try-on image as first image in product images
            final updatedImages = [tryOnImage, ...product.images];
            // Create updated product with try-on image as first
            final updatedProduct = CmProductModel(
              name: product.name,
              description: product.description,
              brand: product.brand,
              price: product.price,
              currency: product.currency,
              images: updatedImages.map((img) => img is Uint8List ? 'tryon_$productId' : img as String).toList(),
              variants: product.variants,
              tags: product.tags,
              id: product.id,
              createdAt: product.createdAt,
              updatedAt: product.updatedAt,
            );
            loadedProducts.add(updatedProduct);
            loadedImages[productId] = tryOnImage;
          } else {
            // Product exists but no try-on image, still add it
            loadedProducts.add(product);
          }
        }
      } catch (e) {
        print('Error loading product $productId: $e');
      }
    }
    
    products.value = loadedProducts;
    tryOnImages.value = loadedImages;
  }

  /// Get try-on image for a product
  Uint8List? getTryOnImage(String productId) {
    return tryOnImages[productId];
  }

  /// Remove saved try-on
  Future<void> removeTryOn(String productId) async {
    try {
      // Get all try-on IDs for this product
      final tryOnIds = await _tryOnStorage.getSavedTryOnIdsForProduct(productId);
      
      // Remove all try-on images for this product
      bool allRemoved = true;
      for (final tryOnId in tryOnIds) {
        final success = await _tryOnStorage.removeTryOnById(tryOnId);
        if (!success) {
          allRemoved = false;
        }
      }
      
      if (allRemoved || tryOnIds.isEmpty) {
        products.removeWhere((p) => p.id == productId);
        tryOnImages.remove(productId);
        Get.snackbar(
          'Success',
          'Try-on removed',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Fallback to old method for backward compatibility
        final success = await _tryOnStorage.removeTryOn(productId);
        if (success) {
          products.removeWhere((p) => p.id == productId);
          tryOnImages.remove(productId);
          Get.snackbar(
            'Success',
            'Try-on removed',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove try-on',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Refresh saved try-ons
  Future<void> refresh() async {
    await loadSavedTryOns();
  }
}

