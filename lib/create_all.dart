import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/dashboard/Home/HomeController/HomeController.dart';
import 'package:rooya_app/events/create_event.dart';
import 'package:rooya_app/rooya_post/CreatePost/create_post.dart';
import 'package:rooya_app/rooya_souq/create_souq.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:sizer/sizer.dart';
import 'ApiUtils/AuthUtils.dart';
import 'Screens/Reel/ReelCamera/ReelCamera.dart';
import 'dashboard/Home/home.dart';
import 'events/CreateNewEvent/CreateNewEvent.dart';
import 'rooya_post/Story/CreateStory.dart';

class CreateAll extends StatefulWidget {
  @override
  _CreateAllState createState() => _CreateAllState();
}

class _CreateAllState extends State<CreateAll> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
        body: Container(
          width: 100.0.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 8.0.h,
              ),
              SizedBox(
                height: 5.0.h,
              ),
              InkWell(
                onTap: () {
                  Get.to(CreatePost());
                },
                child: Container(
                  height: 9.0.h,
                  width: 70.0.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: primaryColor.withOpacity(0.5),
                          offset: Offset(3, 3))
                    ],
                    color: const Color(0xffffffff),
                    border:
                        Border.all(width: 1.0, color: const Color(0xff0bab0d)),
                  ),
                  child: Center(
                    child: Text(
                      'Create Rooya',
                      style: TextStyle(
                        fontFamily: AppFonts.segoeui,
                        fontSize: 16,
                        color: const Color(0xff5a5a5a),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.0.h,
              ),
              InkWell(
                onTap: () {
                  fromHomeStory = '0';
                  Get.to(CameraApp(
                    fromStory: true,
                  ))!
                      .then((value) {
                    fromHomeStory = '0';
                  });
                },
                child: Container(
                  height: 9.0.h,
                  width: 70.0.w,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: primaryColor.withOpacity(0.5),
                          offset: Offset(3, 3))
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffffffff),
                    border:
                        Border.all(width: 1.0, color: const Color(0xff0bab0d)),
                  ),
                  child: Center(
                    child: Text(
                      'Create Story',
                      style: TextStyle(
                        fontFamily: AppFonts.segoeui,
                        fontSize: 16,
                        color: const Color(0xff5a5a5a),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.0.h,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => CreateSouq());
                },
                child: Container(
                  height: 9.0.h,
                  width: 70.0.w,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: primaryColor.withOpacity(0.5),
                          offset: Offset(3, 3))
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffffffff),
                    border:
                        Border.all(width: 1.0, color: const Color(0xff0bab0d)),
                  ),
                  child: Center(
                    child: Text(
                      'Create Souq',
                      style: TextStyle(
                        fontFamily: AppFonts.segoeui,
                        fontSize: 16,
                        color: const Color(0xff5a5a5a),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.0.h,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => CreateNewEvent());
                  // Get.to(() => CreateEvent());
                },
                child: Container(
                  height: 9.0.h,
                  width: 70.0.w,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: primaryColor.withOpacity(0.5),
                          offset: Offset(3, 3))
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffffffff),
                    border:
                        Border.all(width: 1.0, color: const Color(0xff0bab0d)),
                  ),
                  child: Center(
                    child: Text(
                      'Create Event',
                      style: TextStyle(
                        fontFamily: AppFonts.segoeui,
                        fontSize: 16,
                        color: const Color(0xff5a5a5a),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
