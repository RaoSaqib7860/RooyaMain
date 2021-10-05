import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rooya_app/utils/colors.dart';
import '../explore.dart';
import '../Home/home.dart';
import '../menu.dart';
import '../profile.dart';
import '../rooya_souq.dart';

class BottomSheetCustom extends StatefulWidget {
  const BottomSheetCustom({Key? key}) : super(key: key);

  @override
  _BottomSheetCustomState createState() => _BottomSheetCustomState();
}

class _BottomSheetCustomState extends State<BottomSheetCustom> {
  PersistentTabController? _controller;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        // Default is Colors.white.
        handleAndroidBackButtonPress: true,
        // Default is true.
        resizeToAvoidBottomInset: true,
        // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true,
        // Default is true.
        hideNavigationBarWhenKeyboardShows: true,
        // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        onItemSelected: (v) {},
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.simple, // Choose the nav bar style with this property.
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      Home(),
      Explore(),
      Menu(),
      RooyaSouq(),
      Profile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.home),
          activeColorPrimary: Colors.black,
          inactiveColorPrimary: greyColor),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.explore_sharp),
          activeColorPrimary: Colors.black,
          inactiveColorPrimary: greyColor),
      PersistentBottomNavBarItem(
          icon: Container(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.menu,
              size: 20,
              color: Colors.white,
            ),
            decoration:
                BoxDecoration(color: primaryColor, shape: BoxShape.circle),
          ),
          activeColorPrimary: Colors.black,
          inactiveColorPrimary: greyColor),
      //chat_bubble_text
      PersistentBottomNavBarItem(
          icon: Icon(Icons.lock),
          activeColorPrimary: Colors.black,
          inactiveColorPrimary: greyColor),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: greyColor,
      ),
    ];
  }
}
