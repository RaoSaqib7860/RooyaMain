import 'package:flutter/material.dart';
import 'package:rooya_app/dashboard/explore.dart';
import 'package:rooya_app/dashboard/home.dart';
import 'package:rooya_app/dashboard/menu.dart';
import 'package:rooya_app/dashboard/profile.dart';
import 'package:rooya_app/dashboard/rooya_souq.dart';
import 'package:rooya_app/utils/colors.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex=0;
  List<Widget> screens=[
    Home(),
    Explore(),
    Menu(),
    RooyaSouq(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(

        onTap: (int index) {
          setState(() {
            _currentIndex=index;
          });
        },
        currentIndex: _currentIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        elevation: 15.0,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
            activeIcon: Icon(Icons.home,
              color: primaryColor,),),

          BottomNavigationBarItem(
            icon: Icon(Icons.explore_sharp),
            label: '',
            activeIcon: Icon(Icons.explore_sharp,
              color: primaryColor,),),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '',
            activeIcon: Icon(Icons.menu,
              color: primaryColor,),),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: '',
            activeIcon: Icon(Icons.lock,
              color: primaryColor,),),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
            activeIcon: Icon(Icons.person,
              color: primaryColor,),),

        ],
      ),
    );
  }
}
