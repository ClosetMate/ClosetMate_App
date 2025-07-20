import 'package:closet_mate/config/theme/colors.dart';
import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNav extends StatefulWidget {
  final int index;
  final Function(int) onTabChange;
  const BottomNav({super.key, required this.index, required this.onTabChange});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with SingleTickerProviderStateMixin {
  late int currentTabIndex;
  late Function(int) onTabChange;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    currentTabIndex = widget.index;
    onTabChange = widget.onTabChange;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: ThemeColors.getScaffoldBackground(isLightTheme),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeColors.getScaffoldBackground(isLightTheme),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home_outlined, 0, isLightTheme),
                _buildNavItem(Icons.favorite, 1, isLightTheme),
                const SizedBox(width: 60),
                _buildNavItem(Icons.shopping_cart_rounded, 3, isLightTheme),
                _buildNavItem(Icons.person_outlined, 4, isLightTheme),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: -5,
            child: Center(
              child: _buildCenterButton(isLightTheme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, bool isLightTheme) {
    final bool isSelected = currentTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentTabIndex = index;
        });
        onTabChange(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(top: 3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? ThemeColors.getSecondary(isLightTheme).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? ThemeColors.getSecondary(isLightTheme) : ThemeColors.getSecondary(isLightTheme),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton(bool isLightTheme) {
    final bool isSelected = currentTabIndex == 2;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentTabIndex = 2;
        });
        onTabChange(2);
        _animationController.forward().then((_) => _animationController.reverse());
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [
                    ThemeColors.getPrimary(isLightTheme),
                    ThemeColors.getPrimary(isLightTheme).withOpacity(0.8),
                  ]
                : [
                    ThemeColors.getSecondary(isLightTheme),
                    ThemeColors.getSecondary(isLightTheme).withOpacity(0.9),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isSelected ? ColorConstants.primaryColor : ColorConstants.secondary).withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Icon(
            Icons.swap_horiz,
            color: isSelected ? ThemeColors.getSecondary(isLightTheme) : ThemeColors.getPrimary(isLightTheme),
            size: 28,
          ),
        ),
      ),
    );
  }
}
