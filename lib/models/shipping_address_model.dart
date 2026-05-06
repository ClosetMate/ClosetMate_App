class ShippingAddressModel {
  final String id;
  final String fullName;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phoneNumber;
  final bool isDefault;

  ShippingAddressModel({
    required this.id,
    required this.fullName,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.phoneNumber,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'street': street,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'phone_number': phoneNumber,
      'is_default': isDefault,
    };
  }

  factory ShippingAddressModel.fromMap(Map<String, dynamic> map) {
    return ShippingAddressModel(
      id: map['id'] ?? map['_id'] ?? '',
      fullName: map['full_name'] ?? map['fullName'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zip_code'] ?? map['zipCode'] ?? '',
      country: map['country'] ?? 'USA',
      phoneNumber: map['phone_number'] ?? map['phoneNumber'],
      isDefault: map['is_default'] ?? map['isDefault'] ?? false,
    );
  }

  ShippingAddressModel copyWith({
    String? id,
    String? fullName,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? phoneNumber,
    bool? isDefault,
  }) {
    return ShippingAddressModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get formattedAddress {
    return '$street, $city, $state $zipCode, $country';
  }
}


