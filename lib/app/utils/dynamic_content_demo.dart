// Demo utility to test dynamic content functionality
// This shows how you can modify content without app updates

import 'package:closet_mate/app/data/remote_config_data.dart';

class DynamicContentDemo {
  // Example: Change home layout for a special event
  static void enableHolidayMode() {
    // Modify the mock remote config to simulate holiday layout
    mockRemoteConfig['home_layout']['sections'][0]['title'] = '🎄 Holiday Deals';
    mockRemoteConfig['home_layout']['sections'][0]['config']['auto_play'] = false;
    
    // Add a promotional banner
    mockRemoteConfig['home_layout']['sections'].add({
      "type": "promotional_banner",
      "title": "🎉 Holiday Special",
      "enabled": true,
      "order": 1,
      "config": {
        "banner_text": "🎄 50% OFF Holiday Collection!",
        "banner_color": "#FF6B6B",
        "action_url": "/holiday-sale"
      }
    });
    
    // Reorder sections
    mockRemoteConfig['home_layout']['sections'].forEach((section) {
      if (section['type'] == 'brands') {
        section['order'] = 3;
      }
    });
  }

  // Example: Change content for a flash sale
  static void enableFlashSale() {
    // Update trending deals with flash sale items
    mockTrendingDeals['data'][0]['currentPrice'] = 5; // 75% discount
    mockTrendingDeals['data'][0]['discount_percentage'] = 75;
    
    // Add flash sale banner
    mockRemoteConfig['home_layout']['sections'].insert(0, {
      "type": "promotional_banner",
      "title": "⚡ Flash Sale",
      "enabled": true,
      "order": 0,
      "config": {
        "banner_text": "⚡ FLASH SALE - 75% OFF - Ends in 2 hours!",
        "banner_color": "#FF4757",
        "action_url": "/flash-sale"
      }
    });
  }

  // Example: Change content for a new collection launch
  static void enableNewCollection() {
    // Update section titles
    mockRemoteConfig['home_layout']['sections'][3]['title'] = '🆕 Spring Collection';
    mockRemoteConfig['home_layout']['sections'][4]['title'] = '🔥 Trending Now';
    
    // Update new arrivals with spring collection
    mockNewArrivals['data'][0]['name'] = 'Spring Floral Dress';
    mockNewArrivals['data'][0]['description'] = 'Beautiful spring floral pattern dress';
    mockNewArrivals['data'][0]['is_new'] = true;
    mockNewArrivals['data'][0]['arrival_date'] = '2024-03-15';
  }

  // Example: Disable certain sections
  static void disableSections(List<String> sectionTypes) {
    for (var section in mockRemoteConfig['home_layout']['sections']) {
      if (sectionTypes.contains(section['type'])) {
        section['enabled'] = false;
      }
    }
  }

  // Example: Change theme colors
  static void changeTheme(String primaryColor, String secondaryColor) {
    mockRemoteConfig['home_layout']['theme']['primary_color'] = primaryColor;
    mockRemoteConfig['home_layout']['theme']['secondary_color'] = secondaryColor;
  }

  // Example: Enable/disable features
  static void toggleFeatures(Map<String, bool> features) {
    features.forEach((feature, enabled) {
      mockRemoteConfig['home_layout']['features'][feature] = enabled;
    });
  }

  // Reset to default configuration
  static void resetToDefault() {
    // This would reload the original configuration
    // In a real app, this would fetch from remote config
    print('Reset to default configuration');
  }
}

// Usage examples:
/*
// For testing different scenarios:

// 1. Holiday mode
DynamicContentDemo.enableHolidayMode();

// 2. Flash sale
DynamicContentDemo.enableFlashSale();

// 3. New collection launch
DynamicContentDemo.enableNewCollection();

// 4. Disable certain sections
DynamicContentDemo.disableSections(['brands', 'promotional_banner']);

// 5. Change theme
DynamicContentDemo.changeTheme('#4ECDC4', '#45B7D1');

// 6. Toggle features
DynamicContentDemo.toggleFeatures({
  'enable_search': false,
  'enable_filters': true,
});

// 7. Reset
DynamicContentDemo.resetToDefault();
*/ 