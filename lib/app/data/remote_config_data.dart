// Mock Remote Configuration Data
// This simulates what you would get from Firebase Remote Config or a backend API
import 'package:closet_mate/app/data/products_data.dart';

Map<String, dynamic> mockRemoteConfig = {
  "home_layout": {
    "sections": [
      {
        "type": "trending_deals",
        "title": "Must-Grab Offers",
        "enabled": true,
        "order": 1,
        "config": {
          "show_timer": true,
          "auto_play": true,
          "items_to_show": 5
        }
      },
      {
        "type": "promotional_banner",
        "title": "Flash Deals",
        "enabled": true,
        "order": 2,
        "config": {
          "banner_text": "50% OFF on all items!",
          "banner_color": "#FF6B6B",
          "action_url": "/sale"
        }
      },
      {
        "type": "brands",
        "title": "Most-Loved Labels",
        "enabled": true,
        "order": 3,
        "config": {
          "show_brand_names": true,
          "brands_to_show": 6
        }
      },
      {
        "type": "products",
        "title": "Chart Toppers",
        "enabled": true,
        "order": 4,
        "config": {
          "category": "top_selling",
          "items_to_show": 10,
          "show_view_all": true
        }
      },
      {
        "type": "products",
        "title": "New in Stocks",
        "enabled": true,
        "order": 5,
        "config": {
          "category": "new_arrivals",
          "items_to_show": 8,
          "show_view_all": true
        }
      },
      {
        "type": "products",
        "title": "Handpicked for You",
        "enabled": true,
        "order": 6,
        "config": {
          "category": "recommended",
          "items_to_show": 6,
          "show_view_all": true
        }
      },
    ],
    "theme": {
      // "primary_color": "#FF6B6B",
      // "secondary_color": "#4ECDC4",
      // "background_color": "#F7F7F7",
      "primary_color": "#B13BFF",
      "secondary_color": "#471396",
      "background_color": "#B13BFF"
    },
    "features": {
      "enable_search": true,
      "enable_filters": true,
      "enable_wishlist": true,
      "enable_quick_view": true
    }
  }
};

// Mock API responses for different content types
Map<String, dynamic> mockTrendingDeals = {
  "status": "success",
  "data": getShuffledProducts()
};

Map<String, dynamic> mockTopSellingProducts = {
  "status": "success",
  "data": getShuffledProducts()
};

Map<String, dynamic> mockNewArrivals = {
  "status": "success",
  "data": getShuffledProducts()
};

Map<String, dynamic> mockRecommendedProducts = {
  "status": "success",
  "data": getShuffledProducts()
};

Map<String, dynamic> mockFeaturedBrands = {
  "status": "success",
  "data": [
    {
      "name": "Nike",
      "logoUrl": "assets/images/brands/nike.webp",
      "is_featured": true,
      "product_count": 150
    },
    {
      "name": "Adidas",
      "logoUrl": "assets/images/brands/adidas.jpg",
      "is_featured": true,
      "product_count": 120
    },
    {
      "name": "Puma",
      "logoUrl": "assets/images/brands/puma.png",
      "is_featured": true,
      "product_count": 80
    },
    {
      "name": "Zara",
      "logoUrl": "assets/images/brands/zara.jpg",
      "is_featured": true,
      "product_count": 200
    },
    {
      "name": "H&M",
      "logoUrl": "assets/images/brands/h&m.jpg",
      "is_featured": true,
      "product_count": 180
    },
    {
      "name": "Gucci",
      "logoUrl": "assets/images/brands/gucci.png",
      "is_featured": true,
      "product_count": 50
    }
  ]
}; 