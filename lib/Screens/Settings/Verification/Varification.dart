import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/AppThemes/AppThemes.dart';
import 'package:rooya_app/utils/AppFonts.dart';

class Varification extends StatefulWidget {
  const Varification({Key? key}) : super(key: key);

  @override
  _VarificationState createState() => _VarificationState();
}

class _VarificationState extends State<Varification> {
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
            'Verification',
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
                  height: height * 0.030,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    picStyple(
                        width: width,
                        height: height,
                        title: 'ID Card Front Picture'),
                    picStyple(
                        width: width,
                        height: height,
                        title: 'ID Card Back Picture'),
                  ],
                ),
                SizedBox(
                  height: height * 0.030,
                ),
                picStyple(
                    width: width, height: height, title: 'Capture Live Image'),
                SizedBox(
                  height: height * 0.030,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    picStyple(
                        width: width,
                        height: height,
                        title: 'Passport First Page'),
                    picStyple(
                        width: width,
                        height: height,
                        title: 'Passport Signature Page'),
                  ],
                ),
                SizedBox(
                  height: height * 0.020,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: settingGreyColor,
                      boxShadow: [
                        BoxShadow(
                          color: greenColor.withOpacity(0.5),
                          offset: Offset(0.2, 0.2), //(x,y)
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      maxLines: 5,
                      keyboardType: TextInputType.text,
                      //  controller: textCon,
                      textInputAction: TextInputAction.done,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintStyle: TextStyle(color: greyColor, fontSize: 12),
                          hintText: "Enter message here"),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.030,
                ),
                Container(
                  height: height * 0.060,
                  width: width,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                          fontFamily: AppFonts.segoeui,
                          fontSize: 13,
                          color: Colors.white),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: greenColor,
                      borderRadius: BorderRadius.circular(5)),
                ),
                SizedBox(
                  height: height * 0.050,
                ),
              ],
            ),
          ),
        ),
      ));
    });
  }

  Widget picStyple({double? height, double? width, String? title}) {
    return Container(
      height: height! * 0.180,
      width: width! * 0.4,
      child: Column(
        children: [
          Icon(
            CupertinoIcons.camera_fill,
            color: darkoffBlackColor,
          ),
          SizedBox(
            height: height * 0.020,
          ),
          Text(
            '$title',
            style: TextStyle(
                fontSize: 12,
                color: darkoffBlackColor,
                fontFamily: AppFonts.segoeui),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      decoration: BoxDecoration(
          color: settingGreyColor, borderRadius: BorderRadius.circular(10)),
    );
  }
}
