import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:closet_mate/config/theme/colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/swipe_shopping_controller.dart';

class SwipeShoppingView extends GetView<SwipeShoppingController> {
  const SwipeShoppingView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SwipeShoppingController>(
      builder:
          (_) => Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                AppinioSwiper(
                  cardBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 130,
                        top: 16,
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
                    double opacity = (position.offset.distance / 5).clamp(
                      0.0,
                      1.0,
                    );
                    if (controller.direction == AxisDirection.right) {
                        controller.swipeAction = {
                          'top': MediaQuery.of(context).size.height / 3,
                          'left': null,
                          'right': 10.0,
                          'color': Colors.red,
                          'icon': Icons.favorite,
                          'opacity': opacity,
                        };
                      } else if (controller.direction == AxisDirection.left) {
                        controller.swipeAction = {
                          'top': MediaQuery.of(context).size.height / 3,
                          'left': 10.0,
                          'right': null,
                          'color': ColorConstants.close,
                          'icon': Icons.close,
                          'opacity': opacity,
                        };
                      } else if (controller.direction == AxisDirection.up) {
                        controller.swipeAction = {
                          'top': 20.0,
                          'left': 10.0,
                          'right': 10.0,
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

                // **Swipe Action Overlay**
                if (controller.swipeAction['opacity'] != 0.0)
                  Positioned(
                    top: controller.swipeAction['top'],
                    left: controller.swipeAction['left'],
                    right: controller.swipeAction['right'],
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 1000),
                      opacity: controller.swipeAction['opacity'],
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

                Positioned(
                  bottom: 50,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                            Icons.close,
                            color: ColorConstants.close,
                            size: 32,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                            Icons.shopping_cart,
                            color: ColorConstants.brightGreen,
                            size: 32,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                            Icons.favorite,
                            color: ColorConstants.favorite,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
