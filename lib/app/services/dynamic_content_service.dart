import 'package:closet_mate/models/dynamic_section.dart';
import 'package:closet_mate/models/product_model.dart';
import 'package:closet_mate/app/data/remote_config_data.dart';
import 'package:closet_mate/app/modules/home/views/widgets/brands_section.dart';

class DynamicContentService {
  static final DynamicContentService _instance = DynamicContentService._internal();
  factory DynamicContentService() => _instance;
  DynamicContentService._internal();

  // Cache for storing fetched data
  Map<String, dynamic> _cache = {};
  DateTime? _lastCacheTime;
  static const Duration _cacheExpiry = Duration(minutes: 5);

  // Get home layout configuration
  Future<HomeLayout> getHomeLayout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In real implementation, this would be a remote config or API call
    final config = mockRemoteConfig['home_layout'];
    return HomeLayout.fromConfig(config);
  }

  // Get trending deals
  Future<List<ProductModel>> getTrendingDeals() async {
    if (_isCacheValid('trending_deals')) {
      return _cache['trending_deals'];
    }

    await Future.delayed(const Duration(milliseconds: 300));
    
    final response = mockTrendingDeals;
    final products = (response['data'] as List)
        .map((item) => ProductModel.fromMap(item))
        .toList();
    
    _cache['trending_deals'] = products;
    _updateCacheTime();
    
    return products;
  }

  // Get products by category
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    if (_isCacheValid(category)) {
      return _cache[category];
    }

    await Future.delayed(const Duration(milliseconds: 400));
    
    Map<String, dynamic> response;
    switch (category) {
      case 'top_selling':
        response = mockTopSellingProducts;
        break;
      case 'new_arrivals':
        response = mockNewArrivals;
        break;
      case 'recommended':
        response = mockRecommendedProducts;
        break;
      default:
        response = mockTopSellingProducts;
    }
    
    final products = (response['data'] as List)
        .map((item) => ProductModel.fromMap(item))
        .toList();
    
    _cache[category] = products;
    _updateCacheTime();
    
    return products;
  }

  // Get featured brands
  Future<List<BrandItem>> getFeaturedBrands() async {
    if (_isCacheValid('featured_brands')) {
      return _cache['featured_brands'];
    }

    await Future.delayed(const Duration(milliseconds: 200));
    
    final response = mockFeaturedBrands;
    final brands = (response['data'] as List)
        .map((item) => BrandItem(
              name: item['name'],
              logoUrl: item['logoUrl'],
            ))
        .toList();
    
    _cache['featured_brands'] = brands;
    _updateCacheTime();
    
    return brands;
  }

  // Get promotional banner data
  Future<Map<String, dynamic>?> getPromotionalBanner() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    // This could be dynamic based on events, holidays, etc.
    final now = DateTime.now();
    final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
    
    if (isWeekend) {
      return {
        'text': '🎉 Weekend Sale - 30% OFF!',
        'color': '#FF6B6B',
        'action_url': '/weekend-sale',
        'enabled': true,
      };
    }
    
    return null;
  }

  // Clear cache (useful for testing or when you want fresh data)
  void clearCache() {
    _cache.clear();
    _lastCacheTime = null;
  }

  // Check if cache is still valid
  bool _isCacheValid(String key) {
    if (!_cache.containsKey(key) || _lastCacheTime == null) {
      return false;
    }
    
    return DateTime.now().difference(_lastCacheTime!) < _cacheExpiry;
  }

  // Update cache timestamp
  void _updateCacheTime() {
    _lastCacheTime = DateTime.now();
  }

  // Simulate real-time updates (for future implementation)
  Stream<Map<String, dynamic>> getRealTimeUpdates() {
    return Stream.periodic(const Duration(seconds: 30), (timer) {
      // In real implementation, this would be WebSocket or Firebase Realtime Database
      return {
        'type': 'content_update',
        'timestamp': DateTime.now().toIso8601String(),
        'updates': {
          'trending_deals': 'updated',
          'new_arrivals': 'updated',
        }
      };
    });
  }
} 