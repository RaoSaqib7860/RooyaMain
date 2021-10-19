import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rooya_app/AppThemes/AppThemes.dart';
import 'package:rooya_app/utils/AppFonts.dart';
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
                        value: true,
                        onChanged: (v) {},
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
                seetingRowWithOutIcon(
                    height: height,
                    width: width,
                    title: 'DELETE ACCOUNT',
                    textColor: Color(0xffEC2B17)),
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
}
