import 'package:get/get.dart';
import '../controllers/user_measurements_controller.dart';

class UserMeasurementsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserMeasurementsController>(
      () => UserMeasurementsController(),
      fenix: true,
    );
  }
}
