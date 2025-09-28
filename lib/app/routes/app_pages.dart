import 'package:get/get.dart';

import '../../config/theme/color_theme_controller.dart';
import '../modules/base/bindings/base_binding.dart';
import '../modules/base/views/base_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/favorites/bindings/favorites_binding.dart';
import '../modules/favorites/views/favorites_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/product_details/bindings/product_details_binding.dart';
import '../modules/product_details/views/product_details_view.dart';
import '../modules/product_details/controllers/cm_product_details_controller.dart';
import '../modules/product_details/views/cm_product_details_view.dart';
import '../modules/products_listing/bindings/products_listing_binding.dart';
import '../modules/products_listing/views/products_listing_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/user_measurements/bindings/user_measurements_binding.dart';
import '../modules/user_measurements/views/user_measurements_view.dart';
import '../modules/user_measurements/views/gender_selection_view.dart';
import '../modules/user_measurements/views/basic_measurements_view.dart';
import '../modules/user_measurements/views/detailed_measurements_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/swipe_shopping/bindings/swipe_shopping_binding.dart';
import '../modules/swipe_shopping/views/swipe_shopping_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.BASE,
      page: () => const BaseView(),
      binding: BaseBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SWIPE_SHOPPING,
      page: () => const SwipeShoppingView(),
      binding: SwipeShoppingBinding(),
    ),
    GetPage(
      name: _Paths.FAVORITES,
      page: () => const FavoritesView(),
      binding: FavoritesBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CM_PRODUCT_DETAILS,
      page: () => const CmProductDetailsView(),
      binding: BindingsBuilder(() => Get.lazyPut<CmProductDetailsController>(() => CmProductDetailsController())),
    ),
    GetPage(
      name: _Paths.PRODUCTS_LISTING,
      page: () => const ProductsListingView(),
      binding: ProductsListingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.USER_MEASUREMENTS,
      page: () => UserMeasurementsView(),
      binding: UserMeasurementsBinding(),
    ),
    GetPage(
      name: _Paths.GENDER_SELECTION,
      page: () => GenderSelectionView(),
      binding: UserMeasurementsBinding(),
    ),
    GetPage(
      name: _Paths.BASIC_MEASUREMENTS,
      page: () => BasicMeasurementsView(),
      binding: UserMeasurementsBinding(),
    ),
    GetPage(
      name: _Paths.DETAILED_MEASUREMENTS,
      page: () => DetailedMeasurementsView(),
      binding: UserMeasurementsBinding(),
    ),
    GetPage(
      name: _Paths.COLOR_THEME_CONTROLLER,
      page: () => const ColorThemeController(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
