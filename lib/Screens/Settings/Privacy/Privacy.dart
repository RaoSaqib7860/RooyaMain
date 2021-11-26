import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/AppThemes/AppThemes.dart';
import 'package:rooya_app/Screens/Settings/Components/Componenets.dart';
import 'package:rooya_app/Screens/Settings/Privacy/PrivacySettingsModel.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/SnackbarCustom.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  String who_can_folow_me = 'Everyone';
  String who_can_message_me = 'Everyone';
  String who_can_see_my_friends = 'Everyone';
  String who_can_post_on_my_time_line = 'Everyone';
  String who_can_see_my_birthday = 'Everyone';
  String confirm_request_when_someone_follow_you = 'Everyone';
  String show_my_activity = 'Everyone';
  String status = 'Everyone';

  PrivacySettings? listofprivacy;

  @override
  void initState() {
    getPrivicy();
    super.initState();
  }

  bool loading = false;
  bool load_privacy = false;

  bool see_online_offline = true;
  bool private_account = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (c, size) {
      var height = size.maxHeight;
      var width = size.maxWidth;
      return ProgressHUD(
        inAsyncCall: loading,
        opacity: 0.7,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Get.back();
                },
                color: Colors.white,
              ),
              centerTitle: false,
              title: Text(
                'PRIVACY',
                style: TextStyle(
                    fontFamily: AppFonts.segoeui,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ),
            body: !load_privacy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.040),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.010,
                          ),
                          Text(
                            'Who can follow me',
                            style: TextStyle(fontFamily: AppFonts.segoeui),
                          ),
                          SizedBox(
                            height: height * 0.010,
                          ),
                          rowData(
                              width: width,
                              height: height,
                              text: who_can_folow_me,
                              onselected: (value) {
                                print('value = $value');
                                who_can_folow_me = value;
                                setState(() {});
                              },
                              initialValue: 'Everyone'),
                          SizedBox(
                            height: height * 0.010,
                          ),
                          Text(
                            'Who can message me?',
                            style: TextStyle(fontFamily: AppFonts.segoeui),
                          ),
                          SizedBox(
                            height: height * 0.010,
                          ),
                          rowData(
                              width: width,
                              height: height,
                              text: who_can_message_me,
                              onselected: (value) {
                                who_can_message_me = value;
                                setState(() {});
                              },
                              initialValue: 'Everyone'),
                          SizedBox(
                            height: height * 0.010,
                          ),
                          Text(
                            'Who can see my followers?',
                            style: TextStyle(fontFamily: AppFonts.segoeui),
                          ),
                          SizedBox(
                            height: height * 0.010,
                          ),
                          rowData(
                              width: width,
                              height: height,
                              text: who_can_see_my_friends,
                              onselected: (value) {
                                who_can_see_my_friends = value;
                                setState(() {});
                              },
                              initialValue: 'Everyone'),
                          SizedBox(
                            height: height * 0.010,
                          ),
                          Text(
                            'Who can post on my timeline?',
                            style: TextStyle(fontFamily: AppFonts.segoeui),
                          ),
                          SizedBox(
                            height: height * 0.010,
                          ),
                          rowData(
                              width: width,
                              height: height,
                              text: who_can_post_on_my_time_line,
                              onselected: (value) {
                                who_can_post_on_my_time_line = value;
                                setState(() {});
                              },
                              initialValue: 'Everyone'),
                          SizedBox(
                            height: height * 0.010,
                          ),
                          Text(
                            'Who can see my birthday?',
                            style: TextStyle(fontFamily: AppFonts.segoeui),
                          ),
                          SizedBox(
                            height: height * 0.010,
                          ),
                          rowData(
                              width: width,
                              height: height,
                              text: who_can_see_my_birthday,
                              onselected: (value) {
                                who_can_see_my_birthday = value;
                                setState(() {});
                              },
                              initialValue: 'Everyone'),
                          // SizedBox(
                          //   height: height * 0.010,
                          // ),
                          // Text(
                          //   'Confirm request when someone follows you?',
                          //   style: TextStyle(fontFamily: AppFonts.segoeui),
                          // ),
                          // SizedBox(
                          //   height: height * 0.010,
                          // ),
                          // rowData(
                          //     width: width,
                          //     height: height,
                          //     text: confirm_request_when_someone_follow_you,
                          //     onselected: (value) {
                          //       confirm_request_when_someone_follow_you = value;
                          //       setState(() {});
                          //     },
                          //     initialValue: 'Everyone'),
                          // SizedBox(
                          //   height: height * 0.010,
                          // ),
                          // Text(
                          //   'Show my activities?',
                          //   style: TextStyle(fontFamily: AppFonts.segoeui),
                          // ),
                          // SizedBox(
                          //   height: height * 0.010,
                          // ),
                          // rowData(
                          //     width: width,
                          //     height: height,
                          //     onselected: (value) {
                          //       show_my_activity = value;
                          //       setState(() {});
                          //     },
                          //     text: show_my_activity,
                          //     initialValue: 'Everyone'),
                          // SizedBox(
                          //   height: height * 0.010,
                          // ),
                          // Text(
                          //   'Status',
                          //   style: TextStyle(fontFamily: AppFonts.segoeui),
                          // ),
                          // SizedBox(
                          //   height: height * 0.010,
                          // ),
                          // rowData(
                          //     width: width,
                          //     height: height,
                          //     text: status,
                          //     onselected: (value) {
                          //       status = value;
                          //       setState(() {});
                          //     },
                          //     initialValue: 'Everyone'),
                          SizedBox(
                            height: height * 0.020,
                          ),
                          switchwithRow(
                              height: height,
                              istrue: see_online_offline,
                              onchange: (v) {
                                see_online_offline = v;
                                setState(() {});
                              },
                              width: width,
                              title: 'See Online Offline'),
                          SizedBox(
                            height: height * 0.020,
                          ),
                          switchwithRow(
                              height: height,
                              width: width,
                              istrue: private_account,
                              onchange: (v) {
                                private_account = v;
                                setState(() {});
                              },
                              title: 'Private Account'),
                          SizedBox(
                            height: height * 0.030,
                          ),
                          Center(
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  loading = true;
                                });
                                await updatePrivicy();
                                setState(() {
                                  loading = false;
                                });
                              },
                              child: Container(
                                width: width * 0.5,
                                height: height * 0.055,
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(5),
                                child: Center(
                                  child: Text(
                                    'Update',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.060,
                          ),
                        ],
                      ),
                    ),
                    physics: BouncingScrollPhysics(),
                  ),
          ),
        ),
      );
    });
  }

  Widget rowData(
      {double? height,
      double? width,
      String? text,
      String? initialValue,
      Function(String)? onselected}) {
    return Container(
      height: height! * 0.060,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.green.withOpacity(0.10),
                offset: Offset(4, 4),
                blurRadius: 3),
            BoxShadow(
                color: Colors.green.withOpacity(0.1),
                offset: Offset(-1, -1),
                blurRadius: 1)
          ],
          borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.symmetric(horizontal: width! * 0.030),
      child: DropdownButton<String>(
        items:
            <String>['Everyone', 'My Followers', 'Only Me'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(fontFamily: AppFonts.segoeui, fontSize: 12),
            ),
          );
        }).toList(),
        underline: SizedBox(),
        icon: Icon(
          CupertinoIcons.chevron_down,
          size: 18,
          color: primaryColor,
        ),
        isExpanded: true,
        hint: Text(
          '$text',
          style: TextStyle(
              fontFamily: AppFonts.segoeui, fontSize: 14, color: Colors.black),
        ),
        onChanged: (value) {
          onselected!.call('$value');
        },
      ),
    );
  }

  Future<void> updatePrivicy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}generalPrivacy$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": userId,
          "user_privacy_wall": who_can_post_on_my_time_line == 'Everyone'
              ? "public"
              : who_can_post_on_my_time_line == 'My Followers'
                  ? "follower"
                  : "me",
          "user_privacy_gender": "public",
          "user_privacy_birthdate": who_can_see_my_birthday == 'Everyone'
              ? "public"
              : who_can_see_my_birthday == 'My Followers'
                  ? "follower"
                  : "me",
          "user_privacy_friends": who_can_see_my_friends == 'Everyone'
              ? "public"
              : who_can_see_my_friends == 'My Followers'
                  ? "follower"
                  : "me",
          "user_privacy_follow": who_can_folow_me == 'Everyone'
              ? 1
              : who_can_folow_me == 'My Followers'
                  ? 1
                  : 0,
          "user_chat_enabled": who_can_message_me == 'Everyone'
              ? 1
              : who_can_message_me == 'My Followers'
                  ? 1
                  : 0,
          "see_online_offline": see_online_offline ? 1 : 0,
          "private_account": private_account ? 1 : 0
        }));
    print('response is = ${response.body}');
    var data = jsonDecode(response.body);
    if (data['result'] == 'success') {
      snackBarSuccess('${data['message']}');
    }
  }

  Future<void> getPrivicy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}getGeneralPrivacy$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": userId,
        }));
    print('getPrivicy response is = ${response.body}');
    var data = jsonDecode(response.body);
    listofprivacy = PrivacySettings.fromJson(data['data'][0]);
    who_can_post_on_my_time_line = listofprivacy!.userPrivacyWall == 'public'
        ? 'Everyone'
        : listofprivacy!.userPrivacyWall == 'follower'
            ? 'My Followers'
            : 'Only Me';
    who_can_see_my_birthday = listofprivacy!.userPrivacyBirthdate == 'public'
        ? 'Everyone'
        : listofprivacy!.userPrivacyBirthdate == 'follower'
            ? 'My Followers'
            : 'Only Me';
    who_can_see_my_friends = listofprivacy!.userPrivacyFriends == 'public'
        ? 'Everyone'
        : listofprivacy!.userPrivacyFriends == 'follower'
            ? 'My Followers'
            : 'Only Me';
    who_can_message_me = listofprivacy!.userChatEnabled == 'public'
        ? 'Everyone'
        : listofprivacy!.userChatEnabled == 'follower'
            ? 'My Followers'
            : 'Only Me';
    who_can_folow_me = listofprivacy!.userPrivacyFollow == 'public'
        ? 'Everyone'
        : listofprivacy!.userPrivacyFollow == 'follower'
            ? 'My Followers'
            : 'Only Me';
    see_online_offline = listofprivacy!.seeOnlineOffline == '0' ||
            listofprivacy!.seeOnlineOffline == ''
        ? false
        : true;
    private_account = listofprivacy!.privateAccount == '0' ||
            listofprivacy!.privateAccount == ''
        ? false
        : true;
    setState(() {
      load_privacy = true;
    });
  }
}
