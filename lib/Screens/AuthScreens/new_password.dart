import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rooya_app/Screens/AuthScreens/password_changed.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/SnackbarCustom.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/widgets/CustomTextFields.dart';
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
  bool isPasswordShow = true;
  bool isConfirmPasswordShow = true;

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
            body: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.0.w,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 8.0.h,
                      ),
                      SizedBox(
                        height: 5.0.h,
                      ),
                      Text(
                        'Enter New Password?',
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
                        controller: mPasswordController,
                        labelText: 'New Password',
                        visible: !isPasswordShow ? false : true,
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (isPasswordShow) {
                              isPasswordShow = false;
                            } else {
                              isPasswordShow = true;
                            }
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: isPasswordShow
                                ? Colors.grey[500]
                                : primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.0.h,
                      ),
                      CustomTextFields(
                        controller: mConfirmPasswordController,
                        labelText: 'Confirm Password',
                        visible: !isConfirmPasswordShow ? false : true,
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (isConfirmPasswordShow) {
                              isConfirmPasswordShow = false;
                            } else {
                              isConfirmPasswordShow = true;
                            }
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: isConfirmPasswordShow
                                ? Colors.grey[500]
                                : primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0.h,
                      ),
                      InkWell(
                        onTap: () {
                          if (mPasswordController.text.trim().isNotEmpty &&
                              mConfirmPasswordController.text
                                  .trim()
                                  .isNotEmpty) {
                            if (mPasswordController.text ==
                                mConfirmPasswordController.text) {
                              newPassword();
                            } else {
                              snackBarFailer('Password did not match');
                            }
                          } else {
                            snackBarFailer('Enter password first');
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
          ),
        ));
  }

  Future<void> newPassword() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse('${baseUrl}updatepass$code'),
        headers: {"Accept": "*/*"},
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
        Get.to(() => PasswordChanged());
        snackBarSuccess('${data['message']}');
      } else {
        snackBarFailer('${data['message']}');
      }
    }
  }
}
