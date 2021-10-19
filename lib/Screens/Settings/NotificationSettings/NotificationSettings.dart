import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/Screens/Settings/Components/Componenets.dart';
import 'package:rooya_app/utils/AppFonts.dart';

class NotificationSeetings extends StatefulWidget {
  const NotificationSeetings({Key? key}) : super(key: key);

  @override
  _NotificationSeetingsState createState() => _NotificationSeetingsState();
}

class _NotificationSeetingsState extends State<NotificationSeetings> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (c, size) {
      var height = size.maxHeight;
      var width = size.maxWidth;
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Get.back();
            },
            color: Colors.white,
          ),
          centerTitle: false,
          title: Text(
            'Notification Settings',
            style: TextStyle(
                fontFamily: AppFonts.segoeui,
                fontSize: 14,
                color: Colors.black),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.030),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.020,
                ),
                switchwithRow(
                    height: height,
                    width: width,
                    title: 'Someone liked my Posts'),
                SizedBox(
                  height: height * 0.020,
                ),
                switchwithRow(
                    height: height,
                    width: width,
                    title: 'Someone Commented on my Posts'),
                SizedBox(
                  height: height * 0.020,
                ),
                switchwithRow(
                    height: height, width: width, title: 'Someone followed me'),
                SizedBox(
                  height: height * 0.020,
                ),
                switchwithRow(
                    height: height,
                    width: width,
                    title: 'Someone liked my Pages'),
                SizedBox(
                  height: height * 0.020,
                ),
                switchwithRow(
                    height: height,
                    width: width,
                    title: 'Someone visited my Profile'),
                SizedBox(
                  height: height * 0.020,
                ),
                switchwithRow(
                    height: height,
                    width: width,
                    title: 'Someone mentioned me'),
                SizedBox(
                  height: height * 0.020,
                ),
                switchwithRow(
                    height: height,
                    width: width,
                    title: 'Someone accepted my friend/follow request'),
                SizedBox(
                  height: height * 0.020,
                ),
                switchwithRow(
                    height: height,
                    width: width,
                    title: 'Someone joined my Groups'),
                SizedBox(
                  height: height * 0.020,
                ),
                switchwithRow(
                    height: height,
                    width: width,
                    title: 'Someone posted on my timeline'),
                SizedBox(
                  height: height * 0.020,
                ),
                switchwithRow(
                    height: height,
                    width: width,
                    title: 'Someone liked my Posts'),
                SizedBox(
                  height: height * 0.020,
                ),
                switchwithRow(
                    height: height,
                    width: width,
                    title: 'You have remembrance on this day'),
              ],
            ),
          ),
        ),
      ));
    });
  }
}
