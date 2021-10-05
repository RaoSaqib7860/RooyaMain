import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/Screens/AuthScreens/sign_in_tabs_handle.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:sizer/sizer.dart';

class PasswordChanged extends StatefulWidget {
  @override
  _PasswordChangedState createState() => _PasswordChangedState();
}

class _PasswordChangedState extends State<PasswordChanged> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => SignInTabsHandle());
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                CupertinoIcons.back,
                color: Colors.black,
              ),
              onPressed: () {
                Get.offAll(() => SignInTabsHandle());
              },
            ),
          ),
          body: Container(
            height: height,
            width: width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 8.0.h,
                  ),
                  SizedBox(
                    height: 5.0.h,
                  ),
                  Text(
                    'Password Changed',
                    style: TextStyle(
                      fontFamily: AppFonts.segoeui,
                      fontSize: 20,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Successfully!',
                    style: TextStyle(
                      fontFamily: AppFonts.segoeui,
                      fontSize: 20,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5.0.h,
                  ),
                  Icon(
                    Icons.check_circle_outlined,
                    color: primaryColor,
                    size: 15.0.h,
                  ),
                  SizedBox(
                    height: 5.0.h,
                  ),
                  InkWell(
                    onTap: () {
                      Get.offAll(() => SignInTabsHandle());
                    },
                    child: Container(
                      width: 250.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xff0bab0d),
                      ),
                      child: Center(
                        child: Text(
                          'CONTINUE',
                          style: TextStyle(
                            fontFamily: AppFonts.segoeui,
                            fontSize: 13,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
