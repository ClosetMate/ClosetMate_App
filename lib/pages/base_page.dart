import 'package:closet_mate/pages/cart_page.dart';
import 'package:closet_mate/pages/favourite_page.dart';
import 'package:closet_mate/pages/home_page.dart';
import 'package:closet_mate/pages/profile_page.dart';
import 'package:closet_mate/pages/search_page.dart';
import 'package:closet_mate/pages/swipe_shopping_page.dart';
import 'package:closet_mate/app/components/bottom_nav.dart';
import 'package:closet_mate/app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});
  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int currentTabIndex = 0;
  late List<Widget> pages;
  late HomePage homepage;
  late FavouritePage favouritePage;
  late SwipeShoppingPage swipeShoppingPage;
  late CartPage cartPage;
  late ProfilePage profilePage;
  late SearchPage searchPage;

  @override
  void initState() {
    super.initState();
    homepage = HomePage();
    favouritePage = const FavouritePage();
    swipeShoppingPage = const SwipeShoppingPage();
    cartPage = const CartPage();
    profilePage = const ProfilePage();
    searchPage = const SearchPage();
    pages = [
      homepage,
      favouritePage,
      swipeShoppingPage,
      cartPage,
      profilePage,
      searchPage
    ]; // Add swipePage to the list
  }

  void onTabChange(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50), // Standard AppBar height
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: currentTabIndex == 2 ? 0 : 80, // Animate height change
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: currentTabIndex == 2 ? 0.0 : 1.0, // Animate opacity change
            child: currentTabIndex == 2 ? SizedBox.shrink() : CustomAppBar(previousIndex: currentTabIndex, onTabChange: onTabChange),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: pages[currentTabIndex],
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none, // Allows the middle icon to go outside
        children: [
          BottomNav(onTabChange: onTabChange, index: currentTabIndex)
        ],
      ),
    );
  }
}
