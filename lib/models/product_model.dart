class ProductModel {
  final int productId;
  final String name;
  final String description;
  final double price;
  final double currentPrice;
  final String currency;
  final String imageUrl;
  final List<String> otherImageUrls;
  final int stock;
  final String category;
  final bool isFavorite;
  final bool isCart;
  final bool isSwiped;
  final bool isSwipedLeft;
  final bool isSwipedRight;
  final bool isSwipedUp;
  final bool isSwipedDown;
  final double rating;
  final String reviews;
  final int quantity;

  ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.currentPrice,
    required this.currency,
    required this.imageUrl,
    required this.otherImageUrls,
    required this.stock,
    required this.category,
    required this.isFavorite,
    required this.isCart,
    required this.isSwiped,
    required this.isSwipedLeft,
    required this.isSwipedRight,
    required this.isSwipedUp,
    required this.isSwipedDown,
    required this.rating,
    required this.reviews,
    required this.quantity,
  });

  // Convert a ProductModel object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': productId,
      'name': name,
      'description': description,
      'price': price,
      'currentPrice': currentPrice,
      'currency': currency,
      'imageUrl': imageUrl,
      'otherImageUrls': otherImageUrls,
      'stock': stock,
      'category': category,
      'isFavorite': isFavorite,
      'isCart': isCart,
      'isSwiped': isSwiped,
      'isSwipedLeft': isSwipedLeft,
      'isSwipedRight': isSwipedRight,
      'isSwipedUp': isSwipedUp,
      'isSwipedDown': isSwipedDown,
      'rating': rating,
      'reviews': reviews,
      'quantity': quantity,
    };
  }

  // Create a ProductModel object from a Map
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['product_id'],
      name: map['name'],
      description: map['description'],
      price: map['price'].toDouble(),
      currentPrice: map['currentPrice'].toDouble(),
      currency: map['currency'],
      imageUrl: map['imageUrl'],
      otherImageUrls: map['otherImageUrls'],
      stock: map['stock'],
      category: map['category'],
      isFavorite: map['isFavorite'] ?? false,
      isCart: map['isCart'] ?? false,
      isSwiped: map['isSwiped'] ?? false,
      isSwipedLeft: map['isSwipedLeft'] ?? false,
      isSwipedRight: map['isSwipedRight'] ?? false,
      isSwipedUp: map['isSwipedUp'] ?? false,
      isSwipedDown: map['isSwipedDown'] ?? false,
      rating: map['rating']?.toDouble() ?? 0.0,
      reviews: map['reviews']?.toString() ?? '0',
      quantity: map['quantity'] ?? 0,
    );
  }
}