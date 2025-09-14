import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:closet_mate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    Get.put(SplashController());
    // var theme = context.theme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(4),
                // decoration: BoxDecoration(
                //   color: Colors.white, // or use ThemeColors.getCardBackground(...)
                //   borderRadius: BorderRadius.circular(8),
                // ),
                child: Image.asset(
                  Constants.logoNoBg,
                  width: 200.w,
                  height: 100.h,
                  color: isLightTheme ? null : ThemeColors.getSecondary(isLightTheme),
                ),
              ).animate().scale(
                begin: const Offset(0.5, 0.5), // Start slightly smaller
                end: const Offset(1.0, 1.0),   // Grow to full size
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ).fade(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              )
            ],
          ),
        ),
      ),
    );
  }
}