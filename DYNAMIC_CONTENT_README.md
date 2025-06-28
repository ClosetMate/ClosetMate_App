# Dynamic Content System for Closet Mate

This implementation allows you to update your app's content, layout, and features without requiring app store updates. The system uses mock data that simulates backend responses and remote configuration.

## 🚀 Features

- **Dynamic Layout**: Change section order, titles, and visibility
- **Dynamic Content**: Update products, deals, and promotional content
- **Feature Flags**: Enable/disable features remotely
- **Theme Customization**: Change colors and styling
- **Caching**: Efficient data caching with automatic expiration
- **Error Handling**: Graceful fallbacks and retry mechanisms
- **Loading States**: Smooth user experience during content loading

## 📁 File Structure

```
lib/
├── models/
│   └── dynamic_section.dart          # Dynamic section and layout models
├── app/
│   ├── data/
│   │   └── remote_config_data.dart   # Mock remote configuration and API responses
│   ├── services/
│   │   └── dynamic_content_service.dart # Content loading and caching service
│   ├── modules/home/
│   │   ├── controllers/
│   │   │   └── home_controller.dart  # Updated controller with dynamic content
│   │   └── views/
│   │       ├── home_view.dart        # Updated view with dynamic rendering
│   │       └── widgets/
│   │           ├── dynamic_section_widget.dart # Dynamic section renderer
│   │           ├── promotional_banner.dart     # New promotional banner widget
│   │           ├── trending_deals_carousel.dart # Updated with config support
│   │           ├── brands_section.dart         # Updated with config support
│   │           └── products_section.dart       # Updated with config support
└── utils/
    └── dynamic_content_demo.dart     # Demo utilities for testing
```

## 🔧 How It Works

### 1. Remote Configuration
The system starts with a remote configuration that defines:
- Which sections to show
- Section order and titles
- Feature flags
- Theme settings

### 2. Dynamic Content Loading
Each section loads its content from mock API responses:
- Trending deals
- Product categories
- Featured brands
- Promotional banners

### 3. Caching
Content is cached for 5 minutes to improve performance and reduce API calls.

### 4. Dynamic Rendering
The `DynamicSectionWidget` renders different content types based on configuration.

## 🎯 Usage Examples

### Testing Different Scenarios

```dart
import 'package:closet_mate/app/utils/dynamic_content_demo.dart';

// 1. Enable holiday mode
DynamicContentDemo.enableHolidayMode();

// 2. Enable flash sale
DynamicContentDemo.enableFlashSale();

// 3. Launch new collection
DynamicContentDemo.enableNewCollection();

// 4. Disable certain sections
DynamicContentDemo.disableSections(['brands', 'promotional_banner']);

// 5. Change theme colors
DynamicContentDemo.changeTheme('#4ECDC4', '#45B7D1');

// 6. Toggle features
DynamicContentDemo.toggleFeatures({
  'enable_search': false,
  'enable_filters': true,
});
```

### Refreshing Content

```dart
// In your controller
await controller.refreshContent();

// Or pull-to-refresh in the UI
RefreshIndicator(
  onRefresh: controller.refreshContent,
  child: YourWidget(),
)
```

## 🔄 Migration to Real Backend

### 1. Replace Mock Data with Real APIs

```dart
// In dynamic_content_service.dart
Future<HomeLayout> getHomeLayout() async {
  // Replace this:
  // final config = mockRemoteConfig['home_layout'];
  
  // With this:
  final response = await http.get(Uri.parse('$baseUrl/api/config/home-layout'));
  final config = jsonDecode(response.body);
  return HomeLayout.fromConfig(config);
}
```

### 2. Add Firebase Remote Config

```dart
// Add to pubspec.yaml
dependencies:
  firebase_remote_config: ^4.3.8

// In your service
import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<HomeLayout> getHomeLayout() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.fetchAndActivate();
  
  final configString = remoteConfig.getString('home_layout');
  final config = jsonDecode(configString);
  return HomeLayout.fromConfig(config);
}
```

### 3. Add Real-time Updates

```dart
// Using Firebase Realtime Database or WebSockets
Stream<Map<String, dynamic>> getRealTimeUpdates() {
  return FirebaseDatabase.instance
      .ref('content_updates')
      .onValue
      .map((event) => event.snapshot.value as Map<String, dynamic>);
}
```

## 🎨 Customization

### Adding New Section Types

1. **Update the model**:
```dart
// In dynamic_section.dart
enum SectionType {
  trending_deals,
  brands,
  products,
  promotional_banner,
  video_section, // New type
}
```

2. **Add to DynamicSectionWidget**:
```dart
case 'video_section':
  return _buildVideoSection();
```

3. **Create the widget**:
```dart
Widget _buildVideoSection() {
  return VideoSection(
    videos: videos,
    title: section.title,
    config: section.config,
  );
}
```

### Adding New Content Types

1. **Update the service**:
```dart
Future<List<VideoModel>> getVideos() async {
  // Implementation
}
```

2. **Update the controller**:
```dart
final RxList<VideoModel> videos = <VideoModel>[].obs;
```

3. **Update the view**:
```dart
case 'video_section':
  return DynamicSectionWidget(
    section: section,
    videos: controller.videos,
  );
```

## 🚀 Benefits

1. **No App Store Updates**: Change content instantly
2. **A/B Testing**: Test different layouts and content
3. **Event-Driven**: Update for holidays, sales, trends
4. **Personalization**: Show different content based on user behavior
5. **Scalability**: Handle large product catalogs efficiently
6. **Analytics**: Track which content performs better

## 🔍 Testing

The system includes comprehensive testing utilities:

- **Mock Data**: Realistic test scenarios
- **Demo Functions**: Easy testing of different configurations
- **Error Handling**: Test error scenarios
- **Loading States**: Test loading and refresh functionality

## 📱 Next Steps

1. **Implement Real APIs**: Replace mock data with actual backend calls
2. **Add Firebase**: Integrate Firebase Remote Config and Realtime Database
3. **Add Analytics**: Track content performance
4. **Add Personalization**: User-specific content recommendations
5. **Add Offline Support**: Cache content for offline viewing
6. **Add Push Notifications**: Notify users of content updates

## 🛠️ Troubleshooting

### Common Issues

1. **Content not loading**: Check network connectivity and API endpoints
2. **Cache issues**: Clear cache using `_contentService.clearCache()`
3. **Layout not updating**: Ensure remote config is properly fetched
4. **Performance issues**: Optimize image loading and reduce API calls

### Debug Mode

Enable debug logging by adding:
```dart
print('Loading content: ${section.type}');
print('Cache status: ${_isCacheValid(key)}');
```

This dynamic content system provides a solid foundation for building a flexible, scalable shopping app that can adapt to changing business needs without requiring frequent app updates. 