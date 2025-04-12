import 'package:closet_mate/app/modules/cart/controllers/cart_controller.dart';
import 'package:closet_mate/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:closet_mate/app/modules/home/controllers/home_controller.dart';
import 'package:closet_mate/app/modules/profile/controllers/profile_controller.dart';
import 'package:closet_mate/app/modules/search_products/controllers/search_products_controller.dart';
import 'package:closet_mate/app/modules/swipe_shopping/controllers/swipe_shopping_controller.dart';
import 'package:get/get.dart';
import '../controllers/base_controller.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BaseController>(() => BaseController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SwipeShoppingController>(() => SwipeShoppingController());
    Get.lazyPut<FavoritesController>(() => FavoritesController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<SearchProductsController>(() => SearchProductsController());
  }
}
