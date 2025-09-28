import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/models/dynamic_section.dart';
import 'package:get/get.dart';
import 'package:closet_mate/app/modules/home/views/widgets/brands_section.dart';
import 'package:closet_mate/app/services/dynamic_content_service.dart';
import 'package:closet_mate/app/services/products_service.dart';

class HomeController extends GetxController {
  late String selectedValue = 'Female';
  late List<String> items = ['Men', 'Female', 'Unisex'];

  // Services
  final DynamicContentService _contentService = DynamicContentService();
  final ProductsService _productsService = ProductsService();

  // Observable data
  final Rx<HomeLayout?> homeLayout = Rx<HomeLayout?>(null);
  final RxList<CmProductModel> trendingDeals = <CmProductModel>[].obs;
  final RxList<CmProductModel> topSellingProducts = <CmProductModel>[].obs;
  final RxList<CmProductModel> newArrivals = <CmProductModel>[].obs;
  final RxList<CmProductModel> recommendedProducts = <CmProductModel>[].obs;
  final RxList<BrandItem> featuredBrands = <BrandItem>[].obs;
  final Rx<Map<String, dynamic>?> promotionalBanner = Rx<Map<String, dynamic>?>(null);

  // Loading states
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;


  @override
  void onInit() async {
    await _loadDynamicContent();
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
      final deals = await _productsService.getProducts(skip: 0, limit: 10);
      trendingDeals.assignAll(deals);
    } catch (e) {
      print('Error loading trending deals: $e');
    }
  }

  Future<void> _loadTopSellingProducts() async {
    try {
      final products = await _productsService.getProducts(skip: 0, limit: 10);
      topSellingProducts.assignAll(products);
    } catch (e) {
      print('Error loading top selling products: $e');
    }
  }

  Future<void> _loadNewArrivals() async {
    try {
      final products = await _productsService.getProducts(skip: 0, limit: 10);
      newArrivals.assignAll(products);
    } catch (e) {
      print('Error loading new arrivals: $e');
    }
  }

  Future<void> _loadRecommendedProducts() async {
    try {
      final products = await _productsService.getProducts(skip: 0, limit: 10);
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
  List<CmProductModel> getProductsForSection(String category) {
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
        return []; // Return empty list as fallback
    }
  }


  void setSelectedValue(String value) {
    selectedValue = value;
    update();
  }
}
