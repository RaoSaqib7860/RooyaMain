import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'dashboard/dashboard.dart';
import 'login/sign_in_tabs_handle.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
 
    return  prefs.getString('token');
  }
  
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 3), () {
      getToken().then((token){
        if(token!=null){
          Get.offAll(()=>Dashboard());
        }else{
          Get.offAll(()=>SignInTabsHandle());
        }
      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          //fit: BoxFit.cover,
          height: 15.0.h,
          width: 15.0.h,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
