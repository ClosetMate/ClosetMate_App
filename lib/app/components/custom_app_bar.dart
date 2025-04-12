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
  bool _showSearch = false; // Controls search bar visibility
  late Function(int) onTabChange;
  late int previousIndex;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    previousIndex = widget.previousIndex;
    onTabChange = widget.onTabChange;// Assigning the received data to a local variable
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 10, // Adds depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20), // Soft rounded corners
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white], // Gradient effect
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Shadow color
              blurRadius: 5, // Spread of shadow
              offset: Offset(0, 3), // Vertical offset
            ),
          ],
        ),
      ),
      title:
          _showSearch
              ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: TextField(
                  focusNode: _searchFocusNode,
                  autofocus: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  ),
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                  ),
                ),
              )
              : Text.rich(
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
      centerTitle: !_showSearch,
      leading: IconButton(
        icon: Icon(Icons.person, color: ColorConstants.appSpecificDark),
        onPressed: () {},
        tooltip: "Profile",
      ),
      actions: [
        IconButton(
          icon: Icon(
            _showSearch ? Icons.close : Icons.search,
            color: ColorConstants.appSpecificDark,
          ),
          onPressed: () {
            setState(() {
              _showSearch = !_showSearch; // Toggle search bar visibility
              if (_showSearch) {
                onTabChange(5);
              }else{
                // FocusScope.of(context).unfocus(); // Dismiss keyboard
                onTabChange(previousIndex);
              }
            });
          },
          tooltip: _showSearch ? "Close Search" : "Search",
        ),
        // IconButton(
        //   icon: Icon(Icons.info, color: ColorConstants.appSpecificDark),
        //   onPressed: () {},
        //   tooltip: "Info",
        // ),
        SizedBox(width: 10), // Adds spacing
      ],
    );
  }
}
