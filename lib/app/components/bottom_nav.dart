import 'dart:ui';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final int index;
  final Function(int) onTabChange;
  const BottomNav({super.key, required this.index, required this.onTabChange});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late int currentTabIndex;
  late Function(int) onTabChange;

  @override
  void initState() {
    super.initState();
    currentTabIndex = widget.index;
    onTabChange = widget.onTabChange;
  }

  @override
  void didUpdateWidget(BottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      currentTabIndex = widget.index;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    Color bgColor = isLightTheme ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.9);
    Color iconColor = isLightTheme ? const Color(0xFF1A1A1A) : Colors.white;
    Color inactiveColor = isLightTheme ? const Color(0xFF9CA3AF) : Colors.white54;
    Color borderColor = isLightTheme ? Colors.grey.shade100 : Colors.grey.shade900;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 80,
          padding: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              top: BorderSide(
                color: borderColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home_outlined, 0, iconColor, inactiveColor),
              _buildNavItem(Icons.grid_view_outlined, 1, iconColor, inactiveColor),
              _buildNavItem(Icons.auto_awesome, 3, iconColor, inactiveColor),
              _buildNavItem(Icons.person_outline, 4, iconColor, inactiveColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, Color activeColor, Color inactiveColor) {
    final bool isSelected = currentTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentTabIndex = index;
        });
        onTabChange(index);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 26,
              ),
            ),
            if (isSelected)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: activeColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
