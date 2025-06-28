import 'package:closet_mate/models/product_model.dart';
import 'package:closet_mate/models/dynamic_section.dart';
import 'package:get/get.dart';
import 'package:closet_mate/app/data/products_data.dart';
import 'package:closet_mate/app/modules/home/views/widgets/brands_section.dart';
import 'package:closet_mate/app/services/dynamic_content_service.dart';

class HomeController extends GetxController {
  late String selectedValue = 'Female';
  late List<String> items = ['Men', 'Female', 'Unisex'];

  // Dynamic content service
  final DynamicContentService _contentService = DynamicContentService();

  // Observable data
  final Rx<HomeLayout?> homeLayout = Rx<HomeLayout?>(null);
  final RxList<ProductModel> trendingDeals = <ProductModel>[].obs;
  final RxList<ProductModel> topSellingProducts = <ProductModel>[].obs;
  final RxList<ProductModel> newArrivals = <ProductModel>[].obs;
  final RxList<ProductModel> recommendedProducts = <ProductModel>[].obs;
  final RxList<BrandItem> featuredBrands = <BrandItem>[].obs;
  final Rx<Map<String, dynamic>?> promotionalBanner = Rx<Map<String, dynamic>?>(null);

  // Loading states
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Legacy data for backward compatibility
  List<ProductModel> products = [];
  final Set<int> favoriteIndexes = {};

  @override
  void onInit() async {
    await _loadDynamicContent();
    _getProducts(); // Keep legacy data for now
    super.onInit();
  }

  Future<void> _loadDynamicContent() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Load home layout configuration
      final layout = await _contentService.getHomeLayout();
      homeLayout.value = layout;

      // Load content for each section
      await Future.wait([
        _loadTrendingDeals(),
        _loadTopSellingProducts(),
        _loadNewArrivals(),
        _loadRecommendedProducts(),
        _loadFeaturedBrands(),
        _loadPromotionalBanner(),
      ]);

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Error loading dynamic content: $e');
    }
  }

  Future<void> _loadTrendingDeals() async {
    try {
      final deals = await _contentService.getTrendingDeals();
      trendingDeals.assignAll(deals);
    } catch (e) {
      print('Error loading trending deals: $e');
    }
  }

  Future<void> _loadTopSellingProducts() async {
    try {
      final products = await _contentService.getProductsByCategory('top_selling');
      topSellingProducts.assignAll(products);
    } catch (e) {
      print('Error loading top selling products: $e');
    }
  }

  Future<void> _loadNewArrivals() async {
    try {
      final products = await _contentService.getProductsByCategory('new_arrivals');
      newArrivals.assignAll(products);
    } catch (e) {
      print('Error loading new arrivals: $e');
    }
  }

  Future<void> _loadRecommendedProducts() async {
    try {
      final products = await _contentService.getProductsByCategory('recommended');
      recommendedProducts.assignAll(products);
    } catch (e) {
      print('Error loading recommended products: $e');
    }
  }

  Future<void> _loadFeaturedBrands() async {
    try {
      final brands = await _contentService.getFeaturedBrands();
      featuredBrands.assignAll(brands);
    } catch (e) {
      print('Error loading featured brands: $e');
    }
  }

  Future<void> _loadPromotionalBanner() async {
    try {
      final banner = await _contentService.getPromotionalBanner();
      promotionalBanner.value = banner;
    } catch (e) {
      print('Error loading promotional banner: $e');
    }
  }

  // Refresh content
  Future<void> refreshContent() async {
    _contentService.clearCache();
    await _loadDynamicContent();
  }

  // Get products for a specific section
  List<ProductModel> getProductsForSection(String category) {
    switch (category) {
      case 'top_selling':
        return topSellingProducts;
      case 'new_arrivals':
        return newArrivals;
      case 'recommended':
        return recommendedProducts;
      case 'trending_deals':
        return trendingDeals;
      default:
        return products; // Fallback to legacy data
    }
  }

  // Legacy methods for backward compatibility
  void _getProducts() {
    for (Map<String, dynamic> productMap in productsData) {
      products.add(ProductModel.fromMap(productMap));
    }
  }

  void setSelectedValue(String value) {
    selectedValue = value;
    update();
  }
}
