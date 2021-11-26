import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/AppThemes/AppThemes.dart';
import 'package:rooya_app/story/uploadStroy.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/SnackbarCustom.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'VarificationController.dart';

class Varification extends StatefulWidget {
  const Varification({Key? key}) : super(key: key);

  @override
  _VarificationState createState() => _VarificationState();
}

class _VarificationState extends State<Varification> {
  final controller = Get.put(VarificationController());

  bool load_varification = false;
  bool loading = false;

  String has_verified = 'first';
  bool circule = false;

  Future<void> getaccountVerificationDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}accountVerificationDetails$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": userId,
        }));
    print('accountVerificationDetails response is = ${response.body}');
    var data = jsonDecode(response.body);
    if (data['result'] == 'failure') {
      setState(() {
        has_verified = 'first';
      });
    } else if (data['result'] == 'success') {
      if (data['data'][0]['status'] == '1') {
        setState(() {
          has_verified = 'true';
        });
      } else {
        setState(() {
          has_verified = 'false';
        });
      }
    }
    setState(() {
      loading = true;
    });
  }

  Future<void> updatePrivicy(
      {String? id_fisrt,
      String? id_back,
      String? live,
      String? p_first,
      String? p_second}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}accountVerification$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": userId,
          "user_type": "user",
          "photo": "$live",
          "passport": "$p_first",
          "id_front": "$id_fisrt",
          "id_back": "$id_back",
          "passpost_sing": "$p_second",
          "message": "${controller.messageCon.text}"
        }));
    print('response is = ${response.body}');
    var data = jsonDecode(response.body);
    if (data['result'] == 'success') {
      snackBarSuccess('${data['message']}');
    }
    setState(() {
      has_verified = 'false';
    });
  }

  @override
  void initState() {
    getaccountVerificationDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (c, size) {
      var height = size.maxHeight;
      var width = size.maxWidth;
      return ProgressHUD(
        inAsyncCall: circule,
        opacity: 0.7,
        child: SafeArea(
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
          body: !loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : has_verified == 'true'
                  ? Container(
                      height: height,
                      width: width,
                      child: Column(
                        children: [
                          Container(
                            height: height * 0.1,
                            width: width * 0.2,
                            child: Center(
                                child: Container(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.thumb_up_alt_rounded,
                                size: 35,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: primaryColor),
                            )),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: primaryColor.withOpacity(0.5),
                                    width: 5)),
                          ),
                          SizedBox(
                            height: height * 0.020,
                          ),
                          Text(
                            'Congratulations',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.020,
                          ),
                          Text(
                            'This account is verified.',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    )
                  : has_verified == 'false'
                      ? Container(
                          height: height,
                          width: width,
                          child: Column(
                            children: [
                              Container(
                                height: height * 0.1,
                                width: width * 0.2,
                                child: Center(
                                    child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.access_time,
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.brown),
                                )),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.brown[100]!, width: 5)),
                              ),
                              SizedBox(
                                height: height * 0.020,
                              ),
                              Text(
                                'Pending',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.020,
                              ),
                              Text(
                                'Your verification request is still awaiting admin approval.',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          ),
                        )
                      : Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.030),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: height * 0.030,
                                ),
                                Obx(
                                  () => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      controller.id_front.value.isNotEmpty
                                          ? imageStyple(
                                              width: width,
                                              height: height,
                                              path: controller.id_front.value)
                                          : picStyple(
                                              width: width,
                                              height: height,
                                              from: 'id_front',
                                              title: 'ID Card Front Picture'),
                                      controller.id_back.value.isNotEmpty
                                          ? imageStyple(
                                              width: width,
                                              height: height,
                                              path: controller.id_back.value)
                                          : picStyple(
                                              width: width,
                                              height: height,
                                              from: 'id_back',
                                              title: 'ID Card Back Picture'),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.030,
                                ),
                                Obx(
                                  () => controller.live_image.value.isNotEmpty
                                      ? imageStyple(
                                          width: width,
                                          height: height,
                                          path: controller.live_image.value)
                                      : picStyple(
                                          width: width,
                                          height: height,
                                          from: 'live',
                                          title: 'Capture Live Image'),
                                ),
                                SizedBox(
                                  height: height * 0.030,
                                ),
                                Obx(
                                  () => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      controller.pasport_first_page.value
                                              .isNotEmpty
                                          ? imageStyple(
                                              width: width,
                                              height: height,
                                              path: controller
                                                  .pasport_first_page.value)
                                          : picStyple(
                                              width: width,
                                              height: height,
                                              from: 'p_first',
                                              title: 'Passport First Page'),
                                      controller
                                              .pasport_signatue.value.isNotEmpty
                                          ? imageStyple(
                                              width: width,
                                              height: height,
                                              path: controller
                                                  .pasport_signatue.value)
                                          : picStyple(
                                              width: width,
                                              from: 'p_last',
                                              height: height,
                                              title: 'Passport Signature Page'),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.020,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: settingGreyColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.5),
                                          offset: Offset(0.2, 0.2), //(x,y)
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      cursorColor: Colors.black,
                                      maxLines: 5,
                                      keyboardType: TextInputType.text,
                                      controller: controller.messageCon,
                                      textInputAction: TextInputAction.done,
                                      decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 15,
                                              bottom: 11,
                                              top: 11,
                                              right: 15),
                                          hintStyle: TextStyle(
                                              color: primaryColor,
                                              fontSize: 12),
                                          hintText: "Enter message here"),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.030,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (controller.id_front.value.isNotEmpty) {
                                      if (controller.id_back.value.isNotEmpty) {
                                        if (controller
                                            .live_image.value.isNotEmpty) {
                                          if (controller.pasport_first_page
                                              .value.isNotEmpty) {
                                            if (controller.pasport_signatue
                                                .value.isNotEmpty) {
                                              setState(() {
                                                circule = true;
                                              });
                                              String id_front =
                                                  await createStory(controller
                                                      .id_front.value);
                                              String id_back =
                                                  await createStory(
                                                      controller.id_back.value);
                                              String live = await createStory(
                                                  controller.live_image.value);
                                              String p_first =
                                                  await createStory(controller
                                                      .pasport_first_page
                                                      .value);
                                              String p_second =
                                                  await createStory(controller
                                                      .pasport_signatue.value);

                                              await updatePrivicy(
                                                  id_fisrt: id_front,
                                                  id_back: id_back,
                                                  live: live,
                                                  p_first: p_first,
                                                  p_second: p_second);
                                              setState(() {
                                                circule = false;
                                              });
                                            } else {
                                              snackBarFailer(
                                                  'Please add copy of signature page.');
                                            }
                                          } else {
                                            snackBarFailer(
                                                'Please add first page of passport.');
                                          }
                                        } else {
                                          snackBarFailer(
                                              'Please Captured Live image.');
                                        }
                                      } else {
                                        snackBarFailer(
                                            'Please select back copy of id card.');
                                      }
                                    } else {
                                      snackBarFailer(
                                          'Please select front copy of id card.');
                                    }
                                  },
                                  child: Container(
                                    height: height * 0.060,
                                    width: width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
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
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.050,
                                ),
                              ],
                            ),
                          ),
                        ),
        )),
      );
    });
  }

  Widget picStyple(
      {double? height, double? width, String? title, String? from}) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                elevation: 0,
                backgroundColor: Colors.black.withOpacity(0.5),
                insetPadding: EdgeInsets.symmetric(horizontal: width! / 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                //this right here
                child: Container(
                  height: height! / 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          controller.onImageButtonPressed(
                              source: ImageSource.camera, where: from);
                        },
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: height * 0.050,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(30)),
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.1),
                            child: Center(
                              child: Text(
                                'CAMERA',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: AppFonts.segoeui,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          controller.onImageButtonPressed(
                              source: ImageSource.gallery, where: from);
                        },
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: height * 0.050,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(30)),
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.1),
                            child: Center(
                              child: Text(
                                'GALLERY',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontFamily: AppFonts.segoeui,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            });
      },
      child: Container(
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
      ),
    );
  }

  Widget imageStyple({double? height, double? width, String? path}) {
    return Container(
      height: height! * 0.180,
      width: width! * 0.4,
      child: Image.file(File('$path')),
      decoration: BoxDecoration(
          color: settingGreyColor, borderRadius: BorderRadius.circular(10)),
    );
  }
}
