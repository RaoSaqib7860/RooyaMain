import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoPlayerGetController extends GetxController{
  @override
  void onClose() {
    print('Controller is closed now');
    super.onClose();
  }
}