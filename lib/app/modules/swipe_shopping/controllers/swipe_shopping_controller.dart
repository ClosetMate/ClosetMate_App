import 'package:closet_mate/app/components/product_detail_card.dart';
import 'package:closet_mate/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:closet_mate/app/data/products_data.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:closet_mate/config/theme/colors.dart';

class SwipeShoppingController extends GetxController {
  List<ProductDetailCard> productCards = [];
  List<ProductModel> products = [];
  Map<String, dynamic> swipeAction = {'opacity': 0.0};
  AxisDirection direction = AxisDirection.down;
  AppinioSwiperController? swiperController;

  @override
  void onInit() {
    super.onInit();
    swiperController = AppinioSwiperController();
    _getProducts();
  }

  @override
  void onClose() {
    swiperController?.dispose();
    super.onClose();
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

  void _showSwipeFeedback(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.left:
        swipeAction = {
          'top': Get.height / 3,
          'left': 10.0,
          'right': null,
          'color': ColorConstants.close,
          'icon': Icons.close,
          'opacity': 0.0,
        };
        break;
      case AxisDirection.right:
        swipeAction = {
          'top': Get.height / 3,
          'left': null,
          'right': 10.0,
          'color': ColorConstants.favorite,
          'icon': Icons.favorite,
          'opacity': 0.0,
        };
        break;
      case AxisDirection.up:
        swipeAction = {
          'top': 60.0,
          'left': 10.0,
          'right': 10.0,
          'color': ColorConstants.brightGreen,
          'icon': Icons.shopping_cart,
          'opacity': 0.0,
        };
        break;
      default:
        swipeAction = {'opacity': 0.0};
    }
    update();

    // Animate the feedback icon
    Future.delayed(const Duration(milliseconds: 50), () {
      swipeAction['opacity'] = 1.0;
      update();
    });

    // Reset the feedback after animation
    Future.delayed(const Duration(milliseconds: 300), () {
      swipeAction['opacity'] = 0.0;
      update();
    });
  }

  void swipeCard(AxisDirection direction) {
    _showSwipeFeedback(direction);
    switch (direction) {
      case AxisDirection.left:
        swiperController?.swipeLeft();
        break;
      case AxisDirection.right:
        swiperController?.swipeRight();
        break;
      case AxisDirection.up:
        swiperController?.swipeUp();
        break;
      default:
        break;
    }
  }
}
