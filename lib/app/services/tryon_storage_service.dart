import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Service to manage local storage of try-on images and product IDs
class TryOnStorageService {
  static final TryOnStorageService _instance = TryOnStorageService._internal();
  factory TryOnStorageService() => _instance;
  TryOnStorageService._internal();

  static const String _savedTryOnsKey = 'saved_tryon_products';
  static const String _savedTryOnIdsKey = 'saved_tryon_ids'; // For tracking individual try-on saves
  static const String _tryOnImagesDir = 'tryon_images';

  /// Save try-on image and product ID
  Future<bool> saveTryOn(String productId, Uint8List imageBytes) async {
    try {
      // Save image to local cache
      final imagePath = await _saveImageToCache(productId, imageBytes);
      if (imagePath == null) return false;

      // Get existing saved try-ons
      final prefs = await SharedPreferences.getInstance();
      final savedTryOnsJson = prefs.getString(_savedTryOnsKey);
      final savedTryOns = savedTryOnsJson != null
          ? List<String>.from(jsonDecode(savedTryOnsJson))
          : <String>[];

      // Add product ID if not already saved
      if (!savedTryOns.contains(productId)) {
        savedTryOns.add(productId);
        await prefs.setString(_savedTryOnsKey, jsonEncode(savedTryOns));
      }

      return true;
    } catch (e) {
      print('Error saving try-on: $e');
      return false;
    }
  }

  /// Get all saved product IDs
  Future<List<String>> getSavedProductIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTryOnsJson = prefs.getString(_savedTryOnsKey);
      if (savedTryOnsJson == null) return [];

      return List<String>.from(jsonDecode(savedTryOnsJson));
    } catch (e) {
      print('Error getting saved product IDs: $e');
      return [];
    }
  }

  /// Get try-on image for a product ID
  Future<Uint8List?> getTryOnImage(String productId) async {
    try {
      final imagePath = await _getImagePath(productId);
      if (imagePath == null || !await File(imagePath).exists()) {
        return null;
      }

      final file = File(imagePath);
      return await file.readAsBytes();
    } catch (e) {
      print('Error getting try-on image: $e');
      return null;
    }
  }

  /// Remove saved try-on
  Future<bool> removeTryOn(String productId) async {
    try {
      // Remove image file
      final imagePath = await _getImagePath(productId);
      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Remove from saved list
      final prefs = await SharedPreferences.getInstance();
      final savedTryOnsJson = prefs.getString(_savedTryOnsKey);
      if (savedTryOnsJson != null) {
        final savedTryOns = List<String>.from(jsonDecode(savedTryOnsJson));
        savedTryOns.remove(productId);
        await prefs.setString(_savedTryOnsKey, jsonEncode(savedTryOns));
      }

      return true;
    } catch (e) {
      print('Error removing try-on: $e');
      return false;
    }
  }

  /// Check if product has saved try-on
  Future<bool> hasSavedTryOn(String productId) async {
    try {
      final savedIds = await getSavedProductIds();
      return savedIds.contains(productId);
    } catch (e) {
      return false;
    }
  }

  /// Save image to cache directory
  Future<String?> _saveImageToCache(String productId, Uint8List imageBytes) async {
    try {
      final directory = await _getTryOnImagesDirectory();
      final file = File('${directory.path}/${productId}.png');
      await file.writeAsBytes(imageBytes);
      return file.path;
    } catch (e) {
      print('Error saving image to cache: $e');
      return null;
    }
  }

  /// Get image path for product ID
  Future<String?> _getImagePath(String productId) async {
    try {
      final directory = await _getTryOnImagesDirectory();
      return '${directory.path}/${productId}.png';
    } catch (e) {
      return null;
    }
  }

  /// Get or create try-on images directory
  Future<Directory> _getTryOnImagesDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final tryOnDir = Directory('${appDir.path}/$_tryOnImagesDir');
    
    if (!await tryOnDir.exists()) {
      await tryOnDir.create(recursive: true);
    }
    
    return tryOnDir;
  }

  /// Save try-on image with unique ID (for multiple try-ons per product)
  Future<bool> saveTryOnWithId(String tryOnId, Uint8List imageBytes) async {
    try {
      // Save image to local cache
      final imagePath = await _saveImageToCacheWithId(tryOnId, imageBytes);
      if (imagePath == null) return false;

      // Get existing saved try-on IDs
      final prefs = await SharedPreferences.getInstance();
      final savedTryOnIdsJson = prefs.getString(_savedTryOnIdsKey);
      final savedTryOnIds = savedTryOnIdsJson != null
          ? List<String>.from(jsonDecode(savedTryOnIdsJson))
          : <String>[];

      // Add try-on ID if not already saved
      if (!savedTryOnIds.contains(tryOnId)) {
        savedTryOnIds.add(tryOnId);
        await prefs.setString(_savedTryOnIdsKey, jsonEncode(savedTryOnIds));
      }

      // Also maintain backward compatibility: add product ID to old system
      final productId = extractProductIdFromTryOnId(tryOnId);
      if (productId != null) {
        final savedTryOnsJson = prefs.getString(_savedTryOnsKey);
        final savedTryOns = savedTryOnsJson != null
            ? List<String>.from(jsonDecode(savedTryOnsJson))
            : <String>[];
        
        if (!savedTryOns.contains(productId)) {
          savedTryOns.add(productId);
          await prefs.setString(_savedTryOnsKey, jsonEncode(savedTryOns));
        }
      }

      return true;
    } catch (e) {
      print('Error saving try-on with ID: $e');
      return false;
    }
  }

  /// Get try-on image by unique ID
  Future<Uint8List?> getTryOnImageById(String tryOnId) async {
    try {
      final imagePath = await _getImagePathById(tryOnId);
      if (imagePath == null || !await File(imagePath).exists()) {
        return null;
      }

      final file = File(imagePath);
      return await file.readAsBytes();
    } catch (e) {
      print('Error getting try-on image by ID: $e');
      return null;
    }
  }

  /// Remove saved try-on by unique ID
  Future<bool> removeTryOnById(String tryOnId) async {
    try {
      // Remove image file
      final imagePath = await _getImagePathById(tryOnId);
      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Remove from saved list
      final prefs = await SharedPreferences.getInstance();
      final savedTryOnIdsJson = prefs.getString(_savedTryOnIdsKey);
      if (savedTryOnIdsJson != null) {
        final savedTryOnIds = List<String>.from(jsonDecode(savedTryOnIdsJson));
        savedTryOnIds.remove(tryOnId);
        await prefs.setString(_savedTryOnIdsKey, jsonEncode(savedTryOnIds));
      }

      return true;
    } catch (e) {
      print('Error removing try-on by ID: $e');
      return false;
    }
  }

  /// Check if try-on ID is saved
  Future<bool> hasSavedTryOnId(String tryOnId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTryOnIdsJson = prefs.getString(_savedTryOnIdsKey);
      if (savedTryOnIdsJson == null) return false;

      final savedTryOnIds = List<String>.from(jsonDecode(savedTryOnIdsJson));
      return savedTryOnIds.contains(tryOnId);
    } catch (e) {
      return false;
    }
  }

  /// Get all saved try-on IDs for a product
  Future<List<String>> getSavedTryOnIdsForProduct(String productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTryOnIdsJson = prefs.getString(_savedTryOnIdsKey);
      if (savedTryOnIdsJson == null) return [];

      final savedTryOnIds = List<String>.from(jsonDecode(savedTryOnIdsJson));
      // Filter IDs that start with productId_
      return savedTryOnIds.where((id) => id.startsWith('${productId}_')).toList();
    } catch (e) {
      print('Error getting saved try-on IDs for product: $e');
      return [];
    }
  }

  /// Get all saved try-on IDs
  Future<List<String>> getAllSavedTryOnIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTryOnIdsJson = prefs.getString(_savedTryOnIdsKey);
      if (savedTryOnIdsJson == null) return [];

      return List<String>.from(jsonDecode(savedTryOnIdsJson));
    } catch (e) {
      print('Error getting all saved try-on IDs: $e');
      return [];
    }
  }

  /// Extract product ID from try-on ID (format: productId_timestamp_random)
  /// The timestamp is always numeric (milliseconds since epoch)
  /// The random is always 4 digits
  String? extractProductIdFromTryOnId(String tryOnId) {
    try {
      final parts = tryOnId.split('_');
      if (parts.length >= 3) {
        // Check if last part is 4 digits (random) and second-to-last is numeric (timestamp)
        final lastPart = parts.last;
        final secondLastPart = parts[parts.length - 2];
        
        // Check if last part is 4 digits and second-to-last is numeric
        if (lastPart.length == 4 && 
            int.tryParse(lastPart) != null && 
            int.tryParse(secondLastPart) != null) {
          // Remove the last two parts (timestamp and random) to get product ID
          return parts.sublist(0, parts.length - 2).join('_');
        }
      }
      // Fallback: if format is different, try to find product ID before first underscore
      final firstUnderscore = tryOnId.indexOf('_');
      if (firstUnderscore > 0) {
        return tryOnId.substring(0, firstUnderscore);
      }
      return null;
    } catch (e) {
      print('Error extracting product ID from try-on ID: $e');
      return null;
    }
  }

  /// Save image to cache directory with unique ID
  Future<String?> _saveImageToCacheWithId(String tryOnId, Uint8List imageBytes) async {
    try {
      final directory = await _getTryOnImagesDirectory();
      final file = File('${directory.path}/${tryOnId}.png');
      await file.writeAsBytes(imageBytes);
      return file.path;
    } catch (e) {
      print('Error saving image to cache with ID: $e');
      return null;
    }
  }

  /// Get image path for try-on ID
  Future<String?> _getImagePathById(String tryOnId) async {
    try {
      final directory = await _getTryOnImagesDirectory();
      return '${directory.path}/${tryOnId}.png';
    } catch (e) {
      return null;
    }
  }
}

