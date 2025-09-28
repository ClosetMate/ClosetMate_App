import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/services/products_service.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final ProductsService _productsService = ProductsService();
  final RxList<CmProductModel> products = <CmProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Set<String> favoriteProductIds = {};
  
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
}
