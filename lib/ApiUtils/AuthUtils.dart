import 'dart:convert';
import 'package:get/get.dart';
import 'package:rooya_app/Screens/AuthScreens/SignIn/SignInController.dart';
import 'package:http/http.dart' as http;
import 'package:rooya_app/Screens/AuthScreens/SignUp/SignUpController.dart';
import 'package:rooya_app/Screens/AuthScreens/VerifyOtp/verify_otp.dart';
import 'package:rooya_app/dashboard/BottomSheet/BottomSheet.dart';
import 'package:rooya_app/dashboard/Home/AllStoriesModel.dart';
import 'package:rooya_app/dashboard/Home/HomeBannerModel.dart';
import 'package:rooya_app/dashboard/Home/HomeController.dart';
import 'package:rooya_app/utils/SnackbarCustom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'baseUrl.dart';

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

class AuthUtils {
  static final AuthScreens = 'login';
  static final SignUp = 'usersingup';
  static final getAllStories = 'getAllStories';
  static final getHomeBanner = 'getHomeBanner';

  static Future signIn({SignInController? controller}) async {
    controller!.isLoading.value = true;
    print({
      "userinfo": controller.mUserInfoController.text,
      "userpassword": controller.mPasswordController.text,
      "devicetoken": '12345'
    });
    final response = await http.post(Uri.parse('$baseUrl$AuthScreens$code'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "userinfo": controller.mUserInfoController.text,
          "userpassword": controller.mPasswordController.text,
          "devicetoken": 'mPasswordController.text'
        }));
    controller.isLoading.value = false;
    print(response.request);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_id', '${data['data'][0]['user_id'] ?? ''}');
        prefs.setString('user_name', '${data['data'][0]['user_name'] ?? ''}');
        prefs.setString('user_email', '${data['data'][0]['user_email'] ?? ''}');
        prefs.setString('user_phone', '${data['data'][0]['user_phone'] ?? ''}');
        prefs.setString(
            'user_firstname', '${data['data'][0]['user_firstname'] ?? ''}');
        prefs.setString(
            'user_lastname', '${data['data'][0]['user_lastname'] ?? ''}');
        prefs.setString('token', data['mytoken'] ?? '');
        Get.offAll(() => BottomSheetCustom());
      } else {
        snackBarFailer('${data['message']}');
      }
    }
  }

  static Future<void> signUp({SignUpController? controller}) async {
    controller!.isLoading.value = true;
    print(jsonEncode({
      "username": controller.mUserNameController.text,
      "firstname": controller.mFirstNameController.text,
      "lastname": controller.mLastNameController.text,
      "dob": controller.mDOBController.text,
      "email": controller.mEmailController.text,
      "phone": controller.validPhone.value,
      "password": controller.mPasswordController.text
    }));
    final response = await http.post(Uri.parse('$baseUrl$SignUp$code'),
        headers: {"Accept": "*/*"},
        body: jsonEncode({
          "username": controller.mUserNameController.text,
          "firstname": controller.mFirstNameController.text,
          "lastname": controller.mLastNameController.text,
          "dob": controller.mDOBController.text,
          "email": controller.mEmailController.text,
          "phoneno": '${controller.validPhone.value}',
          "password": controller.mPasswordController.text,
          'user_group': controller.individual.value ? '3' : '5'
        }));
    controller.isLoading.value = false;
    var data = jsonDecode(response.body);
    print('result is = $data');
    if (data['result'] == 'success') {
      Get.to(VerifyOTP(
        userInfo: '${controller.validPhone.value}',
      ));
      snackBarFailer(data['message']);
    } else {
      snackBarFailer(data['message']);
    }
  }

  static Future getAllStoriesAPI({HomeController? controller}) async {
    print('call story');
    print('token is =  ${await getToken()}');
    final response = await http.get(
      Uri.parse('$baseUrl$getAllStories$code'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": '${await getToken()}'
      },
    );
    var data = jsonDecode(response.body);
    print('getAllStoriesAPI =$data');
    if (data['result'] == 'success') {
      List list = data['data'];
      List newList = [];
      list.forEach((element) {
        newList.addAll(element['storyobjects']);
      });
      controller!.listofStories.value = List<AllStoriesModel>.from(
          newList.map((model) => AllStoriesModel.fromJson(model)));
    }
  }

  static Future getgetHomeBanner({HomeController? controller}) async {
    print('call story');
    print('token is =  ${await getToken()}');
    final response = await http.get(
      Uri.parse('$baseUrl$getHomeBanner$code'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": '${await getToken()}'
      },
    );
    var data = jsonDecode(response.body);
    print('getgetHomeBanner =$data');
    if (data['result'] == 'success') {
      controller!.listofbanner.value = List<HomeBannerModel>.from(
          data['data'].map((model) => HomeBannerModel.fromJson(model)));
    }
  }
}
