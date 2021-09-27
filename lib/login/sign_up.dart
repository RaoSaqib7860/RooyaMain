import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rooya_app/dashboard/dashboard.dart';
import 'package:rooya_app/login/sign_in_tabs_handle.dart';
import 'package:rooya_app/phone_validator/utils/phone_number.dart';
import 'package:rooya_app/phone_validator/widgets/input_widget.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/baseUrl.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordShow= true;
  bool isConfirmPasswordShow= true;
  int _groupValue = 0;
  bool isLoading=false;
  bool isError=false;
  String errorMsg='';
  DateTime dateSelected= DateTime.now();
  TextEditingController mFirstNameController= TextEditingController();
  TextEditingController mLastNameController= TextEditingController();
  TextEditingController mUserNameController= TextEditingController();
  TextEditingController mDOBController= TextEditingController();
  TextEditingController mEmailController= TextEditingController();
  TextEditingController mMobileController= TextEditingController();
  TextEditingController mPasswordController= TextEditingController();
  TextEditingController mConfirmPasswordController= TextEditingController();

  String validPhone = "";
  static String validPhoneCode = "+971";
  PhoneNumber phonenumber = PhoneNumber(isoCode: 'AE');

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child:Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w,vertical: 5.0.w),
          child: Column(
            children: [
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     'Sign up as:',
              //     style: TextStyle(
              //       fontFamily: 'Segoe UI',
              //       fontSize: 14,
              //       color: const Color(0xff000000),
              //       fontWeight: FontWeight.w600,
              //     ),
              //     textAlign: TextAlign.left,
              //   ),
              // ),
              // SizedBox(height: 1.5.h,),
              // Row(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Expanded(
              //       flex: 1,
              //       child: RadioListTile(
              //         value: 0,
              //         groupValue: _groupValue,
              //         activeColor: primaryColor,
              //         onChanged: (newValue) => setState(() => _groupValue = newValue),
              //         title: Text(
              //           'Individual',
              //           style: TextStyle(
              //             fontFamily: 'Segoe UI',
              //             fontSize: 10,
              //             color: const Color(0xff222222),
              //           ),
              //           textAlign: TextAlign.left,
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       flex: 1,
              //       child: RadioListTile(
              //         value: 1,
              //         groupValue: _groupValue,
              //         activeColor: primaryColor,
              //         onChanged: (newValue) => setState(() => _groupValue = newValue),
              //         title: Text(
              //           'Business',
              //           style: TextStyle(
              //             fontFamily: 'Segoe UI',
              //             fontSize: 10,
              //             color: const Color(0xff222222),
              //           ),
              //           textAlign: TextAlign.left,
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              _groupValue==0? Form(
                key: _formKey,
                child: Column(
                  children: [

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
                         controller: mFirstNameController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return value!.isNotEmpty
                              ?null:'Please enter first name';
                        },
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          labelText: 'First Name',
                          labelStyle: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 13,
                            color: const Color(0xff1e1e1e),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.5.h,),
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
                         controller: mLastNameController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return value!.isNotEmpty
                              ?null:'Please enter last name';
                        },
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          labelText: 'Last Name',
                          labelStyle: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 13,
                            color: const Color(0xff1e1e1e),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.5.h,),
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
                         controller: mUserNameController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return value!.isNotEmpty
                              ?null:'Please enter username';
                        },
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          labelText: 'Username',
                          labelStyle: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 13,
                            color: const Color(0xff1e1e1e),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.5.h,),
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
                         controller: mDOBController,
                        readOnly: true,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return value!.isNotEmpty
                              ?null:'Please select date of birth';
                        },
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          labelText: 'Date of Birth',
                          labelStyle: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 13,
                            color: const Color(0xff1e1e1e),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today,color: primaryColor,),
                            onPressed: (){
                              _selectDate(context);
                            },
                          )
                        ),
                      ),
                    ),
                    SizedBox(height: 1.5.h,),
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
                         controller: mEmailController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value!)?null:'Please enter a valid email';
                          // return value.isNotEmpty
                          //     ?null:'Please enter a valid email';

                        },
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          labelText: 'Email Address',
                          hintText: '',
                          labelStyle: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 13,
                            color: const Color(0xff1e1e1e),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.5.h,),
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
                          changeNumber(number.phoneNumber, number.dialCode);
                        },
                        onInputValidated: (bool value) {
                          print(value);
                        },
                        ignoreBlank: false,
                        autoValidate: false,
                        initialValue: phonenumber,
                        isEnabled: true,
                        inputDecoration: InputDecoration(
                          labelStyle: TextStyle(color: primaryColor),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        // countries: countryList,
                        textFieldController: mMobileController,
                        //inputBorder: OutlineInputBorder(),
                        selectorType: PhoneInputSelectorType.DIALOG,
                      )
                      // TextFormField(
                      //    controller: mMobileController,
                      //   cursorColor: Colors.black,
                      //   keyboardType: TextInputType.phone,
                      //   inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                      //   validator: (value) {
                      //     return value.startsWith('03')?value.length ==11
                      //         ?null:'Mobile number is not valid'
                      //         : 'Mobile number is not valid';
                      //   },
                      //   decoration: new InputDecoration(
                      //     border: InputBorder.none,
                      //     focusedBorder: InputBorder.none,
                      //     enabledBorder: InputBorder.none,
                      //     errorBorder: InputBorder.none,
                      //     disabledBorder: InputBorder.none,
                      //     contentPadding: EdgeInsets.only(
                      //         left: 15, bottom: 11, top: 11, right: 15),
                      //     labelText: 'Mobile Number',
                      //     hintText: '03331234567',
                      //     labelStyle: TextStyle(
                      //       fontFamily: 'Segoe UI',
                      //       fontSize: 13,
                      //       color: const Color(0xff1e1e1e),
                      //     ),
                      //   ),
                      // ),
                    ),
                    SizedBox(height: 1.5.h,),
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
                        validator: (value) {
                          return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value!)?null:'Password must contains Uppercase,\nLowercase, Number, Special Character';
                        },
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
                    SizedBox(height: 1.5.h,),
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
                        obscureText: isConfirmPasswordShow,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,

                        validator: (value) {
                          return value!.isNotEmpty && value==mPasswordController.text?null:'Password not match';
                        },
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

                  ],
                ),
              ):
              Column(
                children: [

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
                      // controller: mMobileNumber,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value!.startsWith('03')?value.length ==11
                            ?null:'Mobile number is not valid'
                            : 'Mobile number is not valid';
                      },
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        labelText: 'Business Name',
                        labelStyle: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 13,
                          color: const Color(0xff1e1e1e),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h,),
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
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: 2.0.w),
                        //filled: true,
                        // fillColor: primaryColor,
                        labelText: 'Business Type',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: InputBorder.none,
                      ),
                      isExpanded: true,
                      iconEnabledColor: primaryColor,
                      iconSize: 5.0.h,
                      items: ['A','B','C'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) async {

                      },
                      // value:'Rawalpindi' ,
                    ),
                  ),
                  SizedBox(height: 1.5.h,),
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
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: 2.0.w),
                        //filled: true,
                        // fillColor: primaryColor,
                        labelText: 'City',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: InputBorder.none,
                      ),
                      isExpanded: true,
                      iconEnabledColor: primaryColor,
                      iconSize: 5.0.h,
                      items: ['A','B','C'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) async {

                      },
                      // value:'Rawalpindi' ,
                    ),
                  ),
                  SizedBox(height: 1.5.h,),
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
                      // controller: mMobileNumber,
                      enabled: false,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value!.startsWith('03')?value.length ==11
                            ?null:'Mobile number is not valid'
                            : 'Mobile number is not valid';
                      },
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        labelText: 'Select Location on Google',
                        labelStyle: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 13,
                          color: const Color(0xff1e1e1e),
                        ),
                        suffixIcon: Icon(Icons.arrow_right, color: primaryColor,size: 5.0.h,)
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h,),
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
                      // controller: mMobileNumber,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value!.startsWith('03')?value.length ==11
                            ?null:'Mobile number is not valid'
                            : 'Mobile number is not valid';
                      },
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 13,
                          color: const Color(0xff1e1e1e),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h,),
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
                      // controller: mMobileNumber,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value!.startsWith('03')?value.length ==11
                            ?null:'Mobile number is not valid'
                            : 'Mobile number is not valid';
                      },
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        labelText: 'Email Address',
                        hintText: '',
                        labelStyle: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 13,
                          color: const Color(0xff1e1e1e),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h,),
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
                      // controller: mMobileNumber,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value!.startsWith('03')?value.length ==11
                            ?null:'Mobile number is not valid'
                            : 'Mobile number is not valid';
                      },
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        labelText: 'Mobile Number',
                        hintText: '',
                        labelStyle: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 13,
                          color: const Color(0xff1e1e1e),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h,),
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
                      // controller: mMobileNumber,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value!.startsWith('03')?value.length ==11
                            ?null:'Mobile number is not valid'
                            : 'Mobile number is not valid';
                      },
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
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h,),
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
                      // controller: mMobileNumber,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value!.startsWith('03')?value.length ==11
                            ?null:'Mobile number is not valid'
                            : 'Mobile number is not valid';
                      },
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
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 2.5.h,),
              Text(
                'By clicking Agree and Join, you agree to the Rooya\nAgreement, Privacy Policy and Cookies Policy',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 10,
                  color: const Color(0xff1e1e1e),
                ),
                textAlign: TextAlign.center,
              ),
              //SizedBox(height: 2.0.h,),
              isError? SizedBox(height: 3.0.h,):Container(),
              isError?Text(errorMsg,
              style:  TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 10.0.sp,
                color: Colors.red,
              ),):Container(),
               SizedBox(height: 3.0.h,),
              InkWell(
                onTap: (){
                  if(_groupValue==0){
                    if(_formKey.currentState!.validate())
                    signUp();
                  }else{
                    Get.snackbar('Coming Soon', 'Business Signup is not working yet!');
                  }

                },
                child: Container(
                  width: 250.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xff0bab0d),
                  ),
                  child:  Center(
                    child: Text(
                      'AGREE & JOIN',
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
              SizedBox(height: 3.0.h,),
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
                  SizedBox(width: 5.0.w,),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/icons/fb.png'))),
                  ),
                  SizedBox(width: 2.0.w,),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/icons/google.png'))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (BuildContext? context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: primaryColor,
              accentColor: primaryColor,
              colorScheme: ColorScheme.light(primary: primaryColor),
              buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: dateSelected,
        firstDate: DateTime(1901, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != dateSelected)
      setState(() {
        dateSelected = picked;
        mDOBController.text =
            picked.day.toString() +
                '-' +
                picked.month.toString() +
                '-' +
                picked.year.toString();
      });
  }
  void changeNumber(text, dailcode) {
    setState(() {
      validPhone = text;
      validPhoneCode = dailcode;
    });
    print(dailcode);
  }
  Future<void> signUp() async {
    setState(() {
      isLoading = true;
    });
print(jsonEncode({
  "username": mUserNameController.text,
  "firstname": mFirstNameController.text,
  "lastname": mLastNameController.text,
  "dob": mDOBController.text,
  "email": mEmailController.text,
  "phone": validPhone,
  "password": mPasswordController.text
}));
    final response =
    await http.post(Uri.parse('${baseUrl}usersingup${code}'),
        headers: {"Accept": "*/*"},
        body: jsonEncode({
          "username": mUserNameController.text,
          "firstname": mFirstNameController.text,
          "lastname": mLastNameController.text,
          "dob": mDOBController.text,
          "email": mEmailController.text,
          "phoneno": validPhone,
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
      print(data['result']);
      if (data['result'] == 'success') {
        setState(() {
          isError = false;
          Get.offAll(()=>SignInTabsHandle());
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
