import 'package:closet_mate/config/theme/colors.dart';
import 'package:flutter/material.dart';

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
    return AppBar(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
                color: ColorConstants.appSpecificLight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            TextSpan(
              text: 'Mate',
              style: TextStyle(
                color: ColorConstants.appSpecificDark,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.person, color: ColorConstants.appSpecificDark),
        onPressed: () {},
        tooltip: "Profile",
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: ColorConstants.appSpecificDark),
          onPressed: () => onTabChange(5),
          tooltip: "Search",
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
