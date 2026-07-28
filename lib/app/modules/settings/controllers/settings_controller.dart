import 'package:get/get.dart';
import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:closet_mate/config/theme/my_theme.dart';
import 'package:closet_mate/app/modules/profile/controllers/profile_controller.dart';

class SettingsController extends GetxController {

  onThemeChange(bool isLight){
    MyTheme.changeTheme(isLight);
    update();
  }

  Future<void> navigateToEditProfile() async {
    await Get.toNamed(Routes.EDIT_PROFILE);
    try {
      Get.find<ProfileController>().loadProfileData();
    } catch (e) {
      // Ignore if not found
    }
  }
}
