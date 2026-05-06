import 'package:get/get.dart';
import '../controllers/products_listing_controller.dart';

class ProductsListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductsListingController>(
      () => ProductsListingController(),
    );
  }
}
