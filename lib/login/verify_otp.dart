import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rooya_app/login/new_password.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/baseUrl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class VerifyOTP extends StatefulWidget {
  String? userInfo;

  VerifyOTP({Key? key,this.userInfo}):super(key: key);

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
    return  ProgressHUD(
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
                'Enter OTP',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 24,
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.0.h,),
              Text(
                'OTP sent to your ${widget.userInfo}',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 10,
                  color: const Color(0xff000000),
                  height: 1.25,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0.h,),
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
                    fieldHeight: 13.0.w,
                    fieldWidth: 20.0.w,
                    activeFillColor:
                    hasError ? Colors.orange : Colors.white,
                    inactiveColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedColor: Colors.white,
                    selectedFillColor: Colors.white
                  ),
                  cursorColor: Colors.black,
                  animationDuration: Duration(milliseconds: 300),
                  textStyle: TextStyle(
                  fontFamily: 'Segoe UI',
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
                     otpText=value;
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
              isError?Text(errorMsg,
                style:  TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 10.0.sp,
                  color: Colors.red,
                ),):Container(),
              isError? SizedBox(height: 3.0.h,):Container(),
              InkWell(
                onTap: (){
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
    ));
  }
  Future<void> verifyOTP() async {
    setState(() {
      isLoading = true;
    });
    final response =
    await http.post(Uri.parse('${baseUrl}verifyotp${code}'), headers: {
      "Accept": "*/*"
    }, body: jsonEncode({
      "userinfo": widget.userInfo,
      "userotp":otpText
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
          Get.to(() => NewPassword(userInfo:widget.userInfo));
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
