import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';

class RoundedButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  const RoundedButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Get.isDarkMode == false;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: ThemeColors.getButtonBackground(isLightTheme),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: child,
      ),
    );
  }
}