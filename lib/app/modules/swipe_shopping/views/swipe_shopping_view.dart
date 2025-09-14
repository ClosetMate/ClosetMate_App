import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:closet_mate/config/theme/colors.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/swipe_shopping_controller.dart';

class SwipeShoppingView extends GetView<SwipeShoppingController> {
  const SwipeShoppingView({super.key});
  
  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    
    return GetBuilder<SwipeShoppingController>(
      builder: (_) => Scaffold(
        backgroundColor: ThemeColors.getScaffoldBackground(isLightTheme),
        body: Stack(
          children: [
            AppinioSwiper(
              backgroundCardOffset: Offset(0, 50),
              backgroundCardCount: 1,
              controller: AppinioSwiperController(),
                  cardBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 50,
                        top: 0,
                      ), // Padding around each card
                      child: controller.productCards[index],
                    );
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
                          'top': MediaQuery.of(context).size.height / 3,
                          'left': null,
                          'right': 20.0,
                          'color': Colors.red,
                          'icon': Icons.favorite,
                          'opacity': opacity,
                        };
                      } else if (controller.direction == AxisDirection.left) {
                        controller.swipeAction = {
                          'top': MediaQuery.of(context).size.height / 3,
                          'left': 20.0,
                          'right': null,
                          'color': ColorConstants.close,
                          'icon': Icons.close,
                          'opacity': opacity,
                        };
                      } else if (controller.direction == AxisDirection.up) {
                        controller.swipeAction = {
                          'top': 20.0,
                          'left': 20.0,
                          'right': 20.0,
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

                // **Filter Button**
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  right: 20,
                  child: Container(
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
                        size: 24,
                      ),
                      onPressed: () => controller.showFilterDialog(context),
                      tooltip: "Filter",
                    ),
                  ),
                ),

                // **Swipe Action Overlay**
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
                          width: 64,
                          height: 64,
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
                            size: 40,
                            color: controller.swipeAction['color'],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
    );
  }
}
