import 'package:get/get.dart';

import '../controllers/swipe_shopping_controller.dart';

class SwipeShoppingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SwipeShoppingController>(
      () => SwipeShoppingController(),
    );
  }
}
