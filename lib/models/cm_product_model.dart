class CmProductModel {
  final String name;
  final String description;
  final String brand;
  final double price;
  final String currency;
  final List<String> images;
  final List<ProductVariant> variants;
  final List<String> tags;
  final String id;
  final String createdAt;
  final String updatedAt;

  CmProductModel({
    required this.name,
    required this.description,
    required this.brand,
    required this.price,
    required this.currency,
    required this.images,
    required this.variants,
    required this.tags,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert a CmProductModel object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'brand': brand,
      'price': price,
      'currency': currency,
      'images': images,
      'variants': variants.map((variant) => variant.toMap()).toList(),
      'tags': tags,
      '_id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Create a CmProductModel object from a Map
  factory CmProductModel.fromMap(Map<String, dynamic> map) {
    return CmProductModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      brand: map['brand'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'USD',
      images: List<String>.from(map['images'] ?? []),
      variants: (map['variants'] as List<dynamic>?)
          ?.map((variant) => ProductVariant.fromMap(variant))
          .toList() ?? [],
      tags: List<String>.from(map['tags'] ?? []),
      id: map['_id'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  // Helper method to get total stock across all variants
  int get totalStock {
    return variants.fold(0, (sum, variant) => sum + variant.stock);
  }

  // Helper method to get available sizes
  List<String> get availableSizes {
    return variants.map((variant) => variant.size).toList();
  }

  // Helper method to get available colors
  List<String> get availableColors {
    return variants.map((variant) => variant.color).toSet().toList();
  }

  // Helper method to get main image (first image)
  String get mainImage {
    return images.isNotEmpty ? images.first : '';
  }
}

class ProductVariant {
  final String color;
  final String size;
  final String sku;
  final int stock;

  ProductVariant({
    required this.color,
    required this.size,
    required this.sku,
    required this.stock,
  });

  // Convert a ProductVariant object to a Map
  Map<String, dynamic> toMap() {
    return {
      'color': color,
      'size': size,
      'sku': sku,
      'stock': stock,
    };
  }

  // Create a ProductVariant object from a Map
  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      color: map['color'] ?? '',
      size: map['size'] ?? '',
      sku: map['sku'] ?? '',
      stock: map['stock'] ?? 0,
    );
  }
}
