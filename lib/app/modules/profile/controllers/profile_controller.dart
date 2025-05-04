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
}
