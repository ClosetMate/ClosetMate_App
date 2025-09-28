import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/services/products_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CmProductDetailsController extends GetxController {
  final ProductsService _productsService = ProductsService();
  
  // Product data
  final Rx<CmProductModel?> product = Rx<CmProductModel?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  
  // UI state
  PageController pageController = PageController();
  final RxString selectedSize = ''.obs;
  final RxString selectedColor = ''.obs;
  final RxInt selectedQuantity = 1.obs;
  
  // Get product ID from arguments
  String get productId => Get.arguments as String;

  @override
  void onInit() {
    super.onInit();
    _loadProductDetails();
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

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
