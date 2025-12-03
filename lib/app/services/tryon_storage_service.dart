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
}

