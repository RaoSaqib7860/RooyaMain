import 'dart:convert';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rooya_app/dashboard/profile.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../../ApiUtils/baseUrl.dart';
import '../../SharePost.dart';
import 'Models/FolowModel.dart';

class AllFolowFolowers extends StatefulWidget {
  final bool? folowers;
  final String? userID;
  final bool? owner;
  final String? userName;

  const AllFolowFolowers(
      {Key? key, this.folowers, this.userID, this.owner = false, this.userName})
      : super(key: key);

  @override
  _AllFolowFolowersState createState() => _AllFolowFolowersState();
}

class _AllFolowFolowersState extends State<AllFolowFolowers> {
  List<Folowers> listofFolowers = [];
  List<Folowers> listofFolowing = [];

  List listofVisitor = [];

  bool loading = false;

  @override
  void initState() {
    getFollowerData();
    getFollowingData();
    getVisitorData();
    super.initState();
  }

  TabController? _tabController;
  GetStorage storage = GetStorage();

  String searchText = '';

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
            centerTitle: true,
            title: Text(
              '${widget.userName}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.segoeui),
            ),
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back, color: Colors.black)),
          ),
          body: Column(
            children: [
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  initialIndex: !widget.folowers! ? 0 : 1,
                  child: Scaffold(
                    body: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.040),
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            tabs: [
                              Tab(
                                text: 'Followers',
                              ),
                              Tab(
                                text: 'Followings',
                              )
                            ],
                            indicator: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.green, width: 3),
                                )),
                            indicatorColor: Colors.green,
                            labelColor: Colors.black,
                            labelStyle: TextStyle(fontSize: 12.0.sp),
                            unselectedLabelColor: Colors.grey,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.060,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: TextFormField(
                                // controller: mMobileNumber,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontFamily: AppFonts.segoeui,
                                  fontSize: 10.0.sp,
                                  color: const Color(0xff1e1e1e),
                                ),
                                onChanged: (value) {
                                  searchText = value;
                                  setState(() {});
                                },
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(left: 15, right: 15),
                                  hintText: 'Search here...',
                                  hintStyle: TextStyle(
                                    fontFamily: AppFonts.segoeui,
                                    fontSize: 9.0.sp,
                                    color: const Color(0xff1e1e1e),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.030),
                                  child: Column(
                                    children: [
                                      Expanded(
                                          child: ListView.builder(
                                        itemBuilder: (c, i) {
                                          if ('${listofFolowing[i].userName}'
                                                  .toLowerCase()
                                                  .contains(searchText
                                                      .toLowerCase())) {
                                            if(listofFolowing[i]
                                                .userId
                                                .toString() ==
                                                '${storage.read('userID')}'){
                                              return Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(Profile(
                                                        userID:
                                                        '${listofFolowing[i].userId}',
                                                      ));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        listofFolowing[i]
                                                            .userPicture ==
                                                            null
                                                            ? CircularProfileAvatar(
                                                          '',
                                                          child: Image.asset(
                                                              'assets/images/logo.png'),
                                                          radius: 23,
                                                          borderColor:
                                                          primaryColor,
                                                          borderWidth: 1,
                                                        )
                                                            : CircularProfileAvatar(
                                                          '$baseImageUrl${listofFolowing[i].userPicture}',
                                                          radius: 23,
                                                          borderColor:
                                                          primaryColor,
                                                          borderWidth: 1,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () {},
                                                          child: Text(
                                                            '${listofFolowing[i].userName}',
                                                            style: TextStyle(
                                                                color:
                                                                Colors.black,
                                                                fontFamily:
                                                                AppFonts
                                                                    .segoeui,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              );
                                            }else{
                                              return Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(Profile(
                                                        userID:
                                                        '${listofFolowing[i].userId}',
                                                      ));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        listofFolowing[i]
                                                            .userPicture ==
                                                            null
                                                            ? CircularProfileAvatar(
                                                          '',
                                                          child: Image.asset(
                                                              'assets/images/logo.png'),
                                                          radius: 23,
                                                          borderColor:
                                                          primaryColor,
                                                          borderWidth: 1,
                                                        )
                                                            : CircularProfileAvatar(
                                                          '$baseImageUrl${listofFolowing[i].userPicture}',
                                                          radius: 23,
                                                          borderColor:
                                                          primaryColor,
                                                          borderWidth: 1,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () {},
                                                          child: Text(
                                                            '${listofFolowing[i].userName}',
                                                            style: TextStyle(
                                                                color:
                                                                Colors.black,
                                                                fontFamily:
                                                                AppFonts
                                                                    .segoeui,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Row(
                                                              children: [
                                                                widget.owner!
                                                                    ? Row(
                                                                  children: [
                                                                    InkWell(
                                                                      child:
                                                                      Container(
                                                                        height: height *
                                                                            0.040,
                                                                        width: width *
                                                                            0.2,
                                                                        child: Center(
                                                                            child: Text(
                                                                              listofVisitor.contains(listofFolowing[i].userId)
                                                                                  ? 'UnFollow'
                                                                                  : 'Follow Back',
                                                                              style: TextStyle(
                                                                                  fontSize: 10,
                                                                                  color: Colors.white,
                                                                                  fontFamily: AppFonts.segoeui),
                                                                            )),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                            BorderRadius.circular(30),
                                                                            color: primaryColor),
                                                                      ),
                                                                      onTap:
                                                                          () async {
                                                                        print(
                                                                            'listofVisitor = $listofVisitor');
                                                                        if (!listofVisitor
                                                                            .contains(listofFolowing[i].userId)) {
                                                                          print(
                                                                              'Folow');
                                                                          listofVisitor
                                                                              .add(listofFolowing[i].userId);
                                                                          folow(
                                                                              '${listofFolowing[i].userId}');
                                                                          setState(
                                                                                  () {});
                                                                        } else {
                                                                          print(
                                                                              'Unfollow');
                                                                          listofVisitor
                                                                              .remove(listofFolowing[i].userId);
                                                                          unfolow(
                                                                              follow_id: '${listofFolowing[i].userId}');
                                                                          setState(
                                                                                  () {});
                                                                        }
                                                                        print(
                                                                            'listofVisitor = $listofVisitor');
                                                                        setState(
                                                                                () {});
                                                                      },
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    !widget.owner!
                                                                        ? SizedBox()
                                                                        : InkWell(
                                                                      child:
                                                                      Container(
                                                                        height: height * 0.040,
                                                                        width: width * 0.180,
                                                                        child: Center(
                                                                            child: Text(
                                                                              'Remove',
                                                                              style: TextStyle(fontSize: 10, color: Colors.white, fontFamily: AppFonts.segoeui),
                                                                            )),
                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.red),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        remove(follow_id: '${listofFolowing[i].userId}');
                                                                        listofFolowing.removeAt(i);
                                                                        setState(() {});
                                                                      },
                                                                    )
                                                                  ],
                                                                )
                                                                    : widget.owner!
                                                                    ? SizedBox()
                                                                    : InkWell(
                                                                  child:
                                                                  Container(
                                                                    height: height *
                                                                        0.040,
                                                                    width: width *
                                                                        0.2,
                                                                    child: Center(
                                                                        child: Text(
                                                                          listofVisitor.contains(listofFolowing[i].userId)
                                                                              ? 'UnFollow'
                                                                              : 'follow',
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              color: Colors.white,
                                                                              fontFamily: AppFonts.segoeui),
                                                                        )),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                        BorderRadius.circular(30),
                                                                        color: primaryColor),
                                                                  ),
                                                                  onTap:
                                                                      () {
                                                                    print(
                                                                        'listofVisitor = $listofVisitor');
                                                                    if (!listofVisitor
                                                                        .contains(listofFolowing[i].userId)) {
                                                                      print(
                                                                          'Folow');
                                                                      listofVisitor
                                                                          .add(listofFolowing[i].userId);
                                                                      folow(
                                                                          '${listofFolowing[i].userId}');
                                                                      setState(
                                                                              () {});
                                                                    } else {
                                                                      print(
                                                                          'Unfollow');
                                                                      listofVisitor
                                                                          .remove(listofFolowing[i].userId);
                                                                      unfolow(
                                                                          follow_id: '${listofFolowing[i].userId}');
                                                                      setState(
                                                                              () {});
                                                                    }
                                                                    print(
                                                                        'listofVisitor = $listofVisitor');
                                                                    setState(
                                                                            () {});
                                                                  },
                                                                )
                                                              ],
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              );
                                            }
                                          } else {
                                            return SizedBox();
                                          }
                                        },
                                        itemCount: listofFolowing.length,
                                      ))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.030),
                                  child: Column(
                                    children: [
                                      Expanded(
                                          child: ListView.builder(
                                        itemBuilder: (c, i) {
                                          if ('${listofFolowers[i].userName}'
                                                  .toLowerCase()
                                                  .contains(searchText
                                                      .toLowerCase())) {
                                            if(listofFolowers[i]
                                                .userId
                                                .toString() ==
                                                '${storage.read('userID')}'){
                                              return Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(Profile(
                                                        userID:
                                                        '${listofFolowers[i].userId}',
                                                      ));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        listofFolowers[i]
                                                            .userPicture ==
                                                            null
                                                            ? CircularProfileAvatar(
                                                          '',
                                                          child: Image.asset(
                                                              'assets/images/logo.png'),
                                                          radius: 23,
                                                          borderColor:
                                                          primaryColor,
                                                          borderWidth: 1,
                                                        )
                                                            : CircularProfileAvatar(
                                                          '$baseImageUrl${listofFolowers[i].userPicture}',
                                                          radius: 23,
                                                          borderColor:
                                                          primaryColor,
                                                          borderWidth: 1,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () {},
                                                          child: Text(
                                                            '${listofFolowers[i].userName}',
                                                            style: TextStyle(
                                                                color:
                                                                Colors.black,
                                                                fontFamily:
                                                                AppFonts
                                                                    .segoeui,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              );
                                            }else{
                                              return Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(Profile(
                                                        userID:
                                                        '${listofFolowers[i].userId}',
                                                      ));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        listofFolowers[i]
                                                            .userPicture ==
                                                            null
                                                            ? CircularProfileAvatar(
                                                          '',
                                                          child: Image.asset(
                                                              'assets/images/logo.png'),
                                                          radius: 23,
                                                          borderColor:
                                                          primaryColor,
                                                          borderWidth: 1,
                                                        )
                                                            : CircularProfileAvatar(
                                                          '$baseImageUrl${listofFolowers[i].userPicture}',
                                                          radius: 23,
                                                          borderColor:
                                                          primaryColor,
                                                          borderWidth: 1,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: () {},
                                                          child: Text(
                                                            '${listofFolowers[i].userName}',
                                                            style: TextStyle(
                                                                color:
                                                                Colors.black,
                                                                fontFamily:
                                                                AppFonts
                                                                    .segoeui,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    InkWell(
                                                                      child:
                                                                      Container(
                                                                        height:
                                                                        height *
                                                                            0.040,
                                                                        width: width *
                                                                            0.2,
                                                                        child: Center(
                                                                            child:
                                                                            Text(
                                                                              listofVisitor
                                                                                  .contains(listofFolowers[i].userId)
                                                                                  ? 'UnFollow'
                                                                                  : 'Follow',
                                                                              style: TextStyle(
                                                                                  fontSize:
                                                                                  10,
                                                                                  color: Colors
                                                                                      .white,
                                                                                  fontFamily:
                                                                                  AppFonts.segoeui),
                                                                            )),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                            BorderRadius.circular(
                                                                                30),
                                                                            color:
                                                                            primaryColor),
                                                                      ),
                                                                      onTap:
                                                                          () async {
                                                                        print(
                                                                            'listofVisitor = $listofVisitor');
                                                                        if (!listofVisitor
                                                                            .contains(
                                                                            listofFolowers[i]
                                                                                .userId)) {
                                                                          print(
                                                                              'Folow');
                                                                          folow(
                                                                              '${listofFolowers[i].userId}');
                                                                          listofVisitor.add(
                                                                              listofFolowers[i]
                                                                                  .userId);
                                                                          setState(
                                                                                  () {});
                                                                        } else {
                                                                          print(
                                                                              'Unfollow');
                                                                          unfolow(
                                                                              follow_id:
                                                                              '${listofFolowers[i].userId}');
                                                                          listofVisitor
                                                                              .remove(
                                                                              listofFolowers[i].userId);
                                                                          setState(
                                                                                  () {});
                                                                        }
                                                                        print(
                                                                            'listofVisitor = $listofVisitor');
                                                                      },
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              );
                                            }
                                          } else {
                                            return SizedBox();
                                          }
                                        },
                                        itemCount: listofFolowers.length,
                                      ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> unfolow({String? follow_id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}ProfileUnFollow$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({'follow_id': follow_id, "user_id": userId}));
  }

  Future<void> remove({String? follow_id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}ProfileUnFollow$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({'follow_id': userId, "user_id": follow_id}));
    print('${response.body}');
  }

  Future<void> folow(String? following_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}ProfileFollow$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({'following_id': following_id, "user_id": userId}));
  }

  Future<void> getFollowerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}myfollowers$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": int.parse(widget.userID!),
        }));
    print('response is = ${response.body}');
    var data = jsonDecode(response.body);
    if (data['result'] == 'success') {
      listofFolowers = List<Folowers>.from(data['data']['followersinfo']
          .map((model) => Folowers.fromJson(model)));
      setState(() {});
    }
  }

  Future<void> getFollowingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}myfollowings$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": int.parse(widget.userID!),
        }));
    print('response is = ${response.body}');
    var data = jsonDecode(response.body);
    if (data['result'] == 'success') {
      listofFolowing = List<Folowers>.from(data['data']['followingsinfo']
          .map((model) => Folowers.fromJson(model)));
      setState(() {});
    }
  }

  Future<void> getVisitorData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userID = await prefs.getString('user_id');
    final response = await http.post(Uri.parse('${baseUrl}myfollowers$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": userID,
        }));
    print('getVisitorData response is = ${response.body}');
    var data = jsonDecode(response.body);
    if (data['result'] == 'success') {
      List<Folowers> list = [];
      list = List<Folowers>.from(data['data']['followersinfo']
          .map((model) => Folowers.fromJson(model)));
      for (var i in list) {
        listofVisitor.add(i.userId);
      }
      setState(() {});
    }
  }
}
