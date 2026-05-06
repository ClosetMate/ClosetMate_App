import 'package:closet_mate/app/modules/base/controllers/base_controller.dart';
import 'package:closet_mate/app/components/bottom_nav.dart';
import 'package:closet_mate/app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class BaseView extends GetView<BaseController> {
  const BaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaseController>(
      builder:
          (_) => Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(
                50,
              ), // Standard AppBar height
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height:
                    _shouldHideAppBar(controller.currentTabIndex)
                        ? 40
                        : 120, // Animate height change
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity:
                      _shouldHideAppBar(controller.currentTabIndex)
                          ? 0.0
                          : 1.0, // Animate opacity change
                  child:
                      _shouldHideAppBar(controller.currentTabIndex)
                          ? SizedBox.shrink()
                          : CustomAppBar(
                            previousIndex: controller.currentTabIndex,
                            onTabChange: controller.onTabChange,
                          ),
                ),
              ),
            ),
            body: SafeArea(
              bottom: false,
              child: IndexedStack(
                index: controller.currentTabIndex,
                children: controller.pages,
              ),
            ),
            bottomNavigationBar:
                controller.currentTabIndex == 5
                    ? null
                    : BottomNav(
                      onTabChange: controller.onTabChange,
                      index: controller.currentTabIndex,
                    ),
          ),
    );
  }

  bool _shouldHideAppBar(int currentIndex) {
    // Add indices where you want to hide the app bar
    return currentIndex == 3 || // Swipe Shopping
           currentIndex == 5;   // Search
  }
}
