import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rooya_app/login/password_changed.dart';
import 'package:http/http.dart' as http;
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/baseUrl.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:sizer/sizer.dart';

class NewPassword extends StatefulWidget {
  String? userInfo;

  NewPassword({Key? key, this.userInfo}) : super(key: key);

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isError = false;
  String errorMsg = '';
  TextEditingController mPasswordController = TextEditingController();
  TextEditingController mConfirmPasswordController = TextEditingController();
  bool isPasswordShow= true;
  bool isConfirmPasswordShow= true;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(
              color: Colors.green, //change your color here
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Image.asset(
              'assets/images/logo.png',
              height: 8.0.h,
            ),
          ),
          body: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enter New Password?',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 24,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                          controller: mPasswordController,
                          obscureText: isPasswordShow,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return value!.length>7?RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                    .hasMatch(value)
                                ? null
                                : 'Password must contains Uppercase,\nLowercase, Number, Special Character':'Password is too short';
                          },
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            labelText: 'New Password',
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
                        height: 2.0.h,
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
                          controller: mConfirmPasswordController,
                          validator: (value) {
                            return value!.isNotEmpty &&
                                    value == mPasswordController.text
                                ? null
                                : 'Password not match';
                          },
                          obscureText: isConfirmPasswordShow,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            labelText: 'Confirm Password',
                            hintText: '',
                            labelStyle: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 13,
                              color: const Color(0xff1e1e1e),
                            ),

                              suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    isConfirmPasswordShow=!isConfirmPasswordShow;
                                  });
                                },
                                icon: Icon(Icons.remove_red_eye,
                                  color: isConfirmPasswordShow?Colors.grey[500]:primaryColor,),
                              )
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0.h,
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            newPassword();
                          }
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
          ),
        ));
  }

  Future<void> newPassword() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse('${baseUrl}updatepass${code}'),
        headers: {
          "Accept": "*/*"
        },
        body: jsonEncode({
          "userinfo": widget.userInfo,
          "password": mPasswordController.text
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
           Get.to(() => PasswordChanged());
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
