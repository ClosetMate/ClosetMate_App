import 'package:get/get.dart';
import 'package:closet_mate/config/theme/my_theme.dart';

class SettingsController extends GetxController {

  @override
  void onInit() {
    super.onInit();
  }

  onThemeChange(bool isLight){
    MyTheme.changeTheme(isLight);
    update();
  }
}
