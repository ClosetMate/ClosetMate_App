import 'package:get/get.dart';
import '../controllers/virtual_tryon_controller.dart';

class VirtualTryOnBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VirtualTryOnController>(() => VirtualTryOnController());
  }
}

