import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:closet_mate/models/tryon_result.dart';
import 'package:flutter/services.dart';

/// Service for interacting with Google Cloud Vertex AI Virtual Try-On API
class VirtualTryOnService {
  static final VirtualTryOnService _instance = VirtualTryOnService._internal();
  factory VirtualTryOnService() => _instance;
  VirtualTryOnService._internal();

  // Configuration - These should be set via environment variables or secure storage
  String? _projectId;
  String? _region;
  AutoRefreshingAuthClient? _authClient;

  /// Initialize the service with Google Cloud credentials
  /// 
  /// [projectId] - Your Google Cloud project ID
  /// [region] - The region for the API (e.g., 'us-central1')
  /// [serviceAccountKey] - JSON string of service account key (optional, can use default credentials)
  Future<void> initialize({
    required String projectId,
    required String region,
    String? serviceAccountKey,
  }) async {
    _projectId = projectId;
    _region = region;

    // Initialize authentication if service account key is provided
    if (serviceAccountKey != null) {
      try {
        final credentials = ServiceAccountCredentials.fromJson(serviceAccountKey);
        _authClient = await clientViaServiceAccount(
          credentials,
          ['https://www.googleapis.com/auth/cloud-platform'],
        );
      } catch (e) {
        print('Error initializing auth client: $e');
        // Fall back to default credentials or manual token
      }
    }
  }

  /// Get access token for API authentication
  /// This method attempts to get a token using the auth client or returns null
  /// In production, you might want to use a backend service to handle authentication
  Future<String?> _getAccessToken() async {
    if (_authClient != null) {
      try {
        final credentials = _authClient!.credentials;
        return credentials.accessToken.data;
      } catch (e) {
        print('Error getting access token: $e');
      }
    }
    
    // If no auth client, return null - caller should handle authentication
    // In production, you might want to fetch token from your backend
    return null;
  }

  /// Convert image file to base64 string
  Future<String> _imageToBase64(File imageFile) async {
    final Uint8List imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  /// Convert image bytes to base64 string
  String _imageBytesToBase64(Uint8List imageBytes) {
    return base64Encode(imageBytes);
  }

  /// Download image from URL and convert to base64
  Future<String> _downloadImageToBase64(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return base64Encode(response.bodyBytes);
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading image: $e');
    }
  }

  /// Load asset image and convert to base64
  Future<String> _loadAssetImageToBase64(String assetPath) async {
    try {
      final ByteData imageData = await rootBundle.load(assetPath);
      final Uint8List imageBytes = imageData.buffer.asUint8List();
      return base64Encode(imageBytes);
    } catch (e) {
      throw Exception('Error loading asset image: $e');
    }
  }

  /// Convert image source to base64
  /// Supports File, URL, and asset paths
  Future<String> _convertImageToBase64(dynamic imageSource) async {
    if (imageSource is File) {
      return await _imageToBase64(imageSource);
    } else if (imageSource is Uint8List) {
      return _imageBytesToBase64(imageSource);
    } else if (imageSource is String) {
      // Check if it's an asset path
      if (imageSource.startsWith('assets/')) {
        return await _loadAssetImageToBase64(imageSource);
      } else {
        // Assume it's a URL
        return await _downloadImageToBase64(imageSource);
      }
    } else {
      throw Exception('Unsupported image source type: ${imageSource.runtimeType}');
    }
  }

  /// Validate image before processing
  Future<void> _validateImage(dynamic imageSource) async {
    Uint8List imageBytes;
    
    if (imageSource is File) {
      imageBytes = await imageSource.readAsBytes();
    } else if (imageSource is Uint8List) {
      imageBytes = imageSource;
    } else if (imageSource is String) {
      if (imageSource.startsWith('assets/')) {
        final ByteData data = await rootBundle.load(imageSource);
        imageBytes = data.buffer.asUint8List();
      } else {
        final response = await http.get(Uri.parse(imageSource));
        if (response.statusCode != 200) {
          throw Exception('Failed to download image for validation');
        }
        imageBytes = response.bodyBytes;
      }
    } else {
      throw Exception('Invalid image source');
    }

    // Check image size (max 10MB recommended)
    const maxSize = 10 * 1024 * 1024; // 10MB
    if (imageBytes.length > maxSize) {
      throw Exception('Image size exceeds maximum allowed size (10MB)');
    }

    // Basic validation - check if it's a valid image format
    if (imageBytes.length < 100) {
      throw Exception('Image file appears to be invalid or corrupted');
    }
  }

  /// Generate virtual try-on images
  /// 
  /// [personImage] - File, Uint8List, or String (URL/asset path) of person image
  /// [productImages] - List containing exactly 1 product image (File, Uint8List, or String)
  ///                   Note: API requires exactly 1 product image, not multiple
  /// [sampleCount] - Number of images to generate (1-4, default: 1)
  /// [storageUri] - Optional Cloud Storage URI to store results
  /// [accessToken] - Optional access token (if not using service account)
  Future<TryOnResult> generateTryOn({
    required dynamic personImage,
    required List<dynamic> productImages,
    int sampleCount = 1,
    String? storageUri,
    String? accessToken,
  }) async {
    // Validate configuration
    if (_projectId == null || _region == null) {
      throw Exception('Service not initialized. Call initialize() first.');
    }

    // Validate inputs
    if (sampleCount < 1 || sampleCount > 4) {
      throw Exception('sampleCount must be between 1 and 4');
    }

    if (productImages.isEmpty) {
      throw Exception('At least one product image is required');
    }

    // API requires exactly 1 product image
    if (productImages.length > 1) {
      throw Exception(
        'API requires exactly 1 product image, but ${productImages.length} were provided. '
        'Please provide only the main product image.'
      );
    }

    // Validate images
    await _validateImage(personImage);
    for (var productImage in productImages) {
      await _validateImage(productImage);
    }

    // Get access token
    String? token = accessToken ?? await _getAccessToken();
    if (token == null) {
      throw Exception(
        'No access token available. Please provide accessToken parameter or initialize with service account.'
      );
    }

    // Convert images to base64
    final String personImageBase64 = await _convertImageToBase64(personImage);
    
    final List<Map<String, dynamic>> productImagesBase64 = [];
    for (var productImage in productImages) {
      final String base64 = await _convertImageToBase64(productImage);
      productImagesBase64.add({
        'image': {
          'bytesBase64Encoded': base64,
        },
      });
    }

    // Build request body
    final Map<String, dynamic> requestBody = {
      'instances': [
        {
          'personImage': {
            'image': {
              'bytesBase64Encoded': personImageBase64,
            },
          },
          'productImages': productImagesBase64,
        },
      ],
      'parameters': {
        'sampleCount': sampleCount,
        if (storageUri != null) 'storageUri': storageUri,
      },
    };

    // Build API endpoint
    final String endpoint = 
        'https://$_region-aiplatform.googleapis.com/v1/projects/$_projectId/locations/$_region/publishers/google/models/virtual-try-on-preview-08-04:predict';

    try {
      // Make API request
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(requestBody),
      );

      // Handle response
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return TryOnResult.fromApiResponse(responseData);
      } else {
        final errorBody = response.body;
        throw VirtualTryOnException(
          'API request failed: ${response.statusCode}',
          response.statusCode,
          errorBody,
        );
      }
    } on http.ClientException catch (e) {
      throw VirtualTryOnException(
        'Network error: ${e.message}',
        0,
        null,
      );
    } on FormatException catch (e) {
      throw VirtualTryOnException(
        'Invalid response format: ${e.message}',
        0,
        null,
      );
    } catch (e) {
      throw VirtualTryOnException(
        'Unexpected error: $e',
        0,
        null,
      );
    }
  }
}

/// Custom exception for Virtual Try-On service errors
class VirtualTryOnException implements Exception {
  final String message;
  final int statusCode;
  final String? errorBody;

  VirtualTryOnException(this.message, this.statusCode, this.errorBody);

  @override
  String toString() {
    if (errorBody != null) {
      return 'VirtualTryOnException: $message (Status: $statusCode)\n$errorBody';
    }
    return 'VirtualTryOnException: $message (Status: $statusCode)';
  }
}

