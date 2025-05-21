import 'package:closet_mate/config/theme/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
    onTabChange = widget.onTabChange;// Assigning the received data to a local variable
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      height: 75,
      backgroundColor: const Color.fromRGBO(255, 0, 0, 0), // Keeps the curved effect smooth
      color: ColorConstants.appSpecificDark, // Matches AppBar
      animationDuration: const Duration(milliseconds: 300),
      index: 0,
      items: [
        Icon(
          Icons.home_outlined,
          color: currentTabIndex == 0 ? Colors.white : Colors.grey[300],
          size: 25,
        ),
        Icon(
          Icons.favorite,
          color: currentTabIndex == 1 ? Colors.white : Colors.grey[300],
          size: 25,
        ),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white, // Floating middle button effect
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ColorConstants.appSpecificDark,
                blurRadius: 6,
                spreadRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.swap_horiz,
            color: ColorConstants.primaryColor,
            size: 30,
          ),
        ),
        Icon(
          Icons.shopping_cart_rounded,
          color: currentTabIndex == 3 ? Colors.white : Colors.grey[300],
          size: 25,
        ),
        Icon(
          Icons.person_outlined,
          color: currentTabIndex == 4 ? Colors.white : Colors.grey[300],
          size: 25,
        ),
      ],
      onTap: (int index) {
        onTabChange(index);
      },
    );
  }
}
