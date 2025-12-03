import 'package:flutter/services.dart';
import 'package:closet_mate/app/services/virtual_tryon_service.dart';
import 'package:closet_mate/config/google_cloud_config.dart';

/// Service to initialize Google Cloud services
class GoogleCloudInitializer {
  static bool _initialized = false;
  static String? _lastError;

  /// Initialize Google Cloud services
  /// Returns true if initialization was successful, false otherwise
  static Future<bool> initialize() async {
    if (!GoogleCloudConfig.enabled) {
      print('Google Cloud Virtual Try-On is disabled in config');
      return false;
    }

    if (_initialized) {
      print('Google Cloud already initialized');
      return true;
    }

    try {
      // Load service account key
      final String serviceAccountJson = await rootBundle.loadString(
        GoogleCloudConfig.serviceAccountKeyPath,
      );

      // Initialize the Virtual Try-On service
      await VirtualTryOnService().initialize(
        projectId: GoogleCloudConfig.projectId,
        region: GoogleCloudConfig.region,
        serviceAccountKey: serviceAccountJson,
      );

      _initialized = true;
      _lastError = null;
      print('✅ Google Cloud initialized successfully');
      print('   Project ID: ${GoogleCloudConfig.projectId}');
      print('   Region: ${GoogleCloudConfig.region}');
      return true;
    } on PlatformException catch (e) {
      _lastError = 'Platform error: ${e.message}';
      print('❌ Error initializing Google Cloud: $_lastError');
      print('   Make sure the service account key file exists at: ${GoogleCloudConfig.serviceAccountKeyPath}');
      return false;
    } catch (e) {
      _lastError = e.toString();
      print('❌ Error initializing Google Cloud: $_lastError');
      print('   Check your service account key and configuration');
      return false;
    }
  }

  /// Check if Google Cloud is initialized
  static bool get isInitialized => _initialized;

  /// Get the last error message (if any)
  static String? get lastError => _lastError;

  /// Reset initialization state (useful for testing)
  static void reset() {
    _initialized = false;
    _lastError = null;
  }
}

