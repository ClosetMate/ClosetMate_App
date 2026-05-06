import 'package:get/get.dart';
import '../controllers/tried_on_controller.dart';

class TriedOnBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TriedOnController>(() => TriedOnController());
  }
}

