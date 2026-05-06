import 'package:get/get.dart';

import '../controllers/shipping_addresses_controller.dart';

class ShippingAddressesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShippingAddressesController>(
      () => ShippingAddressesController(),
    );
  }
}


