import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rooya_app/splash.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'Screens/Reel/ReelCamera/ReelCamera.dart';

bool isActiveFirstTab = true;
StreamController<double> streamController =
StreamController<double>.broadcast();

final RouteObserver<ModalRoute<void>> routeObserver =
RouteObserver<ModalRoute<void>>();
List<CameraDescription> cameras = [];

T? ambiguate<T>(T? value) => value;

void main() async{
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
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
