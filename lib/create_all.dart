import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/events/create_event.dart';
import 'package:rooya_app/rooya_post/create_post.dart';
import 'package:rooya_app/rooya_souq/create_souq.dart';
import 'package:rooya_app/story/create_story.dart';
import 'package:sizer/sizer.dart';

class CreateAll extends StatefulWidget {
  @override
  _CreateAllState createState() => _CreateAllState();
}

class _CreateAllState extends State<CreateAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.green, //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset('assets/images/logo.png',
          height: 8.0.h,),

      ),
      body: Container(
        width: 100.0.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 5.0.h,),
            InkWell(
              onTap: (){
                Get.to(()=>CreatePost());
              },
              child: Container(
                height: 10.0.h,
                width: 70.0.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xffffffff),
                  border: Border.all(
                      width: 1.0, color: const Color(0xff0bab0d)),
                ),
                child: Center(
                  child: Text(
                    'Create Rooya',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 18,
                      color: const Color(0xff5a5a5a),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.0.h,),
            InkWell(
              onTap: (){
                Get.to(()=>CreateStory());
              },
              child: Container(
                height: 10.0.h,
                width: 70.0.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xffffffff),
                  border: Border.all(
                      width: 1.0, color: const Color(0xff0bab0d)),
                ),
                child: Center(
                  child: Text(
                    'Create Story',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 18,
                      color: const Color(0xff5a5a5a),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.0.h,),
            InkWell(
              onTap: (){
                Get.to(()=>CreateSouq());
              },
              child: Container(
                height: 10.0.h,
                width: 70.0.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xffffffff),
                  border: Border.all(
                      width: 1.0, color: const Color(0xff0bab0d)),
                ),
                child: Center(
                  child: Text(
                    'Create Souq',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 18,
                      color: const Color(0xff5a5a5a),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.0.h,),
            InkWell(
              onTap: (){
                Get.to(()=>CreateEvent());
              },
              child: Container(
                height: 10.0.h,
                width: 70.0.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xffffffff),
                  border: Border.all(
                      width: 1.0, color: const Color(0xff0bab0d)),
                ),
                child: Center(
                  child: Text(
                    'Create Event',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 18,
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
    );
  }
}
