import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rooya_app/dashboard/dashboard.dart';
import 'package:rooya_app/login/forgot_password.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/baseUrl.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  Function? onSignUp;
  SignIn({Key? key,this.onSignUp}):super(key: key);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordShow= true;
  bool isLoading = false;
  bool isError = false;
  String errorMsg = '';
  TextEditingController mUserInfoController = TextEditingController();
  TextEditingController mPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0.w),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0.h,
                    ),
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
                        //  hintText: '+923331234567',
                          labelStyle: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 13,
                            color: const Color(0xff1e1e1e),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.0.h,
                    ),
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
                        controller: mPasswordController,
                        obscureText: isPasswordShow,
                        cursorColor: Colors.black,
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
                          labelText: 'Password',
                          hintText: '',
                          labelStyle: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 13,
                            color: const Color(0xff1e1e1e),
                          ),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                isPasswordShow=!isPasswordShow;
                              });
                            },
                            icon: Icon(Icons.remove_red_eye,
                            color: isPasswordShow?Colors.grey[500]:primaryColor,),
                          )
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.0.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ForgotPassword());
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 14,
                            color: const Color(0xfff93d3d),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                     SizedBox(height: 3.0.h,),
                    isError?Text(errorMsg,
                      style:  TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 10.0.sp,
                        color: Colors.red,
                      ),):Container(),
                    isError? SizedBox(height: 3.0.h,):Container(),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          signIn();
                        }
                        //Get.offAll(()=>Dashboard());
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
                            'LOG IN',
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
                    SizedBox(
                      height: 3.0.h,
                    ),
                    SizedBox(
                      width: 218.0,
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 12,
                            color: const Color(0xff000000),
                          ),
                          children: [
                            TextSpan(
                              text: 'Do not have an Account? ',
                            ),
                            TextSpan(
                              recognizer: new TapGestureRecognizer()..onTap = () {
                                widget.onSignUp!;
                              },
                              text: 'Sign up',
                              style: TextStyle(
                                color: const Color(0xff0bab0d),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 3.0.h,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'or join with',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 18,
                            color: const Color(0xff000000),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          width: 5.0.w,
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/icons/fb.png'))),
                        ),
                        SizedBox(
                          width: 2.0.w,
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/icons/google.png'))),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });
    print({
      "userinfo": mUserInfoController.text,
      "userpassword": mPasswordController.text,
      "devicetoken": 'mPasswordController.text'
    });
    final response =
        await http.post(Uri.parse('${baseUrl}login${code}'), headers: {
          "Content-Type": "application/json",
    }, body: jsonEncode({
          "userinfo": mUserInfoController.text,
          "userpassword": mPasswordController.text,
          "devicetoken": 'mPasswordController.text'
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setInt('user_id', data['data'][0]['user_id']);
          prefs.setString('user_name', data['data'][0]['user_name']);
          prefs.setString('user_email', data['data'][0]['user_email']);
          prefs.setInt('user_phone', data['data'][0]['user_phone']);
          prefs.setString('user_firstname', data['data'][0]['user_firstname']);
          prefs.setString('user_lastname', data['data'][0]['user_lastname']);
          prefs.setString('token', data['mytoken']);
          Get.offAll(() => Dashboard());
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
