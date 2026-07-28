import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:closet_mate/models/cm_product_model.dart';
import 'package:closet_mate/app/data/products_data.dart';

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
    final mockData = getShuffledProducts();

    return mockData.map((item) {
      final List<String> colors = item['colors']?.cast<String>() ?? ['Black', 'White', 'Navy'];
      final List<String> sizes = item['sizes']?.cast<String>() ?? ['S', 'M', 'L', 'XL'];
      final int totalStock = (item['stock'] ?? 20) as int;
      final int stockPerVariant = (totalStock / (colors.length * sizes.length)).ceil();
      
      final List<ProductVariant> variants = [];
      for (var color in colors) {
        for (var size in sizes) {
          variants.add(ProductVariant(
            color: color,
            size: size,
            sku: '${item['product_id']}-$color-$size',
            stock: stockPerVariant,
          ));
        }
      }

      return CmProductModel(
        id: item['product_id']?.toString() ?? '',
        name: item['name'] ?? '',
        description: item['description'] ?? '',
        brand: item['brand_name'] ?? '',
        price: (item['price'] ?? 0).toDouble(),
        currency: item['currency'] ?? '\$',
        images: List<String>.from(item['otherImageUrls'] ?? [item['imageUrl'] ?? '']),
        variants: variants,
        tags: [if (item['category'] != null) item['category'].toString()],
        createdAt: '',
        updatedAt: '',
      );
    }).toList();
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
