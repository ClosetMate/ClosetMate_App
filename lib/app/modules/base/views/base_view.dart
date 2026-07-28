import 'package:closet_mate/app/modules/base/controllers/base_controller.dart';
import 'package:closet_mate/app/components/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseView extends GetView<BaseController> {
  const BaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaseController>(
      builder:
          (_) => Scaffold(
            body: SafeArea(
              bottom: false,
              child: FadeIndexedStack(
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
}

class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
  }

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: IndexedStack(
        index: widget.index,
        children: widget.children,
      ),
    );
  }
}
