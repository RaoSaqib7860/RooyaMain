import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/AppThemes/AppThemes.dart';
import 'package:rooya_app/Screens/AuthScreens/sign_in_tabs_handle.dart';
import 'package:rooya_app/Screens/Settings/FolowRequest/FolowRequest.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChangePassword/ChangePassword.dart';
import 'Components/Componenets.dart';
import 'General/General.dart';
import 'MyInformation/MyInformation.dart';
import 'NotificationSettings/NotificationSettings.dart';
import 'Privacy/Privacy.dart';
import 'Verification/Varification.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool enable_notification = false;
  GetStorage storage = GetStorage();

  @override
  void initState() {
    enable_notification =
        storage.read('enable_allNotification') == '0' ? false : true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (c, size) {
      var height = size.maxHeight;
      var width = size.maxWidth;
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Settings',
            style: TextStyle(
                fontFamily: AppFonts.segoeui,
                color: Colors.black,
                fontSize: 14),
          ),
          actions: [
            Center(
              child: Text(
                'ENG',
                style: TextStyle(
                    fontFamily: AppFonts.segoeui,
                    color: Colors.black,
                    fontSize: 12),
              ),
            ),
            SizedBox(
              width: width * 0.010,
            ),
            Icon(
              Icons.language,
              color: Colors.black,
            ),
            SizedBox(
              width: width * 0.030,
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.030),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(General());
                  },
                  child: settingRow(
                      width: width,
                      height: height,
                      title: 'GENERAL',
                      svgname: 'assets/svg/general.svg'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(Privacy());
                  },
                  child: settingRow(
                      width: width,
                      height: height,
                      title: 'PRIVACY',
                      svgname: 'assets/svg/privcy.svg'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(ChangePassword());
                  },
                  child: settingRow(
                      width: width,
                      height: height,
                      title: 'CHANGE PASSWORD',
                      svgname: 'assets/svg/chnagepassword.svg'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(NotificationSeetings());
                  },
                  child: settingRow(
                      width: width,
                      height: height,
                      title: 'NOTIFICATIONS SETTINGS',
                      svgname: 'assets/svg/notifications.svg'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(Varification());
                  },
                  child: settingRow(
                      width: width,
                      height: height,
                      title: 'VERIFICATION',
                      svgname: 'assets/svg/verification.svg'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(FolowRequest());
                  },
                  child: settingRow(
                      width: width,
                      height: height,
                      title: 'FOLLOW REQUEST',
                      svgname: 'assets/svg/verification.svg'),
                ),
                InkWell(
                  onTap: () {
                    Get.to(MyInformation());
                  },
                  child: settingRow(
                      width: width,
                      height: height,
                      title: 'MY INFORMATION',
                      svgname: 'assets/svg/information.svg'),
                ),
                Container(
                  height: height * 0.060,
                  margin: EdgeInsets.only(bottom: height * 0.015),
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.030),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.1,
                            child: SvgPicture.asset(
                              'assets/svg/notifications.svg',
                              color: darkoffBlackColor,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.030,
                          ),
                          Text(
                            'NOTIFICATIONS',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontFamily: AppFonts.segoeui,
                                color: darkoffBlackColor),
                          ),
                        ],
                      ),
                      CupertinoSwitch(
                        value: enable_notification,
                        onChanged: (v) {
                          setState(() {
                            enable_notification = v;
                          });
                          if (v) {
                            allNotifyEnableDisbale('1');
                            storage.write('enable_allNotification', '1');
                          } else {
                            allNotifyEnableDisbale('0');
                            storage.write('enable_allNotification', '0');
                          }
                        },
                        activeColor: greenColor,
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  decoration: BoxDecoration(
                      color: settingGreyColor,
                      borderRadius: BorderRadius.circular(5)),
                ),
                settingRow(
                    width: width,
                    height: height,
                    title: 'INVITE FRIENDS',
                    svgname: 'assets/svg/inviteFriends.svg'),
                Container(
                  height: height * 0.060,
                  margin: EdgeInsets.only(bottom: height * 0.015),
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.030),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.1,
                            child: SvgPicture.asset(
                              'assets/svg/notifications.svg',
                              color: darkoffBlackColor,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.030,
                          ),
                          Text(
                            'CONTACT US',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontFamily: AppFonts.segoeui,
                                color: darkoffBlackColor),
                          ),
                        ],
                      ),
                      Container(
                        child: Text(
                          'Chat',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: greenColor,
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  decoration: BoxDecoration(
                      color: settingGreyColor,
                      borderRadius: BorderRadius.circular(5)),
                ),
                settingRow(
                    width: width,
                    height: height,
                    title: 'Rate Us',
                    svgname: 'assets/svg/rateUs.svg'),
                Text(
                  'Learn More',
                  style: TextStyle(fontFamily: AppFonts.segoeui, fontSize: 15),
                ),
                SizedBox(
                  height: height * 0.020,
                ),
                seetingRowWithOutIcon(
                    height: height, width: width, title: 'FAQ\'s'),
                seetingRowWithOutIcon(
                    height: height, width: width, title: 'TERMS of USE'),
                seetingRowWithOutIcon(
                    height: height, width: width, title: 'PRIVACY POLICY'),
                seetingRowWithOutIcon(
                    height: height, width: width, title: 'ABOUT US'),
                seetingRowWithOutIcon(
                    height: height,
                    width: width,
                    title: 'BLOCKED USERS',
                    textColor: Color(0xffE59307)),
                // seetingRowWithOutIcon(
                //     height: height,
                //     width: width,
                //     title: 'DELETE ACCOUNT',
                //     textColor: Color(0xffEC2B17)),
                InkWell(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    GetStorage storage = GetStorage();
                    prefs.clear();
                    storage.erase();
                    Get.offAll(SignInTabsHandle());
                  },
                  child: seetingRowWithOutIcon(
                      height: height,
                      width: width,
                      title: 'Logout',
                      textColor: Color(0xffEC2B17)),
                ),
                SizedBox(
                  height: height * 0.020,
                ),
              ],
            ),
            physics: BouncingScrollPhysics(),
          ),
        ),
      ));
    });
  }

//https://apis.rooya.com/Alphaapis/allNotifyEnableDisbale?code=ROOYA-5574499

  Future<void> allNotifyEnableDisbale(String? action) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}allNotifyEnableDisbale$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"user_id": userId, "action": "$action"}));
    print('response is = ${response.body}');
  }
}
