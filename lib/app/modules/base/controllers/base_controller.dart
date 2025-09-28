import 'package:closet_mate/app/modules/cart/views/cart_view.dart';
import 'package:closet_mate/app/modules/favorites/views/favorites_view.dart';
import 'package:closet_mate/app/modules/home/views/home_view.dart';
import 'package:closet_mate/app/modules/profile/views/profile_view.dart';
import 'package:closet_mate/app/modules/swipe_shopping/views/swipe_shopping_view.dart';
import 'package:closet_mate/app/modules/cart/bindings/cart_binding.dart';
import 'package:closet_mate/app/modules/favorites/bindings/favorites_binding.dart';
import 'package:closet_mate/app/modules/home/bindings/home_binding.dart';
import 'package:closet_mate/app/modules/profile/bindings/profile_binding.dart';
import 'package:closet_mate/app/modules/swipe_shopping/bindings/swipe_shopping_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  // current screen index
  int currentTabIndex = 0;
  late List<Widget> pages;

  @override
  void onInit() async {
    super.onInit();
    
    // Initialize bindings for each page
    HomeBinding().dependencies();
    FavoritesBinding().dependencies();
    SwipeShoppingBinding().dependencies();
    CartBinding().dependencies();
    ProfileBinding().dependencies();
    
    pages = [
      const HomeView(),
      const FavoritesView(),
      const SwipeShoppingView(),
      const CartView(),
      const ProfileView(),
    ];
  }

  void onTabChange(int index) {
    currentTabIndex = index;
    update();
  }
}
