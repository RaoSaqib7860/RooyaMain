import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rooya_app/Screens/Settings/General/CountryModel.dart';

class GeneralController extends GetxController {
  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController countryCont = TextEditingController();
  TextEditingController genderCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  var listofCountry = <CountryModel>[].obs;

  var gender = ''.obs;
  var profilePath = ''.obs;
  var profilePath2 = ''.obs;
  final ImagePicker _picker = ImagePicker();

  onImageButtonPressed({ImageSource? source, bool? fromCover = false}) async {
    try {
      final pickedFile;
      pickedFile = await _picker.getImage(
        source: source!,
      );
      print('pickedFile = ${pickedFile!.path}');
      if (fromCover == false) {
        profilePath.value = '${pickedFile!.path}';
      } else {
        profilePath2.value = '${pickedFile!.path}';
      }
    } catch (e) {}
  }
}
