import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/Screens/Settings/FolowRequest/AllowFollowersListModel.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FolowRequest extends StatefulWidget {
  const FolowRequest({Key? key}) : super(key: key);

  @override
  _FolowRequestState createState() => _FolowRequestState();
}

class _FolowRequestState extends State<FolowRequest> {
  bool tab1 = true;
  bool loading = false;
  List<AllowFollowersList> allowFolowList = [];
  List<AllowFollowersList> toFolowList = [];

  bool gettabOneList = false;
  bool gettabTwoList = false;

  @override
  void initState() {
    allowfollowersList();
    tofollowPendingList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            'FOLLOW REQUEST',
            style: TextStyle(
                fontFamily: AppFonts.segoeui,
                fontSize: 14,
                color: Colors.black),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.030),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          tab1 = true;
                        });
                      },
                      child: Container(
                        height: height * 0.045,
                        child: Center(
                          child: Text(
                            'NEW REQUESTS',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(3)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.050,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          tab1 = false;
                        });
                      },
                      child: Container(
                        height: height * 0.045,
                        child: Center(
                          child: Text(
                            'MY REQUESTS',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(3)),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: tab1
                      ? !gettabOneList
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : allowFolowList.isEmpty
                              ? Center(
                                  child: Text('Empty'),
                                )
                              : ListView.builder(
                                  itemBuilder: (c, i) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: height * 0.010,
                                        ),
                                        Row(
                                          children: [
                                            CircularProfileAvatar(
                                              '',
                                              child: Image.network(
                                                  '$baseImageUrl${allowFolowList[i].userPicture}'),
                                              borderColor: primaryColor,
                                              borderWidth: 1,
                                              elevation: 1,
                                              radius: 25,
                                            ),
                                            SizedBox(
                                              width: width * 0.030,
                                            ),
                                            Expanded(
                                                child: Column(
                                              children: [
                                                Text(
                                                  '${allowFolowList[i].userName}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            )),
                                            InkWell(
                                              child: Container(
                                                height: height * 0.040,
                                                width: width * 0.2,
                                                child: Center(
                                                    child: Text(
                                                  'ACCEPT',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          AppFonts.segoeui),
                                                )),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: primaryColor),
                                              ),
                                              onTap: () {
                                                allowfollowersAccepted(
                                                    '${allowFolowList[i].userId}');
                                                allowFolowList.removeAt(i);
                                                setState(() {});
                                              },
                                            ),
                                            SizedBox(
                                              width: width * 0.030,
                                            ),
                                            InkWell(
                                              child: Container(
                                                height: height * 0.040,
                                                width: width * 0.2,
                                                child: Center(
                                                    child: Text(
                                                  'REJECT',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          AppFonts.segoeui),
                                                )),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Colors.red),
                                              ),
                                              onTap: () {
                                                print(
                                                    '${'${allowFolowList[i].userId}'}');
                                                allowfollowersRejected(
                                                    '${allowFolowList[i].userId}');
                                                allowFolowList.removeAt(i);
                                                setState(() {});
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                  itemCount: allowFolowList.length,
                                )
                      : !gettabTwoList
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : toFolowList.isEmpty
                              ? Center(
                                  child: Text('Empty'),
                                )
                              : ListView.builder(
                                  itemBuilder: (c, i) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: height * 0.010,
                                        ),
                                        Row(
                                          children: [
                                            CircularProfileAvatar(
                                              '',
                                              child: Image.network(
                                                  '$baseImageUrl${toFolowList[i].userPicture}'),
                                              borderColor: primaryColor,
                                              borderWidth: 1,
                                              elevation: 1,
                                              radius: 25,
                                            ),
                                            SizedBox(
                                              width: width * 0.030,
                                            ),
                                            Expanded(
                                                child: Column(
                                              children: [
                                                Text(
                                                  '${toFolowList[i].userName}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            )),
                                            SizedBox(
                                              width: width * 0.030,
                                            ),
                                            InkWell(
                                              child: Container(
                                                height: height * 0.040,
                                                width: width * 0.2,
                                                child: Center(
                                                    child: Text(
                                                  'CANCEL',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          AppFonts.segoeui),
                                                )),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Colors.red),
                                              ),
                                              onTap: () {
                                                removeMyRequest(
                                                    '${toFolowList[i].userId}');
                                                toFolowList.removeAt(i);
                                                setState(() {});
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                  itemCount: toFolowList.length,
                                ))
            ],
          ),
        ),
      )),
    );
  }

  Future<void> allowfollowersList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}allowfollowersList$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": userId,
        }));
    print('allowfollowersList response is = ${response.body}');
    var data = jsonDecode(response.body);
    if (data['result'] == 'success') {
      allowFolowList = List<AllowFollowersList>.from(data['data']
              ['followersinfo']
          .map((model) => AllowFollowersList.fromJson(model)));
    }
    gettabOneList = true;
    setState(() {});
  }

  Future<void> tofollowPendingList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}tofollowPendingList$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": userId,
        }));
    print('tofollowPendingList response is = ${response.body}');
    var data = jsonDecode(response.body);
    if (data['result'] == 'success') {
      toFolowList = List<AllowFollowersList>.from(data['data']['followersinfo']
          .map((model) => AllowFollowersList.fromJson(model)));
    }
    gettabTwoList = true;
    setState(() {});
  }

  Future<void> allowfollowers(String? requestSender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}allowfollowers$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"user_id": userId, "request_sender": requestSender}));
    print('allowfollowers response is = ${response.body}');
    var data = jsonDecode(response.body);
    if (data['result'] == 'success') {}
  }

  Future<void> allowfollowersAccepted(String? requestSender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}allowfollowersAccepted$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode(
            {"user_id": userId, "request_sender": requestSender, "allow": 1}));
    print('response is = ${response.body}');
  }

  Future<void> allowfollowersRejected(String? requestSender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}allowfollowersRejected$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"user_id": userId, "request_sender": requestSender}));
    print('response is = ${response.body}');
  }

  Future<void> removeMyRequest(String? toSendRequest) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    print('toSendRequest = $toSendRequest');
    final response = await http.post(
        Uri.parse('${baseUrl}removeMyRequest$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"user_id": userId, "toSendRequest": toSendRequest}));
    print('response is = ${response.body}');
  }
}
//https://apis.rooya.com/Alphaapis/removeMyRequest?code=ROOYA-5574499
