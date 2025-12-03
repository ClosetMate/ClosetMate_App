# Google Cloud Setup Guide for Virtual Try-On API

This guide will walk you through setting up Google Cloud to use the Vertex AI Virtual Try-On API in your Flutter app.

## Prerequisites

- A Google account
- Access to Google Cloud Console (https://console.cloud.google.com)

## Step 1: Create a Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Click on the project dropdown at the top of the page
3. Click **"New Project"**
4. Enter a project name (e.g., "ClosetMate-VirtualTryOn")
5. Select an organization (if applicable) or leave as "No organization"
6. Click **"Create"**
7. Wait for the project to be created (usually takes a few seconds)
8. Select your newly created project from the project dropdown

## Step 2: Enable Vertex AI API

1. In the Google Cloud Console, go to **"APIs & Services" > "Library"**
   - Or navigate directly: https://console.cloud.google.com/apis/library
2. Search for **"Vertex AI API"**
3. Click on **"Vertex AI API"** from the results
4. Click **"Enable"** button
5. Wait for the API to be enabled (may take a minute)

## Step 3: Enable Billing (Required)

⚠️ **Important**: Vertex AI API requires a billing account to be enabled.

1. Go to **"Billing"** in the left sidebar
   - Or navigate: https://console.cloud.google.com/billing
2. Click **"Link a billing account"** if you don't have one
3. Follow the prompts to set up billing
4. Link your billing account to the project

**Note**: Google Cloud offers a free trial with $300 credit for new users. Check current pricing for Vertex AI Virtual Try-On API.

## Step 4: Create a Service Account (Recommended for Mobile Apps)

Service accounts are the recommended way to authenticate from mobile applications.

### 4.1 Create Service Account

1. Go to **"IAM & Admin" > "Service Accounts"**
   - Or navigate: https://console.cloud.google.com/iam-admin/serviceaccounts
2. Click **"Create Service Account"**
3. Enter a service account name (e.g., "virtual-tryon-service")
4. Enter a description (optional): "Service account for Virtual Try-On API"
5. Click **"Create and Continue"**

### 4.2 Grant Permissions

1. In the "Grant this service account access to project" section:
   - Select role: **"Vertex AI User"** (or search for it)
   - You can also add **"Storage Object Viewer"** if you plan to use Cloud Storage
2. Click **"Continue"**
3. Click **"Done"** (skip optional step)

### 4.3 Create and Download Key

1. Click on the service account you just created
2. Go to the **"Keys"** tab
3. Click **"Add Key" > "Create new key"**
4. Select **"JSON"** format
5. Click **"Create"**
6. The JSON key file will be downloaded automatically
7. **⚠️ IMPORTANT**: Keep this file secure! Do not commit it to version control.

## Step 5: Get Your Project ID and Region

1. **Project ID**: 
   - Found in the project dropdown at the top of the console
   - Or go to **"IAM & Admin" > "Settings"**
   - The Project ID is displayed there

2. **Region**: 
   - Vertex AI Virtual Try-On API is available in specific regions
   - Common regions: `us-central1`, `us-east1`, `europe-west1`, `asia-southeast1`
   - Check the [Vertex AI locations documentation](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/locations) for the latest supported regions

## Step 6: Configure Your Flutter App

You have two options for authentication:

### Option A: Using Service Account Key (Recommended for Development)

1. Place the downloaded JSON key file in your project (e.g., `assets/config/service-account-key.json`)
2. **⚠️ IMPORTANT**: Add this file to `.gitignore` to prevent committing secrets
3. Read the file and pass it to the service:

```dart
// In your app initialization or config file
import 'dart:convert';
import 'package:flutter/services.dart';

Future<void> initializeGoogleCloud() async {
  // Load service account key
  final String serviceAccountJson = await rootBundle.loadString(
    'assets/config/service-account-key.json',
  );
  
  // Initialize the service
  await VirtualTryOnService().initialize(
    projectId: 'your-project-id',
    region: 'us-central1', // or your preferred region
    serviceAccountKey: serviceAccountJson,
  );
}
```

4. Update `pubspec.yaml` to include the asset:
```yaml
flutter:
  assets:
    - assets/config/service-account-key.json
```

### Option B: Using Access Token (Recommended for Production)

For production, it's better to use a backend service to handle authentication:

1. Create a backend endpoint that:
   - Authenticates with Google Cloud using the service account
   - Returns an access token
   - Handles token refresh

2. In your Flutter app, fetch the token from your backend:

```dart
// Fetch token from your backend
final String accessToken = await fetchAccessTokenFromBackend();

// Navigate to try-on with token
controller.navigateToTryOn(
  projectId: 'your-project-id',
  region: 'us-central1',
  accessToken: accessToken,
);
```

## Step 7: Test the Setup

1. Run your Flutter app
2. Navigate to a product details page
3. Click the "Try On" button
4. Select a photo
5. The app should call the Vertex AI API and display results

## Troubleshooting

### Error: "API not enabled"
- Make sure Vertex AI API is enabled in your project
- Wait a few minutes after enabling for propagation

### Error: "Permission denied"
- Check that your service account has "Vertex AI User" role
- Verify the service account key is correct

### Error: "Billing not enabled"
- Enable billing for your project
- Check that your billing account is active

### Error: "Invalid region"
- Verify the region supports Vertex AI Virtual Try-On API
- Check the [documentation](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/locations) for supported regions

## Security Best Practices

1. **Never commit service account keys to version control**
   - Add `*.json` keys to `.gitignore`
   - Use environment variables or secure storage for production

2. **Use backend authentication for production**
   - Don't embed service account keys in mobile apps
   - Create a backend service to handle authentication

3. **Restrict service account permissions**
   - Only grant necessary roles (Vertex AI User)
   - Use principle of least privilege

4. **Rotate keys regularly**
   - Create new keys periodically
   - Delete old unused keys

## Cost Considerations

- Vertex AI Virtual Try-On API is a paid service
- Check current pricing: https://cloud.google.com/vertex-ai/pricing
- Monitor usage in Google Cloud Console
- Set up billing alerts to avoid unexpected charges

## Additional Resources

- [Vertex AI Documentation](https://cloud.google.com/vertex-ai/docs)
- [Virtual Try-On API Reference](https://docs.cloud.google.com/vertex-ai/generative-ai/docs/model-reference/virtual-try-on-api)
- [Google Cloud Authentication Guide](https://cloud.google.com/docs/authentication)
- [Service Accounts Best Practices](https://cloud.google.com/iam/docs/best-practices-service-accounts)

