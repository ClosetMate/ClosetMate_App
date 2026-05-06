import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:closet_mate/models/cm_product_model.dart';

class ProductsService {
  static final ProductsService _instance = ProductsService._internal();
  factory ProductsService() => _instance;
  ProductsService._internal();

  // Base URL for the products API
  static const String _baseUrl = 'http://18.118.185.209:8000';
  
  // Mock mode flag - set to true to use mock data
  static bool useMockData = true;
  
  // Cache for storing fetched data
  final Map<String, List<CmProductModel>> _cache = {};
  DateTime? _lastCacheTime;
  static const Duration _cacheExpiry = Duration(minutes: 10);

  /// Get mock products data for development
  List<CmProductModel> _getMockProducts() {
    final mockData = [
      {
        '_id': 'mock_1',
        'name': 'Classic Denim Jacket',
        'description': 'A timeless denim jacket perfect for any season. Made from premium cotton denim with a comfortable fit.',
        'brand': 'Levi\'s',
        'price': 89.99,
        'currency': 'USD',
        'images': [
          'assets/images/products/p1_0.png',
          'assets/images/products/p1_1.png',
          'assets/images/products/p1_2.png',
          'assets/images/products/p1_3.png',
          'assets/images/products/p1_4.png',
        ],
        'variants': [
          {'color': 'Blue', 'size': 'S', 'sku': 'DJ-001-S-BL', 'stock': 15},
          {'color': 'Blue', 'size': 'M', 'sku': 'DJ-001-M-BL', 'stock': 20},
          {'color': 'Blue', 'size': 'L', 'sku': 'DJ-001-L-BL', 'stock': 18},
          {'color': 'Blue', 'size': 'XL', 'sku': 'DJ-001-XL-BL', 'stock': 10},
        ],
        'tags': ['jacket', 'denim', 'casual', 'outerwear'],
        'created_at': '2024-01-15T10:00:00Z',
        'updated_at': '2024-01-20T14:30:00Z',
      },
      {
        '_id': 'mock_2',
        'name': 'Slim Fit Chinos',
        'description': 'Versatile chino pants with a modern slim fit. Perfect for both casual and smart-casual occasions.',
        'brand': 'Nike',
        'price': 59.99,
        'currency': 'USD',
        'images': [
          'assets/images/products/p2_0.png',
          'assets/images/products/p2_1.png',
          'assets/images/products/p2_2.png',
          'assets/images/products/p2_3.png',
          'assets/images/products/p2_4.png',
        ],
        'variants': [
          {'color': 'Khaki', 'size': '30', 'sku': 'CH-002-30-KH', 'stock': 25},
          {'color': 'Khaki', 'size': '32', 'sku': 'CH-002-32-KH', 'stock': 30},
          {'color': 'Khaki', 'size': '34', 'sku': 'CH-002-34-KH', 'stock': 22},
          {'color': 'Navy', 'size': '30', 'sku': 'CH-002-30-NV', 'stock': 18},
          {'color': 'Navy', 'size': '32', 'sku': 'CH-002-32-NV', 'stock': 28},
        ],
        'tags': ['pants', 'chinos', 'casual', 'slim-fit'],
        'created_at': '2024-01-16T09:15:00Z',
        'updated_at': '2024-01-19T11:20:00Z',
      },
      {
        '_id': 'mock_3',
        'name': 'Cotton T-Shirt',
        'description': 'Soft and comfortable cotton t-shirt. Essential piece for your everyday wardrobe.',
        'brand': 'Adidas',
        'price': 29.99,
        'currency': 'USD',
        'images': [
          'assets/images/products/p3_0.png',
          'assets/images/products/p3_1.png',
          'assets/images/products/p3_2.png',
          'assets/images/products/p3_3.png',
          'assets/images/products/p3_4.png',
        ],
        'variants': [
          {'color': 'White', 'size': 'S', 'sku': 'TS-003-S-WH', 'stock': 50},
          {'color': 'White', 'size': 'M', 'sku': 'TS-003-M-WH', 'stock': 45},
          {'color': 'White', 'size': 'L', 'sku': 'TS-003-L-WH', 'stock': 40},
          {'color': 'Black', 'size': 'S', 'sku': 'TS-003-S-BK', 'stock': 35},
          {'color': 'Black', 'size': 'M', 'sku': 'TS-003-M-BK', 'stock': 42},
          {'color': 'Black', 'size': 'L', 'sku': 'TS-003-L-BK', 'stock': 38},
        ],
        'tags': ['t-shirt', 'cotton', 'casual', 'basic'],
        'created_at': '2024-01-17T08:30:00Z',
        'updated_at': '2024-01-18T16:45:00Z',
      },
      {
        '_id': 'mock_4',
        'name': 'Hooded Sweatshirt',
        'description': 'Cozy hooded sweatshirt perfect for cooler days. Features a comfortable fit with a front pocket.',
        'brand': 'Puma',
        'price': 69.99,
        'currency': 'USD',
        'images': [
          'assets/images/products/p4_0.png',
          'assets/images/products/p4_1.png',
          'assets/images/products/p4_2.png',
          'assets/images/products/p4_3.png',
          'assets/images/products/p4_4.png',
        ],
        'variants': [
          {'color': 'Grey', 'size': 'S', 'sku': 'HS-004-S-GR', 'stock': 20},
          {'color': 'Grey', 'size': 'M', 'sku': 'HS-004-M-GR', 'stock': 25},
          {'color': 'Grey', 'size': 'L', 'sku': 'HS-004-L-GR', 'stock': 18},
          {'color': 'Navy', 'size': 'M', 'sku': 'HS-004-M-NV', 'stock': 22},
          {'color': 'Navy', 'size': 'L', 'sku': 'HS-004-L-NV', 'stock': 20},
        ],
        'tags': ['sweatshirt', 'hoodie', 'casual', 'warm'],
        'created_at': '2024-01-18T10:20:00Z',
        'updated_at': '2024-01-20T09:10:00Z',
      },
      {
        '_id': 'mock_5',
        'name': 'Mini Dress',
        'description': 'Sail Blue Velvet Ruched Short Sleeve Pocketed Mini Dress.',
        'brand': 'Nike',
        'price': 129.99,
        'currency': 'USD',
        'images': [
          'assets/images/products/p5_0.png',
          'assets/images/products/p5_1.png',
          'assets/images/products/p5_2.png',
          'assets/images/products/p5_3.png',
          'assets/images/products/p5_4.png',
        ],
        'variants': [
          {'color': 'White', 'size': '8', 'sku': 'SN-005-8-WH', 'stock': 12},
          {'color': 'White', 'size': '9', 'sku': 'SN-005-9-WH', 'stock': 15},
          {'color': 'White', 'size': '10', 'sku': 'SN-005-10-WH', 'stock': 18},
          {'color': 'Black', 'size': '8', 'sku': 'SN-005-8-BK', 'stock': 10},
          {'color': 'Black', 'size': '9', 'sku': 'SN-005-9-BK', 'stock': 14},
          {'color': 'Black', 'size': '10', 'sku': 'SN-005-10-BK', 'stock': 16},
        ],
        'tags': ['shoes', 'sneakers', 'leather', 'casual'],
        'created_at': '2024-01-19T11:45:00Z',
        'updated_at': '2024-01-21T13:30:00Z',
      },
      {
        '_id': 'mock_6',
        'name': 'Sleeveless Mini Dress',
        'description': 'Premium Blue Boat Neckline Bowknot Ruched Sleeveless Mini Dress to keep you warm during cold seasons. Classic design with modern details.',
        'brand': 'Zara',
        'price': 199.99,
        'currency': 'USD',
        'images': [
          'assets/images/products/p6_0.png',
          'assets/images/products/p6_1.png',
          'assets/images/products/p6_2.png',
        ],
        'variants': [
          {'color': 'Black', 'size': 'S', 'sku': 'WC-006-S-BK', 'stock': 8},
          {'color': 'Black', 'size': 'M', 'sku': 'WC-006-M-BK', 'stock': 12},
          {'color': 'Black', 'size': 'L', 'sku': 'WC-006-L-BK', 'stock': 10},
          {'color': 'Camel', 'size': 'M', 'sku': 'WC-006-M-CM', 'stock': 9},
          {'color': 'Camel', 'size': 'L', 'sku': 'WC-006-L-CM', 'stock': 7},
        ],
        'tags': ['coat', 'winter', 'wool', 'outerwear'],
        'created_at': '2024-01-20T14:00:00Z',
        'updated_at': '2024-01-22T10:15:00Z',
      },
      {
        '_id': 'mock_7',
        'name': 'Women Bodycon Mini Dress',
        'description': 'Classic fit Women Bodycon Mini Dress with comfort stretch. Durable and stylish for everyday wear.',
        'brand': 'Levi\'s',
        'price': 79.99,
        'currency': 'USD',
        'images': [
          'assets/images/products/p7_0.png',
          'assets/images/products/p7_1.png',
          'assets/images/products/p7_2.png',
          'assets/images/products/p7_3.png',
          'assets/images/products/p7_4.png',
        ],
        'variants': [
          {'color': 'Dark Blue', 'size': '30', 'sku': 'DJ-007-30-DB', 'stock': 28},
          {'color': 'Dark Blue', 'size': '32', 'sku': 'DJ-007-32-DB', 'stock': 32},
          {'color': 'Dark Blue', 'size': '34', 'sku': 'DJ-007-34-DB', 'stock': 25},
          {'color': 'Light Blue', 'size': '30', 'sku': 'DJ-007-30-LB', 'stock': 20},
          {'color': 'Light Blue', 'size': '32', 'sku': 'DJ-007-32-LB', 'stock': 24},
        ],
        'tags': ['jeans', 'denim', 'casual', 'pants'],
        'created_at': '2024-01-21T09:30:00Z',
        'updated_at': '2024-01-23T11:00:00Z',
      },
    ];

    return mockData
        .map((item) => CmProductModel.fromMap(item))
        .toList();
  }

  /// Fetch products from the API with pagination
  /// 
  /// [skip] - Number of products to skip (for pagination)
  /// [limit] - Maximum number of products to fetch
  /// [forceRefresh] - If true, bypass cache and fetch fresh data
  Future<List<CmProductModel>> getProducts({
    int skip = 0,
    int limit = 20,
    bool forceRefresh = false,
  }) async {
    // Return mock data if mock mode is enabled
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      final allProducts = _getMockProducts();
      final endIndex = (skip + limit).clamp(0, allProducts.length);
      return allProducts.skip(skip).take(endIndex - skip).toList();
    }

    final cacheKey = 'products_${skip}_$limit';
    
    // Return cached data if available and not forcing refresh
    if (!forceRefresh && _isCacheValid(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final url = Uri.parse('$_baseUrl/products/?skip=$skip&limit=$limit');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        
        final products = jsonData
            .map((item) => CmProductModel.fromMap(item))
            .toList();

        // Cache the results
        _cache[cacheKey] = products;
        _updateCacheTime();

        return products;
      } else {
        throw ProductsServiceException(
          'Failed to fetch products: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on http.ClientException {
      throw ProductsServiceException(
        'Network error: Unable to connect to the server',
        0,
      );
    } on FormatException {
      throw ProductsServiceException(
        'Invalid response format from server',
        0,
      );
    } catch (e) {
      throw ProductsServiceException(
        'Unexpected error: $e',
        0,
      );
    }
  }

  /// Fetch a single product by ID
  Future<CmProductModel?> getProductById(String productId) async {
    // Return mock data if mock mode is enabled
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
      final allProducts = _getMockProducts();
      try {
        return allProducts.firstWhere((product) => product.id == productId);
      } catch (e) {
        return null; // Product not found
      }
    }

    try {
      final url = Uri.parse('$_baseUrl/products/$productId');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return CmProductModel.fromMap(jsonData);
      } else if (response.statusCode == 404) {
        return null; // Product not found
      } else {
        throw ProductsServiceException(
          'Failed to fetch product: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on http.ClientException {
      throw ProductsServiceException(
        'Network error: Unable to connect to the server',
        0,
      );
    } on FormatException {
      throw ProductsServiceException(
        'Invalid response format from server',
        0,
      );
    } catch (e) {
      throw ProductsServiceException(
        'Unexpected error: $e',
        0,
      );
    }
  }

  /// Search products by query
  Future<List<CmProductModel>> searchProducts({
    required String query,
    int skip = 0,
    int limit = 20,
  }) async {
    // Return mock data if mock mode is enabled
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 400)); // Simulate network delay
      final allProducts = _getMockProducts();
      final queryLower = query.toLowerCase();
      
      // Filter products by query (search in name, description, brand, and tags)
      final filteredProducts = allProducts.where((product) {
        return product.name.toLowerCase().contains(queryLower) ||
            product.description.toLowerCase().contains(queryLower) ||
            product.brand.toLowerCase().contains(queryLower) ||
            product.tags.any((tag) => tag.toLowerCase().contains(queryLower));
      }).toList();
      
      final endIndex = (skip + limit).clamp(0, filteredProducts.length);
      return filteredProducts.skip(skip).take(endIndex - skip).toList();
    }

    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = Uri.parse('$_baseUrl/products/search/?q=$encodedQuery&skip=$skip&limit=$limit');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        
        return jsonData
            .map((item) => CmProductModel.fromMap(item))
            .toList();
      } else {
        throw ProductsServiceException(
          'Failed to search products: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on http.ClientException {
      throw ProductsServiceException(
        'Network error: Unable to connect to the server',
        0,
      );
    } on FormatException {
      throw ProductsServiceException(
        'Invalid response format from server',
        0,
      );
    } catch (e) {
      throw ProductsServiceException(
        'Unexpected error: $e',
        0,
      );
    }
  }

  /// Get products by category/tag
  Future<List<CmProductModel>> getProductsByCategory({
    required String category,
    int skip = 0,
    int limit = 20,
  }) async {
    // Return mock data if mock mode is enabled
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 400)); // Simulate network delay
      final allProducts = _getMockProducts();
      final categoryLower = category.toLowerCase();
      
      // Filter products by category/tag
      final filteredProducts = allProducts.where((product) {
        return product.tags.any((tag) => tag.toLowerCase() == categoryLower) ||
            product.tags.any((tag) => tag.toLowerCase().contains(categoryLower));
      }).toList();
      
      final endIndex = (skip + limit).clamp(0, filteredProducts.length);
      return filteredProducts.skip(skip).take(endIndex - skip).toList();
    }

    try {
      final encodedCategory = Uri.encodeComponent(category);
      final url = Uri.parse('$_baseUrl/products/category/$encodedCategory/?skip=$skip&limit=$limit');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        
        return jsonData
            .map((item) => CmProductModel.fromMap(item))
            .toList();
      } else {
        throw ProductsServiceException(
          'Failed to fetch products by category: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on http.ClientException {
      throw ProductsServiceException(
        'Network error: Unable to connect to the server',
        0,
      );
    } on FormatException {
      throw ProductsServiceException(
        'Invalid response format from server',
        0,
      );
    } catch (e) {
      throw ProductsServiceException(
        'Unexpected error: $e',
        0,
      );
    }
  }

  /// Clear cache (useful for testing or when you want fresh data)
  void clearCache() {
    _cache.clear();
    _lastCacheTime = null;
  }

  /// Check if cache is still valid
  bool _isCacheValid(String key) {
    if (!_cache.containsKey(key) || _lastCacheTime == null) {
      return false;
    }
    
    return DateTime.now().difference(_lastCacheTime!) < _cacheExpiry;
  }

  /// Update cache timestamp
  void _updateCacheTime() {
    _lastCacheTime = DateTime.now();
  }
}

/// Custom exception class for ProductsService errors
class ProductsServiceException implements Exception {
  final String message;
  final int statusCode;

  ProductsServiceException(this.message, this.statusCode);

  @override
  String toString() => 'ProductsServiceException: $message (Status: $statusCode)';
}
