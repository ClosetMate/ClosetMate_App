import 'package:closet_mate/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {

  // get product details from arguments
  ProductModel product = Get.arguments;
  PageController pageController = PageController();

  // for the product size
  var selectedSize = 'M';

  /// when the user press on the favorite button
  onFavoriteButtonPressed() {
    // Get.find<BaseController>().onFavoriteButtonPressed(productId: product.productId!);
    update(['FavoriteButton']);
  }

  /// when the user press on add to cart button
  onAddToCartPressed() {
    // var mProduct = DummyHelper.products.firstWhere((p) => p.id == product.productId);
    // mProduct.quantity = mProduct.quantity! + 1;
    // mProduct.size = selectedSize;
    // Get.find<CartController>().getCartProducts();
    Get.back();
  }

  /// change the selected size
  changeSelectedSize(String size) {
    if (size == selectedSize) return;
    selectedSize = size;
    update(['Size']);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

}
