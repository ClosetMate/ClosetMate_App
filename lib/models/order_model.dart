class OrderModel {
  final String id;
  final String orderNumber;
  final List<OrderItem> items;
  final double totalAmount;
  final String currency;
  final String status; // pending, processing, shipped, delivered, cancelled
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final ShippingAddress? shippingAddress;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    this.shippingAddress,
  });

  // Convert OrderModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_number': orderNumber,
      'items': items.map((item) => item.toMap()).toList(),
      'total_amount': totalAmount,
      'currency': currency,
      'status': status,
      'order_date': orderDate.toIso8601String(),
      'delivery_date': deliveryDate?.toIso8601String(),
      'shipping_address': shippingAddress?.toMap(),
    };
  }

  // Create OrderModel from Map
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? map['_id'] ?? '',
      orderNumber: map['order_number'] ?? map['orderNumber'] ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item))
              .toList() ??
          [],
      totalAmount: (map['total_amount'] ?? map['totalAmount'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'USD',
      status: map['status'] ?? 'pending',
      orderDate: map['order_date'] != null || map['orderDate'] != null
          ? DateTime.parse(map['order_date'] ?? map['orderDate'])
          : DateTime.now(),
      deliveryDate: map['delivery_date'] != null || map['deliveryDate'] != null
          ? DateTime.parse(map['delivery_date'] ?? map['deliveryDate'])
          : null,
      shippingAddress: map['shipping_address'] != null || map['shippingAddress'] != null
          ? ShippingAddress.fromMap(
              map['shipping_address'] ?? map['shippingAddress'])
          : null,
    );
  }

  // Get status color
  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;
  final String? size;
  final String? color;

  OrderItem({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
    this.size,
    this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'price': price,
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['product_id'] ?? map['productId'] ?? '',
      productName: map['product_name'] ?? map['productName'] ?? '',
      productImage: map['product_image'] ?? map['productImage'],
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      size: map['size'],
      color: map['color'],
    );
  }

  double get subtotal => price * quantity;
}

class ShippingAddress {
  final String fullName;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phoneNumber;

  ShippingAddress({
    required this.fullName,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'street': street,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'phone_number': phoneNumber,
    };
  }

  factory ShippingAddress.fromMap(Map<String, dynamic> map) {
    return ShippingAddress(
      fullName: map['full_name'] ?? map['fullName'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zip_code'] ?? map['zipCode'] ?? '',
      country: map['country'] ?? 'USA',
      phoneNumber: map['phone_number'] ?? map['phoneNumber'],
    );
  }

  String get formattedAddress {
    return '$street, $city, $state $zipCode, $country';
  }
}

