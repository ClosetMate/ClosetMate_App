import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:closet_mate/config/theme/colors.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/swipe_shopping_controller.dart';

class SwipeShoppingView extends GetView<SwipeShoppingController> {
  const SwipeShoppingView({super.key});
  
  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    
    return Scaffold(
      backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DISCOVER STYLES",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: ThemeColors.getTextPrimary(isLightTheme),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeColors.getCardBackground(isLightTheme),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.filter_list_rounded,
                        color: ThemeColors.getSecondary(isLightTheme),
                        size: 24.sp,
                      ),
                      onPressed: () => controller.showFilterDialog(context),
                      tooltip: "Filter",
                    ),
                  ),
                ],
              ),
            ),
            
            // Body (Swiper)
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading products...'),
                      ],
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.sp,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Error: ${controller.errorMessage.value}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: controller.loadProducts,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.productCards.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No products available',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Try refreshing or check your connection',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: controller.loadProducts,
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                  );
                }

                return GetBuilder<SwipeShoppingController>(
                  builder: (_) => Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        child: AppinioSwiper(
                          backgroundCardCount: 1,
                          controller: controller.swiperController,
                          cardBuilder: (context, index) {
                            return controller.productCards[index];
                          },
                          cardCount: controller.productCards.length,
                          onSwipeEnd: (previousIndex, targetIndex, activity) {
                            controller.swipeAction = {'opacity': 0.0};
                            controller.update();
                          },
                          onCardPositionChanged: (SwiperPosition position) {
                            var currentDirection = position.offset.toAxisDirection();
                            if (currentDirection != controller.direction) {
                              controller.swipeAction = {'opacity': 0.0};
                            }
                            controller.direction = currentDirection;
                            double opacity = position.offset.distance < 30 ? 0.0 :(position.offset.distance / 100).clamp(
                              0.0,
                              1.0,
                            );
                            if (controller.direction == AxisDirection.right) {
                              controller.swipeAction = {
                                'top': MediaQuery.of(context).size.height / 4,
                                'left': null,
                                'right': 40.0,
                                'color': Colors.red,
                                'icon': Icons.favorite,
                                'opacity': opacity,
                              };
                            } else if (controller.direction == AxisDirection.left) {
                              controller.swipeAction = {
                                'top': MediaQuery.of(context).size.height / 4,
                                'left': 40.0,
                                'right': null,
                                'color': ColorConstants.close,
                                'icon': Icons.close,
                                'opacity': opacity,
                              };
                            } else if (controller.direction == AxisDirection.up) {
                              controller.swipeAction = {
                                'top': 40.0,
                                'left': 40.0,
                                'right': 40.0,
                                'color': ColorConstants.brightGreen,
                                'icon': Icons.shopping_cart,
                                'opacity': opacity,
                              };
                            } else {
                              controller.swipeAction = {'opacity': 0.0};
                            }
                            controller.update();
                          },
                        ),
                      ),
                      // Swipe Action Overlay
                      if (controller.swipeAction['opacity'] != 0.0)
                        Positioned(
                          top: controller.swipeAction['top'],
                          left: controller.swipeAction['left'],
                          right: controller.swipeAction['right'],
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: controller.swipeAction['opacity'],
                            child: Transform.scale(
                              scale: 0.2 + (controller.swipeAction['opacity'] * 1.2),
                              child: Container(
                                width: 64.w,
                                height: 64.h,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(196, 255, 255, 255),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  controller.swipeAction['icon'],
                                  size: 40.sp,
                                  color: controller.swipeAction['color'],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            
            // Bottom Actions
            Padding(
              padding: EdgeInsets.only(bottom: 20.h, top: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    icon: Icons.close,
                    color: Colors.red,
                    size: 56.w,
                    iconSize: 28.sp,
                    onTap: () => controller.swiperController.swipeLeft(),
                    isLightTheme: isLightTheme,
                  ),
                  SizedBox(width: 30.w),
                  _buildActionButton(
                    icon: Icons.shopping_cart_outlined, // Changed to Cart
                    color: ThemeColors.getAccent(isLightTheme),
                    size: 76.w,
                    iconSize: 36.sp,
                    onTap: () => controller.swiperController.swipeUp(),
                    isLightTheme: isLightTheme,
                  ),
                  SizedBox(width: 30.w),
                  _buildActionButton(
                    icon: Icons.favorite_border_rounded,
                    color: Colors.green,
                    size: 56.w,
                    iconSize: 28.sp,
                    onTap: () => controller.swiperController.swipeRight(),
                    isLightTheme: isLightTheme,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double size,
    required double iconSize,
    required VoidCallback onTap,
    required bool isLightTheme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: ThemeColors.getCardBackground(isLightTheme),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: iconSize,
        ),
      ),
    );
  }
}
