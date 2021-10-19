import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/AppThemes/AppThemes.dart';
import 'package:rooya_app/utils/AppFonts.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
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
              'PRIVACY',
              style: TextStyle(
                  fontFamily: AppFonts.segoeui,
                  fontSize: 14,
                  color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.010,
                  ),
                  Text(
                    'Who can follow me?',
                    style: TextStyle(fontFamily: AppFonts.segoeui),
                  ),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  rowData(width: width, height: height, text: 'Everyone'),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  Text(
                    'Who can message me?',
                    style: TextStyle(fontFamily: AppFonts.segoeui),
                  ),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  rowData(width: width, height: height, text: 'Everyone'),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  Text(
                    'Who can see my friends?',
                    style: TextStyle(fontFamily: AppFonts.segoeui),
                  ),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  rowData(width: width, height: height, text: 'Everyone'),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  Text(
                    'Who can post on my timeline?',
                    style: TextStyle(fontFamily: AppFonts.segoeui),
                  ),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  rowData(width: width, height: height, text: 'Everyone'),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  Text(
                    'Who can see my birthday?',
                    style: TextStyle(fontFamily: AppFonts.segoeui),
                  ),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  rowData(width: width, height: height, text: 'Everyone'),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  Text(
                    'Confirm request when someone follows you?',
                    style: TextStyle(fontFamily: AppFonts.segoeui),
                  ),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  rowData(width: width, height: height, text: 'Everyone'),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  Text(
                    'Show my activities?',
                    style: TextStyle(fontFamily: AppFonts.segoeui),
                  ),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  rowData(width: width, height: height, text: 'Everyone'),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  Text(
                    'Status',
                    style: TextStyle(fontFamily: AppFonts.segoeui),
                  ),
                  SizedBox(
                    height: height * 0.010,
                  ),
                  rowData(width: width, height: height, text: 'Everyone'),
                  SizedBox(
                    height: height * 0.060,
                  ),
                ],
              ),
            ),
            physics: BouncingScrollPhysics(),
          ),
        ),
      );
    });
  }

  Widget rowData({double? height, double? width, String? text}) {
    return Container(
      height: height! * 0.060,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.green.withOpacity(0.10),
                offset: Offset(4, 4),
                blurRadius: 3),
            BoxShadow(
                color: Colors.green.withOpacity(0.1),
                offset: Offset(-1, -1),
                blurRadius: 1)
          ],
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width! * 0.030),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text!,
              style: TextStyle(fontFamily: AppFonts.segoeui),
            ),
            Icon(
              CupertinoIcons.chevron_down,
              size: 18,
              color: greenColor,
            )
          ],
        ),
      ),
    );
  }
}
