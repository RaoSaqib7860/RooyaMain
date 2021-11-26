import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/Screens/Settings/Components/Componenets.dart';
import 'package:rooya_app/Screens/Settings/Privacy/PrivacySettingsModel.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'NotificationSettingsModel.dart';

class NotificationSeetings extends StatefulWidget {
  const NotificationSeetings({Key? key}) : super(key: key);

  @override
  _NotificationSeetingsState createState() => _NotificationSeetingsState();
}

class _NotificationSeetingsState extends State<NotificationSeetings> {
  bool someOne_like_my_post = true;
  bool SomeOne_comment_on_my_post = true;
  bool someOne_folow_me = true;
  bool someOne_like_my_page = true;
  bool someOne_Visit_My_Profile = true;
  bool someOne_Mentione_me = true;
  bool someOne_accepted_my_friend_request = true;
  bool someone_join_my_group = true;
  bool someone_posted_on_my_timeline = true;
  bool you_have_remember_on_this_day = true;

  bool loading = false;

  NotificationSettings? privacySettings;
  bool load_settings = false;

  @override
  void initState() {
    getPrivicy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return SafeArea(
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
          'Notification Settings',
          style: TextStyle(
              fontFamily: AppFonts.segoeui, fontSize: 14, color: Colors.black),
        ),
      ),
      body: !load_settings
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.030),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.020,
                    ),
                    switchwithRow(
                        height: height,
                        istrue: someOne_like_my_post,
                        onchange: (v) {
                          someOne_like_my_post = v;
                          setState(() {});
                          if (v) {
                            updatePrivicy(
                                value: '1',
                                key: 'like_my_post',
                                url: 'likeMyPost');
                          } else {
                            updatePrivicy(
                                value: '0',
                                key: 'like_my_post',
                                url: 'likeMyPost');
                          }
                        },
                        width: width,
                        title: 'Someone liked my Posts'),
                    SizedBox(
                      height: height * 0.020,
                    ),
                    switchwithRow(
                        height: height,
                        width: width,
                        istrue: SomeOne_comment_on_my_post,
                        onchange: (v) {
                          SomeOne_comment_on_my_post = v;
                          setState(() {});
                          if (v) {
                            updatePrivicy(
                                value: '1',
                                key: 'comment_my_post',
                                url: 'commentMyPost');
                          } else {
                            updatePrivicy(
                                value: '0',
                                key: 'comment_my_post',
                                url: 'commentMyPost');
                          }
                        },
                        title: 'Someone Commented on my Posts'),
                    SizedBox(
                      height: height * 0.020,
                    ),
                    switchwithRow(
                        height: height,
                        width: width,
                        istrue: someOne_folow_me,
                        onchange: (v) {
                          someOne_folow_me = v;
                          setState(() {});
                          if (v) {
                            updatePrivicy(
                                value: '1',
                                key: 'followed_me',
                                url: 'followedMe');
                          } else {
                            updatePrivicy(
                                value: '0',
                                key: 'followed_me',
                                url: 'followedMe');
                          }
                        },
                        title: 'Someone followed me'),
                    SizedBox(
                      height: height * 0.020,
                    ),
                    switchwithRow(
                        height: height,
                        width: width,
                        istrue: someOne_like_my_page,
                        onchange: (v) {
                          someOne_like_my_page = v;
                          setState(() {});
                          if (v) {
                            updatePrivicy(
                                value: '1',
                                key: 'like_my_page',
                                url: 'likeMyPage');
                          } else {
                            updatePrivicy(
                                value: '0',
                                key: 'like_my_page',
                                url: 'likeMyPage');
                          }
                        },
                        title: 'Someone liked my Pages'),
                    SizedBox(
                      height: height * 0.020,
                    ),
                    switchwithRow(
                        height: height,
                        width: width,
                        istrue: someOne_Visit_My_Profile,
                        onchange: (v) {
                          someOne_Visit_My_Profile = v;
                          setState(() {});
                          if (v) {
                            updatePrivicy(
                                value: '1', key: 'visit_me', url: 'visitMe');
                          } else {
                            updatePrivicy(
                                value: '0', key: 'visit_me', url: 'visitMe');
                          }
                        },
                        title: 'Someone visited my Profile'),
                    SizedBox(
                      height: height * 0.020,
                    ),
                    switchwithRow(
                        height: height,
                        width: width,
                        istrue: someOne_Mentione_me,
                        onchange: (v) {
                          someOne_Mentione_me = v;
                          setState(() {});
                          if (v) {
                            updatePrivicy(
                                value: '1',
                                key: 'mention_me',
                                url: 'mentionMe');
                          } else {
                            updatePrivicy(
                                value: '0',
                                key: 'mention_me',
                                url: 'mentionMe');
                          }
                        },
                        title: 'Someone mentioned me'),
                    SizedBox(
                      height: height * 0.020,
                    ),
                    switchwithRow(
                        height: height,
                        width: width,
                        istrue: someOne_accepted_my_friend_request,
                        onchange: (v) {
                          someOne_accepted_my_friend_request = v;
                          setState(() {});
                          if (v) {
                            updatePrivicy(
                                value: '1',
                                key: 'follow_request',
                                url: 'followRequest');
                          } else {
                            updatePrivicy(
                                value: '0',
                                key: 'follow_request',
                                url: 'followRequest');
                          }
                        },
                        title: 'Someone accepted my friend/follow request'),
                    SizedBox(
                      height: height * 0.020,
                    ),
                    switchwithRow(
                        height: height,
                        width: width,
                        istrue: someone_join_my_group,
                        onchange: (v) {
                          someone_join_my_group = v;
                          setState(() {});
                          if (v) {
                            updatePrivicy(
                                value: '1',
                                key: 'join_group',
                                url: 'joinGroup');
                          } else {
                            updatePrivicy(
                                value: '0',
                                key: 'join_group',
                                url: 'joinGroup');
                          }
                        },
                        title: 'Someone joined my Groups'),
                    SizedBox(
                      height: height * 0.020,
                    ),
                    switchwithRow(
                        height: height,
                        width: width,
                        istrue: someone_posted_on_my_timeline,
                        onchange: (v) {
                          someone_posted_on_my_timeline = v;
                          setState(() {});
                          if (v) {
                            updatePrivicy(
                                value: '1',
                                key: 'post_on_my_wall',
                                url: 'postOnMyWall');
                          } else {
                            updatePrivicy(
                                value: '0',
                                key: 'post_on_my_wall',
                                url: 'postOnMyWall');
                          }
                        },
                        title: 'Someone posted on my timeline'),
                    SizedBox(
                      height: height * 0.020,
                    ),
                    switchwithRow(
                        height: height,
                        width: width,
                        istrue: you_have_remember_on_this_day,
                        onchange: (v) {
                          you_have_remember_on_this_day = v;
                          setState(() {});
                          if (v) {
                            updatePrivicy(
                                value: '1', key: 'my_day', url: 'myDay');
                          } else {
                            updatePrivicy(
                                value: '0', key: 'my_day', url: 'myDay');
                          }
                        },
                        title: 'You have remembrance on this day'),
                    SizedBox(
                      height: height * 0.020,
                    ),
                  ],
                ),
              ),
            ),
    ));
  }

  Future updatePrivicy({String? url, String? key, String? value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}$url$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": userId,
          "$key": '$value',
        }));
    print('response is = ${response.body}');
  }

  Future<void> getPrivicy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}notificationData$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": userId,
        }));
    print('getPrivicy response is = ${response.body}');
    var data = jsonDecode(response.body);
    if (data['result'] == 'success') {
      privacySettings = NotificationSettings.fromJson(data['data'][0]);
      someOne_like_my_post = privacySettings!.likeMyPost == '1' ? true : false;
      SomeOne_comment_on_my_post =
          privacySettings!.commentMyPost == '1' ? true : false;
      someOne_folow_me = privacySettings!.followedMe == '1' ? true : false;
      someOne_Visit_My_Profile = privacySettings!.visitMe == '1' ? true : false;
      someOne_accepted_my_friend_request =
          privacySettings!.followRequest == '1' ? true : false;
      someOne_like_my_post = privacySettings!.likeMyPost == '1' ? true : false;
      someone_join_my_group = privacySettings!.joinGroup == '1' ? true : false;
      someone_posted_on_my_timeline =
          privacySettings!.postOnMyWall == '1' ? true : false;
      you_have_remember_on_this_day =
          privacySettings!.myDay == '1' ? true : false;
      setState(() {
        load_settings = true;
      });
    }
  }
}
