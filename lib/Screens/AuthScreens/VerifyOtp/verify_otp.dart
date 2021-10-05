import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rooya_app/Screens/AuthScreens/SignIn/sign_in.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/SnackbarCustom.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../new_password.dart';
import '../sign_in_tabs_handle.dart';

class VerifyOTP extends StatefulWidget {
  String? userInfo;
  final bool? forgot;

  VerifyOTP({Key? key, this.userInfo, this.forgot = false}) : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  TextEditingController textEditingController = TextEditingController();

  // StreamController<ErrorAnimationType> errorController;
  final formKey = GlobalKey<FormState>();
  bool hasError = false;
  String currentText = "";
  String otpText = "";

  bool isLoading = false;
  bool isError = false;
  String errorMsg = '';

  @override
  void initState() {
    //  errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    // errorController.close();

    super.dispose();
  }

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
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 8.0.h,
                    ),
                    SizedBox(
                      height: 5.0.h,
                    ),
                    Text(
                      'Enter OTP',
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
                      height: 1.0.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Please check your messages & enter the verification code we just sent you to ${widget.userInfo}',
                        style: TextStyle(
                          fontFamily: AppFonts.segoeui,
                          fontSize: 11,
                          color: const Color(0xff000000),
                          height: 1.25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Form(
                      key: formKey,
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: TextStyle(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 4,
                        obscureText: false,
                        obscuringCharacter: '*',
                        animationType: AnimationType.fade,
                        validator: (v) {
                          return null;
                        },
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(10.0),
                            // color: const Color(0xffffffff),
                            fieldHeight: 15.0.w,
                            fieldWidth: 15.0.w,
                            activeFillColor:
                                hasError ? Colors.orange : Colors.white,
                            inactiveColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            selectedColor: Colors.white,
                            selectedFillColor: Colors.white),
                        cursorColor: Colors.black,
                        animationDuration: Duration(milliseconds: 300),
                        textStyle: TextStyle(
                          fontFamily: AppFonts.segoeui,
                          fontSize: 16.0.sp,
                          color: const Color(0xff5a5a5a),
                        ),
                        //  backgroundColor: Colors.blue.shade50,
                        enableActiveFill: true,
                        //  errorAnimationController: errorController,
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        boxShadows: [
                          BoxShadow(
                            color: const Color(0x290bab0d),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                        onCompleted: (value) {
                          setState(() {
                            otpText = value;
                          });
                        },
                        // onTap: () {
                        //   print("Pressed");
                        // },
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            currentText = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 5.0.h,
                    ),
                    isError
                        ? Text(
                            errorMsg,
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
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
                        // Get.to(()=>NewPassword(userInfo:widget.userInfo));
                        verifyOTP();
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
          ),
        ));
  }

  Future<void> verifyOTP() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse('${baseUrl}verifyotp$code'),
        headers: {"Accept": "*/*"},
        body: jsonEncode({"userinfo": widget.userInfo, "userotp": otpText}));

    setState(() {
      isLoading = false;
    });
    print(response.request);
    print(response.statusCode);
    print(response.body);
    final data = jsonDecode(response.body);
    if (data['result'] == 'success') {
      if(widget.forgot!){
        Get.offAll(NewPassword(userInfo: '${widget.userInfo}',));
      }else{
        Get.offAll(SignInTabsHandle());
      }
      snackBarSuccess('${data['message']}');
    } else {
      snackBarFailer('${data['messagew']}');
    }
  }
}
