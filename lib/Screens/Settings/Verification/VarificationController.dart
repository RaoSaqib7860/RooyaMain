import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VarificationController extends GetxController {
  var id_front = ''.obs;
  var id_back = ''.obs;
  var live_image = ''.obs;
  var pasport_first_page = ''.obs;
  var pasport_signatue = ''.obs;
  TextEditingController messageCon = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  onImageButtonPressed({ImageSource? source, String? where}) async {
    try {
      final pickedFile;
      pickedFile = await _picker.getImage(
        source: source!,
      );
      print('pickedFile = ${pickedFile!.path}');
      if (where == 'id_front') {
        id_front.value = '${pickedFile!.path}';
      } else if (where == 'id_back') {
        id_back.value = '${pickedFile!.path}';
      } else if (where == 'live') {
        live_image.value = '${pickedFile!.path}';
      } else if (where == 'p_first') {
        pasport_first_page.value = '${pickedFile!.path}';
      } else {
        pasport_signatue.value = '${pickedFile!.path}';
      }
    } catch (e) {}
  }
}
