import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/AppThemes/AppThemes.dart';
import 'package:rooya_app/Screens/Settings/Components/Componenets.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/SnackbarCustom.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentpasswordCon = TextEditingController();
  TextEditingController newpasswordCon = TextEditingController();
  TextEditingController re_passwordCon = TextEditingController();
  bool loading = false;
  GetStorage storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return ProgressHUD(
      inAsyncCall: loading,
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
            'Change Password',
            style: TextStyle(
                fontFamily: AppFonts.segoeui,
                fontSize: 14,
                color: Colors.black),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.030),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.010,
              ),
              TextFieldsProfileCustom(
                controller: currentpasswordCon,
                hint: 'Current Password'.tr,
                uperhint: 'Current Password'.tr,
                width: width,
                sufixIcon: Icon(
                  CupertinoIcons.eye_solid,
                  color: greenColor,
                ),
              ),
              SizedBox(
                height: height * 0.020,
              ),
              TextFieldsProfileCustom(
                controller: newpasswordCon,
                hint: 'New Password'.tr,
                uperhint: 'New Password'.tr,
                width: width,
                sufixIcon: Icon(
                  CupertinoIcons.eye_solid,
                  color: greenColor,
                ),
              ),
              SizedBox(
                height: height * 0.020,
              ),
              TextFieldsProfileCustom(
                controller: re_passwordCon,
                hint: 'Re-Enter New Password'.tr,
                uperhint: 'Re-Enter New Password'.tr,
                width: width,
                sufixIcon: Icon(
                  CupertinoIcons.eye_solid,
                  color: greenColor,
                ),
              ),
              SizedBox(
                height: height * 0.020,
              ),
              switchwithRow(
                  height: height,
                  width: width,
                  istrue: true,
                  onchange: (v) {},
                  title: 'Two Factor Authentication'),
              SizedBox(
                height: height * 0.030,
              ),
              InkWell(
                onTap: () async {
                  if (newpasswordCon.text == re_passwordCon.text) {
                    setState(() {
                      loading = true;
                    });
                    await updatePrivicy();
                    setState(() {
                      loading = false;
                    });
                  } else {
                    snackBarFailer('Your password did not match');
                  }
                },
                child: Container(
                  height: height * 0.060,
                  width: width,
                  child: Center(
                    child: Text(
                      'UPDATE',
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
              ),
              SizedBox(
                height: height * 0.050,
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future<void> updatePrivicy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}changePassword$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "userinfo": await prefs.getString('user_email'),
          "old_password": currentpasswordCon.text,
          "new_password": newpasswordCon.text
        }));
    print('response is = ${response.body}');
  }
}

class TextFieldsProfileCustom extends StatefulWidget {
  TextFieldsProfileCustom(
      {Key? key,
      this.hint,
      this.controller,
      this.icon,
      this.color,
      this.uperhint,
      this.obsucreTextUp = false,
      this.isnumber = false,
      this.enable = true,
      this.isArabic = false,
      this.width,
      this.sufixIcon})
      : super(key: key);
  final hint;
  final IconData? icon;
  final width;
  final TextEditingController? controller;
  final color;
  final String? uperhint;
  final bool obsucreTextUp;
  final bool isnumber;
  final bool enable;
  final bool isArabic;
  final Widget? sufixIcon;

  @override
  _TextFieldsProfileCustomState createState() =>
      _TextFieldsProfileCustomState();
}

class _TextFieldsProfileCustomState extends State<TextFieldsProfileCustom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: widget.width * 0.015),
          child: Text(
            '${widget.uperhint}',
            style: TextStyle(
                fontSize: 11,
                letterSpacing: 0.4,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.segoeui),
          ),
        ),
        SizedBox(
          height: Get.height / 130,
        ),
        Container(
          height: Get.height / 16,
          width: widget.width,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.green.withOpacity(0.10),
                    offset: Offset(4, 4),
                    blurRadius: 3),
                BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    offset: Offset(-0.5, -0.5),
                    blurRadius: 1)
              ],
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.obsucreTextUp,
              enabled: widget.enable,
              keyboardType:
                  widget.isnumber == true ? TextInputType.number : null,
              textAlign: TextAlign.start,
              style: TextStyle(),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    top: 10,
                    left: widget.width * 0.030,
                    right: widget.width * 0.030,
                  ),
                  border: InputBorder.none,
                  suffixIcon: widget.sufixIcon,
                  hintText: '${widget.hint}',
                  hintStyle: TextStyle(
                      fontSize: 10,
                      fontFamily: AppFonts.segoeui,
                      letterSpacing: 0.5,
                      color: Colors.black54,
                      fontWeight: FontWeight.w300)),
            ),
          ),
        ),
      ],
    );
  }
}
