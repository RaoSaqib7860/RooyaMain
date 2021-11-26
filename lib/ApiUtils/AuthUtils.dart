import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rooya_app/Screens/AuthScreens/SignIn/SignInController.dart';
import 'package:http/http.dart' as http;
import 'package:rooya_app/Screens/AuthScreens/SignUp/SignUpController.dart';
import 'package:rooya_app/Screens/AuthScreens/VerifyOtp/verify_otp.dart';
import 'package:rooya_app/Screens/Settings/General/CountryModel.dart';
import 'package:rooya_app/Screens/Settings/General/GeneralController.dart';
import 'package:rooya_app/dashboard/BottomSheet/BottomSheet.dart';
import 'package:rooya_app/dashboard/Home/Models/AllStoriesModel.dart';
import 'package:rooya_app/dashboard/Home/Models/HomeBannerModel.dart';
import 'package:rooya_app/dashboard/Home/HomeController/HomeController.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import 'package:rooya_app/events/EventDetailController.dart';
import 'package:rooya_app/events/Models/EventBannerModel.dart';
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
  static final getRooyaPostByLimite = 'getRooyaPostByLimite';
  static final getRooyaSearchPostByLimite = 'getRooyaSearchPostByLimite';
  static final getRooyaSearchEventByLimite = 'getRooyaSearchEventByLimite';
  static final getRooyaPostOfFollowingByLimite =
      'getRooyaPostOfFollowingByLimite';
  static final getRooyaEventPostByLimite = 'getRooyaEventPostByLimite';
  static final removeStory = 'removeStoryElement';
  static final GetEventCoverItems = 'GetEventCoverItems';
  static final getAllStoriesEventID = 'getAllStoriesEventID';
  static final getCountryList = 'getCountryList';
  static final generalSetting = 'generalSetting';

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
    log('login response = ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        GetStorage storage = GetStorage();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_id', '${data['data'][0]['user_id'] ?? ''}');
        storage.write('userID', '${data['data'][0]['user_id'] ?? ''}');
        storage.write('password', controller.mPasswordController.text);
        prefs.setString('user_name', '${data['data'][0]['user_name'] ?? ''}');
        prefs.setString('user_email', '${data['data'][0]['user_email'] ?? ''}');
        prefs.setString('user_phone', '${data['data'][0]['user_phone'] ?? ''}');
        prefs.setString('user_picture', data['data'][0]['user_picture'] ?? '');
        prefs.setString('user_country', '${data['data'][0]['user_country']}');
        prefs.setString('user_gender', '${data['data'][0]['user_gender']}');
        storage.write('user_cover', '${data['data'][0]['user_cover'] ?? ''}');
        storage.write('user_picture', data['data'][0]['user_picture'] ?? '');
        storage.write('enable_allNotification', '1');
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
    print('result of story is = $data');
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
    log('token is =  ${await getToken()}');
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
      controller!.listofStories.value = [];
      controller.listofStories.value = List<AllStoryies>.from(
          data['data'].map((model) => AllStoryies.fromJson(model)));
      controller.listofStories
          .removeWhere((element) => element.storyobjects!.isEmpty);
    }
    controller!.storyLoad.value = true;
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

  static Future getgetRooyaSearchPostByLimite(
      {HomeController? controller, String? word}) async {
    print('call story');
    print('token is =  ${await getToken()}');
    final response = await http.post(
        Uri.parse('$baseUrl$getRooyaSearchPostByLimite$code'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": '${await getToken()}'
        },
        body: jsonEncode({
          "page_size": 100,
          "page_number": 0,
          "search": "$word",
        }));
    var data = jsonDecode(response.body);
    print('getgetRooyaSearchPostByLimite =$data');
    if (data['result'] == 'success') {
      controller!.listofSearch.value = [];
      controller.listofSearch.value = List<RooyaPostModel>.from(
          data['data'].map((model) => RooyaPostModel.fromJson(model)));
    }
  }

  static Future getgetRooyaPostByLimite({HomeController? controller}) async {
    print('call story');
    print('token is =  ${await getToken()}');
    GetStorage storage = GetStorage();
    final response = await http.post(
        Uri.parse('$baseUrl$getRooyaPostByLimite$code'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": '${await getToken()}'
        },
        body: jsonEncode({
          "page_size": 100,
          "page_number": 0,
          "user_id": await storage.read('userID')
        }));
    var data = jsonDecode(response.body);
    print('getgetRooyaPostByLimite =$data');
    if (data['result'] == 'success') {
      controller!.listofpost.value = [];
      controller.listofpost.value = List<RooyaPostModel>.from(
          data['data'].map((model) => RooyaPostModel.fromJson(model)));
      controller.postLoad.value = true;
    } else {
      controller!.postLoad.value = true;
    }
  }

  static Future getRooyaPostByFollowing({HomeController? controller}) async {
    print('call story');
    GetStorage storage = GetStorage();
    print('token is =  ${await getToken()}');
    final response = await http.post(
        Uri.parse('$baseUrl$getRooyaPostOfFollowingByLimite$code'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": '${await getToken()}'
        },
        body: jsonEncode({
          "page_size": 100,
          "page_number": 0,
          'user_id': storage.read('userID')
        }));
    var data = jsonDecode(response.body);
    print('getgetRooyaPostByLimite =$data');
    if (data['result'] == 'success') {
      controller!.listofpost.value = [];
      controller.listofpost.value = List<RooyaPostModel>.from(
          data['data'].map((model) => RooyaPostModel.fromJson(model)));
      controller.postLoad.value = true;
    } else {
      controller!.postLoad.value = true;
    }
  }

  static Future getremoveStory({String? StoryID, String? element_id}) async {
    print(
        'call story and Story id =$StoryID and elsement $element_id and $removeStory');
    print('token is =  ${await getToken()}');
    final response = await http.post(Uri.parse('$baseUrl$removeStory$code'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": '${await getToken()}'
        },
        body: jsonEncode({
          "story_id": int.parse('$StoryID'),
          "story_element_id": int.parse('$element_id')
        }));
    var data = jsonDecode(response.body);
    print('remove story =$data');
  }

  static Future getEventBanner(
      {EventDetailController? controller, String? eventID}) async {
    print('call story');
    print('token is =  ${await getToken()}');
    final response = await http.post(
      Uri.parse('$baseUrl$GetEventCoverItems$code'),
      body: jsonEncode({"event_id": eventID}),
      headers: {
        "Content-Type": "application/json",
        "Authorization": '${await getToken()}'
      },
    );
    var data = jsonDecode(response.body);
    print('getgetHomeBanner =$data');
    if (data['result'] == 'success') {
      controller!.listofbanner.value = List<EventBannerModel>.from(data['data'][0]['attachment']
          .map((model) => EventBannerModel.fromJson(model)));
    }
  }

  static Future getgetRooyaEventByLimite(
      {EventDetailController? controller, String? eventID}) async {
    print('call story');
    print('token is =  ${await getToken()}');
    GetStorage storage = GetStorage();
    final response = await http.post(
        Uri.parse('$baseUrl$getRooyaEventPostByLimite$code'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": '${await getToken()}'
        },
        body: jsonEncode({
          "page_size": 100,
          "page_number": 0,
          'event_id': int.parse(eventID!),
          'storage': storage.read('userID')
        }));
    var data = jsonDecode(response.body);
    print('getgetRooyaEventByLimite =$data');
    if (data['result'] == 'success') {
      controller!.listofpost.value = List<RooyaPostModel>.from(
          data['data'].map((model) => RooyaPostModel.fromJson(model)));
      controller.postLoad.value = true;
    } else {
      controller!.postLoad.value = true;
    }
  }

  static Future getgetRooyaEventSearchPostByLimite(
      {EventDetailController? controller,
      String? word,
      String? event_id}) async {
    print('call story');
    print('token is =  ${await getToken()}');
    GetStorage storage = GetStorage();
    final response = await http.post(
        Uri.parse('$baseUrl$getRooyaSearchEventByLimite$code'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": '${await getToken()}'
        },
        body: jsonEncode({
          "page_size": 100,
          "page_number": 0,
          "search": "$word",
          "event_id": '$event_id',
          'storage': storage.read('userID')
        }));
    var data = jsonDecode(response.body);
    print('getgetRooyaSearchPostByLimite =$data');
    if (data['result'] == 'success') {
      controller!.listofSearch.value = [];
      controller.listofSearch.value = List<RooyaPostModel>.from(
          data['data'].map((model) => RooyaPostModel.fromJson(model)));
    }
  }

  static Future getAllStoriesAPIEvent(
      {EventDetailController? controller, String? eventID}) async {
    print('call story $eventID');
    log('token is =  ${await getToken()}');
    final response = await http.post(
      Uri.parse('$baseUrl$getAllStoriesEventID$code'),
      body: jsonEncode({"event_id": eventID}),
      headers: {
        "Content-Type": "application/json",
        "Authorization": '${await getToken()}'
      },
    );
    var data = jsonDecode(response.body);
    print('getAllStoriesAPI =$data');
    if (data['result'] == 'success') {
      controller!.listofStories.value = List<AllStoryies>.from(
          data['data'].map((model) => AllStoryies.fromJson(model)));
      controller.listofStories
          .removeWhere((element) => element.storyobjects!.isEmpty);
    }
    controller!.storyLoad.value = true;
  }

  static Future getAllCountry({GeneralController? controller}) async {
    print('call story');
    log('token is =  ${await getToken()}');
    final response = await http.get(
      Uri.parse('$baseUrl$getCountryList$code'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": '${await getToken()}'
      },
    );
    var data = jsonDecode(response.body);
    print('getAllStoriesAPI =$data');
    if (data['result'] == 'success') {
      controller!.listofCountry.value = List<CountryModel>.from(
          data['data'].map((model) => CountryModel.fromJson(model)));
    }
  }

//https://apis.rooya.com/Alphaapis/generalSetting?code=ROOYA-5574499
  static Future getgeneralSetting(
      {GeneralController? controller,
      CountryModel? CountryModel,
      String? country_code,
      String? cover,
      String? profile,
      String? countryName}) async {
    print('call story');
    log('token is =  ${await getToken()}');
    GetStorage storage = GetStorage();
    final response = await http.post(
      Uri.parse('$baseUrl$generalSetting$code'),
      body: jsonEncode({
        "user_id": storage.read('userID'),
        "user_phone": "$country_code${controller!.phoneCont.text}",
        "user_firstname": "${controller.fNameCont.text}",
        "user_lastname": "${controller.lNameCont.text}",
        "user_gender": controller.gender.value == 'Male' ? 0 : 1,
        "user_picture": "$profile",
        "user_cover": "$cover",
        "user_country": "$country_code"
      }),
      headers: {
        "Content-Type": "application/json",
        "Authorization": '${await getToken()}'
      },
    );
    var data = jsonDecode(response.body);
    print('getAllStoriesAPI =$data');
    if (data['result'] == 'success') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_name',
          '${controller.fNameCont.text} ${controller.lNameCont.text}');
      prefs.setString('user_phone', "${controller.phoneCont.text}");
      prefs.setString('user_picture', '$profile');
      prefs.setString('user_country', "+971");
      prefs.setString(
          'user_gender', '${controller.gender.value == 'Male' ? 0 : 1}');
      storage.write('user_cover', "$cover");
      storage.write('user_picture', '$profile');
      prefs.setString('user_firstname', '${controller.fNameCont.text}');
      prefs.setString('user_lastname', '${controller.lNameCont.text}');
    }
  }
}
