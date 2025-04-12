import 'package:closet_mate/app/modules/cart/views/cart_view.dart';
import 'package:closet_mate/app/modules/favorites/views/favorites_view.dart';
import 'package:closet_mate/app/modules/home/views/home_view.dart';
import 'package:closet_mate/app/modules/profile/views/profile_view.dart';
import 'package:closet_mate/app/modules/search_products/views/search_products_view.dart';
import 'package:closet_mate/app/modules/swipe_shopping/views/swipe_shopping_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class BaseController extends GetxController {
  // current screen index
  int currentTabIndex = 0;
  late List<Widget> pages;

  @override
  void onInit() async {
    super.onInit();
    pages = [
      HomeView(),
      FavoritesView(),
      SwipeShoppingView(),
      CartView(),
      ProfileView(),
      SearchProductsView()
    ]; // Add swipePage to the list
  }

  void onTabChange(int index) {
    currentTabIndex = index;
    update();
  }
}
