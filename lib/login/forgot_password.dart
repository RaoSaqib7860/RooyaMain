import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rooya_app/login/verify_otp.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/baseUrl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController mUserInfoController = TextEditingController();
  bool isLoading = false;
  bool isError = false;
  String errorMsg = '';
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child:Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.green, //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset('assets/images/logo.png',
          height: 8.0.h,),

      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w,vertical: 5.0.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Forgot Password?',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 24,
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0.h,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x290bab0d),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: mUserInfoController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.emailAddress,
                  // inputFormatters: [
                  //   new FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  // ],
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (value) {
                  //   return value.startsWith('03')
                  //       ? value.length == 11
                  //           ? null
                  //           : 'Mobile number is not valid'
                  //       : 'Mobile number is not valid';
                  // },
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    labelText: 'Email/Mobile Number',
                    hintText: '03331234567',
                    labelStyle: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 13,
                      color: const Color(0xff1e1e1e),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5.0.h,
              ),
              isError?Text(errorMsg,
                style:  TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 10.0.sp,
                  color: Colors.red,
                ),):Container(),
              isError? SizedBox(height: 3.0.h,):Container(),
              InkWell(
                onTap: (){
                 forgotPassword();
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
                        fontFamily: 'Segoe UI',
                        fontSize: 14,
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
    ));
  }
  Future<void> forgotPassword() async {
    setState(() {
      isLoading = true;
    });
    final response =
    await http.post(Uri.parse('${baseUrl}forgetpassword${code}'), headers: {
      "Accept": "*/*"
    }, body: jsonEncode({
      "userinfo": mUserInfoController.text
    }));

    setState(() {
      isLoading = false;
    });

    print(response.request);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          Get.to(() => VerifyOTP(userInfo:mUserInfoController.text ,));
        });
      } else {
        setState(() {
          isError = true;
          errorMsg = data['message'] ?? '';
        });
      }
    }
  }
}
