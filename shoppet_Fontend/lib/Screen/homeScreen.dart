import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shoppet_fontend/Screen/categoryScreen.dart';
import 'package:shoppet_fontend/Screen/mainScreen.dart';
import 'package:shoppet_fontend/Screen/searchScreen.dart';
import 'package:shoppet_fontend/Screen/showSearchScreen.dart';

import 'cartScreen.dart';
import 'detailScreen.dart';

class homeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _homeScreen();
}

class _homeScreen extends State<homeScreen> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  bool togeteNB = true;

  void togeteNavbar() {
    setState(() {
      togeteNB = !togeteNB;
    });
  }

  List<Widget> _buildScreens() {
    return [
      screenMain(
        togetherNavBar: () {
          togeteNavbar();
        },
      ),
      cartScreen(),
      const Center(child: Text("Profile")),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: const Color.fromRGBO(237, 177, 107, 1.0),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.shopping_cart_rounded,
          size: 25,
        ),
        title: "Cart",
        activeColorPrimary: const Color.fromRGBO(237, 177, 107, 1.0),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Profile",
        activeColorPrimary: const Color.fromRGBO(237, 177, 107, 1.0),
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      decoration: const NavBarDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.grey, // Màu của shadow
            spreadRadius: 1, // Bán kính lan tỏa của shadow
            blurRadius: 10, // Độ mờ của shadow
            offset: Offset(0, -1), // Vị trí của shadow
          ),
        ],
      ),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: false,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      padding: const EdgeInsets.only(top: 10),
      backgroundColor: Colors.white,
      isVisible: togeteNB,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInExpo,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.simple,
    );
  }
}
