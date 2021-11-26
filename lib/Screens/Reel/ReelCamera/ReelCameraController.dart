import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ReelCameraController extends GetxController {
  var f1 = File('path'.tr).obs;
  var isf1 = false.obs;

  final ImagePicker _picker = ImagePicker();

  Future<String> onImageButtonPressed({String? from}) async {
    final pickedFile;
    try {
      if (from == 'image') {
        pickedFile = await _picker.getImage(
          source: ImageSource.gallery,
        );
      } else {
        pickedFile = await _picker.getVideo(
          source: ImageSource.gallery,
        );
      }
      return pickedFile!.path;
    } catch (e) {}
    return '';
  }
}
