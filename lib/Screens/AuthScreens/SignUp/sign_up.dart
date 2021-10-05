import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rooya_app/ApiUtils/AuthUtils.dart';
import 'package:rooya_app/Screens/AuthScreens/SignUp/SignUpController.dart';
import 'package:rooya_app/phone_validator/utils/phone_number.dart';
import 'package:rooya_app/phone_validator/widgets/input_widget.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/SnackbarCustom.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/widgets/CustomTextFields.dart';
import 'package:sizer/sizer.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  SignUpController controller = SignUpController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ProgressHUD(
          inAsyncCall: controller.isLoading.value,
          opacity: 0.7,
          child: Scaffold(
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.w),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sign up as:',
                        style: TextStyle(
                          fontFamily: AppFonts.segoeui,
                          fontSize: 12,
                          color: const Color(0xff000000),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            controller.individual.value = true;
                          },
                          child: Row(
                            children: [
                              controller.individual.value
                                  ? customRadio(
                                      color: primaryColor, isActive: true)
                                  : customRadio(
                                      color: greyColor, isActive: false),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Individual',
                                style: TextStyle(
                                  fontFamily: AppFonts.segoeui,
                                  fontSize: 10,
                                  color: const Color(0xff000000),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.individual.value = false;
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              !controller.individual.value
                                  ? customRadio(
                                      color: primaryColor, isActive: true)
                                  : customRadio(
                                      color: greyColor, isActive: false),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Business',
                                style: TextStyle(
                                  fontFamily: AppFonts.segoeui,
                                  fontSize: 10,
                                  color: const Color(0xff000000),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Form(
                      child: Column(
                        children: [
                          CustomTextFields(
                            controller: controller.mFirstNameController,
                            labelText: 'First Name',
                          ),
                          SizedBox(
                            height: 1.5.h,
                          ),
                          CustomTextFields(
                            controller: controller.mLastNameController,
                            labelText: 'Last Name',
                          ),
                          SizedBox(
                            height: 1.5.h,
                          ),
                          CustomTextFields(
                            controller: controller.mUserNameController,
                            labelText: 'Username',
                          ),
                          SizedBox(
                            height: 1.5.h,
                          ),
                          CustomTextFields(
                            controller: controller.mDOBController,
                            labelText: 'Date of Birth',
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                color: primaryColor,
                              ),
                              onPressed: () {
                                _selectDate(context);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 1.5.h,
                          ),
                          CustomTextFields(
                            controller: controller.mEmailController,
                            labelText: 'Email Address',
                          ),
                          SizedBox(
                            height: 1.5.h,
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
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  print(number.phoneNumber);
                                  changeNumber(
                                      number.phoneNumber, number.dialCode);
                                },
                                onInputValidated: (bool value) {
                                  print(value);
                                },
                                ignoreBlank: false,
                                autoValidate: false,
                                initialValue: controller.phonenumber,
                                isEnabled: true,
                                inputDecoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    fontFamily: AppFonts.segoeui,
                                    fontSize: 13,
                                    color: const Color(0xff1e1e1e),
                                  ),
                                  labelText: 'Phone number',
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                                hintText: 'Phone number',
                                textStyle: TextStyle(
                                  fontFamily: AppFonts.segoeui,
                                  fontSize: 13,
                                  color: const Color(0xff1e1e1e),
                                ),
                                inputBorder: InputBorder.none,
                                // countries: countryList,
                                textFieldController:
                                    controller.mMobileController,
                                //inputBorder: OutlineInputBorder(),
                                selectorType: PhoneInputSelectorType.DIALOG,
                              )),
                          SizedBox(
                            height: 1.5.h,
                          ),
                          CustomTextFields(
                            controller: controller.mPasswordController,
                            labelText: 'Password',
                            visible: true,
                          ),
                          SizedBox(
                            height: 1.5.h,
                          ),
                          CustomTextFields(
                            controller: controller.mConfirmPasswordController,
                            labelText: 'Confirm Password',
                            visible: controller.isConfirmPasswordShow.value
                                ? false
                                : true,
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (controller.isConfirmPasswordShow.value) {
                                  controller.isConfirmPasswordShow.value =
                                      false;
                                } else {
                                  controller.isConfirmPasswordShow.value = true;
                                }
                              },
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: !controller.isConfirmPasswordShow.value
                                    ? Colors.grey[500]
                                    : primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    Text(
                      'By clicking Agree and Join, you agree to the Rooya\nAgreement, Privacy Policy and Cookies Policy',
                      style: TextStyle(
                        fontFamily: AppFonts.segoeui,
                        fontSize: 10,
                        color: const Color(0xff1e1e1e),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 3.0.h,
                    ),
                    InkWell(
                      onTap: () {
                        if (controller.mFirstNameController.text
                            .trim()
                            .isNotEmpty) {
                          if (controller.mLastNameController.text
                              .trim()
                              .isNotEmpty) {
                            if (controller.mUserNameController.text
                                .trim()
                                .isNotEmpty) {
                              if (controller.mMobileController.text
                                  .trim()
                                  .isNotEmpty) {
                                if (controller.mEmailController.text
                                    .trim()
                                    .isNotEmpty) {
                                  if (controller.mPasswordController.text
                                          .trim()
                                          .isNotEmpty &&
                                      controller.mConfirmPasswordController.text
                                          .trim()
                                          .isNotEmpty) {
                                    if (controller.mPasswordController.text ==
                                        controller
                                            .mConfirmPasswordController.text) {
                                      AuthUtils.signUp(controller: controller);
                                    } else {
                                      snackBarFailer('Password did not match');
                                    }
                                  } else {
                                    snackBarFailer(
                                        'Please enter password first');
                                  }
                                } else {
                                  snackBarFailer('Please enter email address');
                                }
                              } else {
                                snackBarFailer('Please enter mobile number');
                              }
                            } else {
                              snackBarFailer('Please enter user name');
                            }
                          } else {
                            snackBarFailer('Please enter your last name');
                          }
                        } else {
                          snackBarFailer('Please enter your First name');
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
                            'AGREE & JOIN',
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
                    SizedBox(
                      height: 3.0.h,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'or join with',
                          style: TextStyle(
                            fontFamily: AppFonts.segoeui,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff000000),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          width: 5.0.w,
                        ),
                        SvgPicture.asset('assets/svg/fb.svg'),
                        SizedBox(
                          width: 5.0.w,
                        ),
                        SvgPicture.asset('assets/svg/google.svg'),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (BuildContext? context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: primaryColor,
              accentColor: primaryColor,
              colorScheme: ColorScheme.light(primary: primaryColor),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: controller.dateSelected,
        firstDate: DateTime(1901, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != controller.dateSelected)
      controller.dateSelected = picked;
    controller.mDOBController.text = picked!.day.toString() +
        '-' +
        picked.month.toString() +
        '-' +
        picked.year.toString();
  }

  void changeNumber(text, dailcode) {
    controller.validPhone.value = text;
    controller.validPhoneCode.value = dailcode;
  }

  Widget customRadio({bool? isActive, Color? color}) {
    if (!isActive!) {
      return Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color!, width: 2)),
      );
    } else {
      return Container(
        height: 15,
        width: 15,
        child: Container(
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color!, width: 2)),
      );
    }
  }
}
