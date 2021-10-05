import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/Screens/AuthScreens/sign_in_tabs_handle.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _switchValue =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: false,
        title: Text(
          'Settings',
          style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 16.0.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w, top: 3.0.w),
        child: ListView(
          children: [
            ListItemSettings(
              icon: Icons.settings,
              text: 'GENERAL',
            ),
            ListItemSettings(
              icon: Icons.privacy_tip_rounded,
              text: 'PRIVACY',
            ),
            ListItemSettings(
              icon: Icons.lock,
              text: 'CHANGE PASSWORD',
            ),
            ListItemSettings(
              icon: Icons.notifications,
              text: 'NOTIFICATIONS SETTINGS',
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 3.0.w),
              margin: EdgeInsets.symmetric(vertical: 1.5.w),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Icon(Icons.notifications),
                  SizedBox(
                    width: 2.0.w,
                  ),
                  Expanded(
                      child: Text('NOTIFICATIONS',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 13.0.sp,
                            color: Colors.black,
                          ))),
                  Container(
                    height: 1.0.w,
                    child: CupertinoSwitch(
                      value: _switchValue,
                      onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListItemSettings(
              icon: Icons.contact_mail,
              text: 'INVITE FRIENDS',
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0.w),
              child: Text('Write Us',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 14.0.sp,
                    color: Colors.black,
                  )),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 3.0.w),
              margin: EdgeInsets.symmetric(vertical: 1.5.w),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Icon(Icons.mail),
                  SizedBox(
                    width: 2.0.w,
                  ),
                  Expanded(
                      child: Text('CONTACT US',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 13.0.sp,
                            color: Colors.black,
                          ))),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.0.w, vertical: 1.2.w),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('Chat',
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 10.0.sp,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            ),
            ListItemSettings(
              icon: Icons.star,
              text: 'RATE US',
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0.w),
              child: Text('Learn More',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 14.0.sp,
                    color: Colors.black,
                  )),
            ),
            ListItemSettings(
              text: 'FAQ\'S',
            ),
            ListItemSettings(
              text: 'TERMS OF USE',
            ),
            ListItemSettings(
              text: 'PRIVACY POLICY',
            ),
            ListItemSettings(
              text: 'ABOUT US',
            ),
            ListItemSettings(
              text: 'BLOCKED USERS',
              color: Colors.orange,
            ),
            ListItemSettings(
              text: 'DELETE ACCOUNT',
              color: Colors.red,
            ),
            ListItemSettings(
              text: 'LOGOUT',
              color: Colors.black,
              onPressed: () async {
                print('clivk');
                SharedPreferences prefs = await SharedPreferences.getInstance();
               await prefs.clear().then((value) => Get.offAll(()=>SignInTabsHandle()));

              },
            ),
          ],
        ),
      ),
    );
  }
}

class ListItemSettings extends StatefulWidget {
  IconData? icon;
  String? text;
  Function? onPressed;
  Color? color;

  ListItemSettings(
      {Key? key,
      this.icon,
      this.text,
      this.onPressed,
      this.color = Colors.black})
      : super(key: key);

  @override
  _ListItemSettingsState createState() => _ListItemSettingsState();
}

class _ListItemSettingsState extends State<ListItemSettings> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onPressed!(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 3.0.w),
        margin: EdgeInsets.symmetric(vertical: 1.5.w),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            widget.icon != null ? Icon(widget.icon) : Container(),
            SizedBox(
              width: 2.0.w,
            ),
            Expanded(
                child: Text(widget.text!,
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 13.0.sp,
                      color: widget.color,
                    ))),
            Icon(
              Icons.arrow_forward_ios,
              size: 5.0.w,
            ),
          ],
        ),
      ),
    );
  }
}
