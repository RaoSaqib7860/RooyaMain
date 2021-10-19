import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rooya_app/ExploreRooya/ExploreRooya.dart';
import 'package:rooya_app/Screens/Reel/Reel.dart';
import 'package:rooya_app/utils/colors.dart';
import '../../main.dart';
import '../Home/home.dart';
import '../menu.dart';
import '../../CreateSouq/rooya_souq.dart';

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
        onItemSelected: (index) {
          if (index != 2) {
            streamController.sink.add(10.0);
          }
        },
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
      ExploreRooya(),
      ReelPage(),
      RooyaSouq(),
      Menu(),
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
      //chat_bubble_text
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.circle_grid_hex,
          color: primaryColor,
        ),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.lock),
          activeColorPrimary: Colors.black,
          inactiveColorPrimary: greyColor),
      PersistentBottomNavBarItem(
          icon: Container(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.menu,
              color: primaryColor,
            ),
          ),
          activeColorPrimary: Colors.black,
          inactiveColorPrimary: greyColor),
    ];
  }
}
