import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var isPasswordShow = true.obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMsg = ''.obs;
  TextEditingController mUserInfoController = TextEditingController();
  TextEditingController mPasswordController = TextEditingController();
}