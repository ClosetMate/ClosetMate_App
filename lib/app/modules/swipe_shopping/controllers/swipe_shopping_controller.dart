import 'package:closet_mate/app/components/product_detail_card.dart';
import 'package:closet_mate/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:closet_mate/app/data/products_data.dart';

class SwipeShoppingController extends GetxController {
  List<ProductDetailCard> productCards = [];
  List<ProductModel> products = [];
  Map<String, dynamic> swipeAction = {'opacity': 0.0};
  AxisDirection direction = AxisDirection.down;

  @override
  void onInit() {
    super.onInit();
    _getProducts();
  }

  void _getProducts() {
    for (Map<String, dynamic> productMap in productsData) {
      products.add(ProductModel.fromMap(productMap));
    }
    _loadCards();
  }

  void _loadCards() {
    for (ProductModel product in products) {
      productCards.add(ProductDetailCard(product: product));
    }
  }

}
