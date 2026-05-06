# Quick Integration Example

This file shows how to integrate Google Cloud credentials into your app after completing the setup.

## Option 1: Using Service Account Key (Development)

### Step 1: Add the key file to assets

1. Create a directory: `assets/config/`
2. Place your `service-account-key.json` file there
3. Update `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/config/service-account-key.json
```

### Step 2: Create a configuration file

Create `lib/config/google_cloud_config.dart`:

```dart
class GoogleCloudConfig {
  // Replace with your actual values
  static const String projectId = 'your-project-id';
  static const String region = 'us-central1'; // e.g., us-central1, us-east1
  
  // For development: path to service account key
  static const String serviceAccountKeyPath = 'assets/config/service-account-key.json';
  
  // For production: backend endpoint that returns access token
  static const String? backendTokenEndpoint = null; // e.g., 'https://your-api.com/auth/token'
}
```

### Step 3: Initialize in your app

Update `lib/main.dart` or create an initialization service:

```dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:closet_mate/app/services/virtual_tryon_service.dart';
import 'package:closet_mate/config/google_cloud_config.dart';

Future<void> initializeGoogleCloud() async {
  try {
    // Load service account key
    final String serviceAccountJson = await rootBundle.loadString(
      GoogleCloudConfig.serviceAccountKeyPath,
    );
    
    // Initialize the service
    await VirtualTryOnService().initialize(
      projectId: GoogleCloudConfig.projectId,
      region: GoogleCloudConfig.region,
      serviceAccountKey: serviceAccountJson,
    );
    
    print('Google Cloud initialized successfully');
  } catch (e) {
    print('Error initializing Google Cloud: $e');
    // Handle error - maybe show a warning or disable try-on feature
  }
}
```

### Step 4: Call initialization in main()

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPref.init();
  
  // Initialize Google Cloud
  await initializeGoogleCloud();
  
  // Initialize the dynamic color controller
  Get.put(DynamicColorController());
  
  runApp(/* ... */);
}
```

### Step 5: Update product details controller

The `navigateToTryOn()` method can now be called without parameters if you've initialized globally:

```dart
// In cm_product_details_view.dart, the button already calls:
controller.navigateToTryOn()

// The controller will use the globally initialized service
```

Or you can pass credentials explicitly:

```dart
controller.navigateToTryOn(
  projectId: GoogleCloudConfig.projectId,
  region: GoogleCloudConfig.region,
);
```

## Option 2: Using Backend Token (Production)

### Step 1: Create backend endpoint

Your backend should have an endpoint that:
1. Authenticates with Google Cloud using service account
2. Returns an access token
3. Handles token refresh

Example Node.js endpoint:
```javascript
// Backend endpoint: GET /api/auth/google-cloud-token
app.get('/api/auth/google-cloud-token', async (req, res) => {
  const { GoogleAuth } = require('google-auth-library');
  const auth = new GoogleAuth({
    keyFile: 'path/to/service-account-key.json',
    scopes: ['https://www.googleapis.com/auth/cloud-platform'],
  });
  
  const client = await auth.getClient();
  const accessToken = await client.getAccessToken();
  
  res.json({ accessToken: accessToken.token });
});
```

### Step 2: Fetch token in Flutter

Create `lib/services/auth_service.dart`:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static Future<String?> getGoogleCloudToken() async {
    try {
      final response = await http.get(
        Uri.parse('https://your-api.com/api/auth/google-cloud-token'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['accessToken'] as String?;
      }
      return null;
    } catch (e) {
      print('Error fetching token: $e');
      return null;
    }
  }
}
```

### Step 3: Use token when navigating

```dart
// In cm_product_details_controller.dart, update navigateToTryOn:
void navigateToTryOn() async {
  if (product.value == null) {
    Get.snackbar('Error', 'Product information is not available');
    return;
  }

  // Fetch token from backend
  final accessToken = await AuthService.getGoogleCloudToken();
  
  if (accessToken == null) {
    Get.snackbar('Error', 'Failed to authenticate with Google Cloud');
    return;
  }

  Get.toNamed(
    Routes.VIRTUAL_TRYON,
    arguments: {
      'product': product.value,
      'projectId': GoogleCloudConfig.projectId,
      'region': GoogleCloudConfig.region,
      'accessToken': accessToken,
    },
  );
}
```

## Option 3: Environment Variables (Recommended for CI/CD)

### Step 1: Use environment variables

Create `lib/config/google_cloud_config.dart`:

```dart
class GoogleCloudConfig {
  // Read from environment variables or use defaults
  static String get projectId => 
    const String.fromEnvironment('GOOGLE_CLOUD_PROJECT_ID', defaultValue: 'your-project-id');
  
  static String get region => 
    const String.fromEnvironment('GOOGLE_CLOUD_REGION', defaultValue: 'us-central1');
  
  // For service account key, you can read from environment variable
  // or use a secure storage solution
}
```

### Step 2: Set environment variables

For development, create a `.env` file (use `flutter_dotenv` package):
```
GOOGLE_CLOUD_PROJECT_ID=your-project-id
GOOGLE_CLOUD_REGION=us-central1
```

For CI/CD, set environment variables in your build system.

## Testing

After integration, test the flow:

1. Run the app
2. Navigate to a product details page
3. Click "Try On" button
4. Select a photo from camera or gallery
5. Wait for the API call to complete
6. Verify the try-on result is displayed

## Troubleshooting

- **"Service not initialized"**: Make sure `initializeGoogleCloud()` is called before using the feature
- **"No access token"**: Check that authentication is set up correctly
- **"Invalid project ID"**: Verify the project ID matches your Google Cloud project
- **"Region not supported"**: Check that your region supports Vertex AI Virtual Try-On API

