import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';

class SizeItem extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final bool selected;
  const SizeItem({
    super.key,
    required this.onPressed,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    bool isLightTheme = Get.isDarkMode == false;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30.w,
        height: 30.h,
        decoration: BoxDecoration(
          color: selected ? ThemeColors.getButtonBackground(isLightTheme) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: selected ? ThemeColors.getButtonText(isLightTheme) : null
            ),
          ),
        ),
      ),
    );
  }
}