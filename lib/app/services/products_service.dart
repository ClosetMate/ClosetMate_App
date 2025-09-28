import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:closet_mate/models/cm_product_model.dart';

class ProductsService {
  static final ProductsService _instance = ProductsService._internal();
  factory ProductsService() => _instance;
  ProductsService._internal();

  // Base URL for the products API
  static const String _baseUrl = 'http://18.118.185.209:8000';
  
  // Cache for storing fetched data
  final Map<String, List<CmProductModel>> _cache = {};
  DateTime? _lastCacheTime;
  static const Duration _cacheExpiry = Duration(minutes: 10);

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
