/// Google Cloud configuration for Virtual Try-On API
class GoogleCloudConfig {
  // Project ID from your Google Cloud project
  static const String projectId = 'closet-mate-478014';
  
  // Region for Vertex AI API (e.g., us-central1, us-east1, europe-west1)
  // Check supported regions: https://cloud.google.com/vertex-ai/generative-ai/docs/learn/locations
  static const String region = 'us-central1';
  
  // Path to service account key file in assets
  static const String serviceAccountKeyPath = 'assets/config/service-account-key.json';
  
  // Optional: Backend endpoint for fetching access tokens (for production)
  // Set this if you want to use a backend service instead of embedding the key
  static const String? backendTokenEndpoint = null;
  
  // Enable/disable Virtual Try-On feature
  static const bool enabled = true;
}

