import 'dart:typed_data';
import 'dart:convert';

/// Model for Virtual Try-On API results
class TryOnResult {
  final List<Uint8List> images;
  final List<String> mimeTypes;
  final DateTime createdAt;

  TryOnResult({
    required this.images,
    required this.mimeTypes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create TryOnResult from API response
  factory TryOnResult.fromApiResponse(Map<String, dynamic> response) {
    final List<dynamic> predictions = response['predictions'] ?? [];
    
    final List<Uint8List> images = [];
    final List<String> mimeTypes = [];

    for (var prediction in predictions) {
      final String? base64Image = prediction['bytesBase64Encoded'] as String?;
      final String? mimeType = prediction['mimeType'] as String?;
      
      if (base64Image != null) {
        try {
          final Uint8List imageBytes = base64Decode(base64Image);
          images.add(imageBytes);
          mimeTypes.add(mimeType ?? 'image/png');
        } catch (e) {
          // Skip invalid base64 images
          print('Error decoding base64 image: $e');
        }
      }
    }

    return TryOnResult(
      images: images,
      mimeTypes: mimeTypes,
    );
  }

  /// Convert image bytes to base64 string
  static String imageToBase64(Uint8List imageBytes) {
    return base64Encode(imageBytes);
  }

  /// Convert base64 string to image bytes
  static Uint8List base64ToImage(String base64String) {
    return base64Decode(base64String);
  }

  /// Get number of result images
  int get imageCount => images.length;

  /// Check if result has images
  bool get hasImages => images.isNotEmpty;
}

