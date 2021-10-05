import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/Screens/AuthScreens/VerifyOtp/verify_otp.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/SnackbarCustom.dart';
import 'package:rooya_app/widgets/CustomTextFields.dart';
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
                  Get.back();
                },
              ),
            ),
            body: Center(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 8.0.h,
                    ),
                    SizedBox(
                      height: 5.0.h,
                    ),
                    Text(
                      'Forgot Password?',
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
                      height: 10.0.h,
                    ),
                    CustomTextFields(
                      controller: mUserInfoController,
                      labelText: 'Email/Mobile Number',
                    ),
                    SizedBox(
                      height: 5.0.h,
                    ),
                    isError
                        ? Text(
                            errorMsg,
                            style: TextStyle(
                              fontFamily: AppFonts.segoeui,
                              fontSize: 10.0.sp,
                              color: Colors.red,
                            ),
                          )
                        : Container(),
                    isError
                        ? SizedBox(
                            height: 3.0.h,
                          )
                        : Container(),
                    InkWell(
                      onTap: () {
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
        ));
  }

  Future<void> forgotPassword() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse('${baseUrl}forgetpassword$code'),
        headers: {"Accept": "*/*"},
        body: jsonEncode({"userinfo": mUserInfoController.text}));

    setState(() {
      isLoading = false;
    });

    print(response.request);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        Get.to(() => VerifyOTP(
              userInfo: mUserInfoController.text,
              forgot: true,
            ));
        snackBarSuccess('${data['message']}');
      } else {
        snackBarFailer('${data['message']}');
      }
    }
  }
}
