import 'package:flutter/material.dart';
import 'package:rooya_app/splash.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      //return LayoutBuilder
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ROOYA',
          defaultTransition: Transition.cupertino,
          transitionDuration: Duration(milliseconds: 700),
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.deepPurpleAccent,
          ),
          home: Splash(),
          // home: SignInTabsHandle(),
        );
      },
    );
  }
}
