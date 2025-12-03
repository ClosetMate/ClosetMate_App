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
      
      // Get all saved product IDs
      final savedProductIds = await _tryOnStorage.getSavedProductIds();
      
      if (savedProductIds.isEmpty) {
        products.value = [];
        isLoading.value = false;
        return;
      }

      // Fetch products and try-on images
      final List<CmProductModel> loadedProducts = [];
      final Map<String, Uint8List> loadedImages = {};
      
      for (final productId in savedProductIds) {
        try {
          // Fetch product
          final product = await _productsService.getProductById(productId);
          if (product != null) {
            // Get try-on image
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

  /// Get try-on image for a product
  Uint8List? getTryOnImage(String productId) {
    return tryOnImages[productId];
  }

  /// Remove saved try-on
  Future<void> removeTryOn(String productId) async {
    try {
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

