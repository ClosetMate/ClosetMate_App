import 'package:get/get.dart';

import '../controllers/search_products_controller.dart';

class SearchProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchProductsController>(
      () => SearchProductsController(),
    );
  }
}
