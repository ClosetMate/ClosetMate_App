import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'config/theme/my_theme.dart';
import 'config/theme/dynamic_color_controller.dart';
import 'app/data/local/my_shared_pref.dart';
import 'app/routes/app_pages.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPref.init();
  
  // Initialize the dynamic color controller
  Get.put(DynamicColorController());
  
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      rebuildFactor: (old, data) => true,
      useInheritedMediaQuery: true,
      builder: (context, widget) {
        return GetMaterialApp(
          useInheritedMediaQuery: true,
          title: "ClosetMate",
          debugShowCheckedModeBanner: false,
          theme: MyTheme.getThemeData(isLight: true),
          darkTheme: MyTheme.getThemeData(isLight: false),
          themeMode: MySharedPref.getThemeIsLight() ? ThemeMode.light : ThemeMode.dark,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    ),
  );
}
