import 'package:get/get.dart';

snackBarFailer(String message) {
  Get.snackbar('Alert'.tr, message.tr, barBlur: 15.0, isEng: true);
}

snackBarSuccess(String message) {
  Get.snackbar('Success'.tr, message.tr, barBlur: 15.0);
}
