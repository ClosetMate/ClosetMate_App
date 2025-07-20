import 'package:closet_mate/config/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int previousIndex;
  final Function(int) onTabChange;
  const CustomAppBar({super.key, required this.previousIndex, required this.onTabChange});
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50);
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
    return AppBar(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: ThemeColors.getScaffoldBackground(isLightTheme),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
      ),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Closet',
              style: TextStyle(
                color: ThemeColors.getPrimary(isLightTheme),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                // shadows: [
                //   Shadow(
                //     offset: Offset(0, 0),
                //     blurRadius: 5.0,
                //     color: isLightTheme ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.5),
                //   ),
                // ],
              ),
            ),
            TextSpan(
              text: 'Mate',
              style: TextStyle(
                color: ThemeColors.getSecondary(isLightTheme),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                // shadows: [
                //   Shadow(
                //     offset: Offset(0, 0),
                //     blurRadius: 5.0,
                //     color: isLightTheme ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.5),
                //   ),
                // ],
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.person, color: ThemeColors.getSecondary(isLightTheme)),
        onPressed: () {},
        tooltip: "Profile",
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: ThemeColors.getSecondary(isLightTheme)),
          onPressed: () => onTabChange(5),
          tooltip: "Search",
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
