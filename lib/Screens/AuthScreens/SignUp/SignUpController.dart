import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/phone_validator/utils/phone_number.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isPasswordShow = true.obs;
  var isConfirmPasswordShow = true.obs;
  var _groupValue = 0.obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMsg = ''.obs;
  DateTime dateSelected = DateTime.now();
  TextEditingController mFirstNameController = TextEditingController();
  TextEditingController mLastNameController = TextEditingController();
  TextEditingController mUserNameController = TextEditingController();
  TextEditingController mDOBController = TextEditingController();
  TextEditingController mEmailController = TextEditingController();
  TextEditingController mMobileController = TextEditingController();
  TextEditingController mPasswordController = TextEditingController();
  TextEditingController mConfirmPasswordController = TextEditingController();
  var validPhone = "".obs;
  var validPhoneCode = "+971".obs;
  PhoneNumber phonenumber = PhoneNumber(isoCode: 'AE');
  var val = -1.obs;
  var individual = true.obs;
}
