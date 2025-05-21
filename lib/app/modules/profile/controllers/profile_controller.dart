import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  late String userName = '';
  late String userEmail = '';
  @override
  void onInit() {
    super.onInit();
    userName = 'Vinay Varma';
    userEmail = 'vinayvarma@gmail.com';
  }

  void logout() {
    // Implement logout functionality here
    Get.offNamed(Routes.LOGIN);
  }
}
