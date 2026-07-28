import 'dart:ui';
import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:closet_mate/utils/constants.dart';
import 'package:closet_mate/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int previousIndex;
  final Function(int) onTabChange;
  const CustomAppBar({super.key, required this.previousIndex, required this.onTabChange});
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late Function(int) onTabChange;
  late int previousIndex;

  @override
  void initState() {
    super.initState();
    previousIndex = widget.previousIndex;
    onTabChange = widget.onTabChange;
  }

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    Color bgColor = isLightTheme ? Colors.white : Colors.black;
    Color textColor = isLightTheme ? const Color(0xFF1A1A1A) : Colors.white;

    return AppBar(
      elevation: 0,
      backgroundColor: bgColor.withOpacity(0.9),
      surfaceTintColor: Colors.transparent,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.transparent),
        ),
      ),
      title: Text(
        'CLOSETMATE',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 1.5,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.person_outline, color: textColor),
        onPressed: () => onTabChange(4), // 4 is typically the Profile tab
        tooltip: "Profile",
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: textColor),
          onPressed: () => Get.toNamed(Routes.PRODUCTS_LISTING, arguments: {'isSearch': true}),
          tooltip: "Search",
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
