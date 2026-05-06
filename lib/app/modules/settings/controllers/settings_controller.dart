import 'package:get/get.dart';
import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:closet_mate/config/theme/my_theme.dart';

class SettingsController extends GetxController {


  onThemeChange(bool isLight){
    MyTheme.changeTheme(isLight);
    update();
  }

  void navigateToMeasurements() {
    Get.toNamed(Routes.USER_MEASUREMENTS, arguments: {'isUpdate': true});
  }
}
