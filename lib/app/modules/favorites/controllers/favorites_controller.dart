import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/services/products_service.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';

class FavoritesController extends GetxController {
  final ProductsService _productsService = ProductsService();
  final RxList<CmProductModel> products = <CmProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Set<String> favoriteProductIds = {};
  
  final RxString activeMainTab = 'closet'.obs;
  final RxString activeCategory = 'All'.obs;

  void setActiveTab(String tab) => activeMainTab.value = tab;
  void setActiveCategory(String category) => activeCategory.value = category;

  List<CmProductModel> get filteredWardrobe {
    if (activeCategory.value == 'All') return products;
    return products.where((p) => p.tags.isNotEmpty && p.tags.first == activeCategory.value).toList();
  }

  List<String> get categories {
    final cats = products.expand((p) => p.tags).toSet().toList();
    return ['All', ...cats];
  }
  
  @override
  void onInit() async {
    await _getProducts();
    super.onInit();
  }

  Future<void> _getProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final fetchedProducts = await _productsService.getProducts(
        skip: 0,
        limit: 20,
      );
      
      products.value = fetchedProducts;
      
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error loading products: $e');
    } finally {
      isLoading.value = false;
    }
  }


  // Toggle favorite status
  void toggleFavorite(String productId) {
    if (favoriteProductIds.contains(productId)) {
      favoriteProductIds.remove(productId);
    } else {
      favoriteProductIds.add(productId);
    }
    update();
  }

  // Check if product is favorite
  bool isFavorite(String productId) {
    return favoriteProductIds.contains(productId);
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await _getProducts();
  }

  // Share closet link
  Future<void> shareClosetLink(BuildContext? context) async {
    try {
      // TODO: Replace with actual user ID from authentication/backend
      // For now using a placeholder - update this when user ID is available
      const String userId = 'user123'; // This should come from your auth system
      const String baseUrl = 'https://closetmate.app'; // Update with your actual domain
      final String closetLink = '$baseUrl/closet/$userId';
      
      const String shareTitle = 'My Closet - Closet Mate';
      final String shareText = '$shareTitle\n\nCheck out my closet on Closet Mate!\n$closetLink';
      
      // Load the splash image from assets
      ByteData logoBytes;
      try {
        logoBytes = await rootBundle.load('assets/images/splash.png');
      } catch (e) {
        // Fallback to logo.png if splash.png doesn't exist
        logoBytes = await rootBundle.load('assets/images/logo.png');
      }
      
      final Uint8List logoUint8List = logoBytes.buffer.asUint8List();
      final XFile logoFile = XFile.fromData(
        logoUint8List,
        name: 'My Closet - Closet Mate.png',
        mimeType: 'image/png',
      );
      
      if (context != null) {
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final Rect sharePositionOrigin = box.localToGlobal(Offset.zero) & box.size;
          
          await Share.shareXFiles(
            [logoFile],
            text: shareText,
            subject: shareTitle,
            sharePositionOrigin: sharePositionOrigin,
          );
        } else {
          await Share.shareXFiles(
            [logoFile],
            text: shareText,
            subject: shareTitle,
          );
        }
      } else {
        await Share.shareXFiles(
          [logoFile],
          text: shareText,
          subject: shareTitle,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share closet link: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }
}
