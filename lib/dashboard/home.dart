import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/create_all.dart';
import 'package:rooya_app/login/sign_in_tabs_handle.dart';
import 'package:rooya_app/models/RooyaPostModel.dart';
import 'package:rooya_app/rooya_post/create_post.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/baseUrl.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/view_story.dart';
import 'package:rooya_app/widgets/user_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  List<RooyaPostModel> mRooyaPostsList = [];

  @override
  void initState() {
    // TODO: implement initState
    getRooyaPost();
    super.initState();
  }

  Future<void> _pullRefresh() async {
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child: Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: getRooyaPost,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.0.h, vertical: 1.0.h),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 5.0.h,
                          ),
                          Expanded(
                            child: Container(
                              height: 5.0.h,
                              margin: EdgeInsets.symmetric(horizontal: 2.0.w),
                              padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(25)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Search here...',
                                      style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontSize: 9.0.sp),
                                    ),
                                  ),
                                  Icon(
                                    Icons.search,
                                    color: primaryColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Get.to(() => CreateAll());
                              },
                              child: Icon(
                                Icons.add_circle,
                                color: primaryColor,
                              )),
                          SizedBox(
                            width: 1.0.w,
                          ),
                          Icon(
                            Icons.notifications,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 1.0.w,
                          ),
                          Icon(
                            Icons.mail,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0.h,
                      width: 100.0.w,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/home_banner.png'),
                              fit: BoxFit.fill)),
                    ),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Center(
                                child: Text(
                              'Following',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 18,
                                color: const Color(0xff0bab0d),
                              ),
                              textAlign: TextAlign.center,
                            ))),
                        Container(
                          height: 4.0.h,
                          width: 1,
                          color: Colors.grey,
                        ),
                        Expanded(
                            flex: 1,
                            child: Center(
                                child: Text(
                              'For you',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 18,
                                color: const Color(0xff0bab0d),
                              ),
                              textAlign: TextAlign.center,
                            )))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.0.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 1.0.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Stories',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 16,
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: primaryColor,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 1.0.h,
                          ),
                          Container(
                            height: 18.0.h,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Get.to(() => ViewStory(
                                          picUrl:
                                              'https://images.squarespace-cdn.com/content/v1/584dd9c759cc6892ae0f8c0b/1544199409101-RYACT0TS8Z1GDGEUBLLB/19_Ekman+110+Byline+Karin+T%C3%B6rnblom+f%C3%B6r+Zap+Events.JPG?format=1000w'));
                                    },
                                    child: Container(
                                      height: 18.0.h,
                                      width: 25.0.w,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 0.8.h),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  'assets/images/story.png'))),
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 2.0.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rooya',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 16,
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => CreatePost())!
                                      .then((value) => getRooyaPost());
                                },
                                child: Container(
                                  padding: EdgeInsets.all(1.0.h),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xff0bab0d)),
                                      borderRadius:
                                          BorderRadius.circular(1.5.h)),
                                  child: Text('Add Rooya',
                                      style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 12,
                                        color: const Color(0xff0bab0d),
                                        fontWeight: FontWeight.w700,
                                      )),
                                ),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   height: 2.0.h,
                          // ),
                          Flexible(
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: mRooyaPostsList.length,
                                  itemBuilder: (context, index) {
                                    return UserPost(
                                      rooyaPostModel: mRooyaPostsList[index],
                                      onPostLike: () {
                                        setState(() {
                                          mRooyaPostsList[index].islike = true;
                                         // ++mRooyaPostsList[index].likecount;
                                        });
                                      },
                                      onPostUnLike: () {
                                        setState(() {
                                          mRooyaPostsList[index].islike = false;
                                         // --mRooyaPostsList[index].likecount;
                                        });
                                      },
                                    );
                                  }))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> getRooyaPost() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}getRooyaPostByLimite${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"page_size": 100, "page_number": 0}));

    setState(() {
      isLoading = false;
    });

    print(response.request);
    print(response.statusCode);
    print(response.body);
    log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          mRooyaPostsList = List<RooyaPostModel>.from(
              data['data'].map((model) => RooyaPostModel.fromJson(model)));
        });
      } else {
        setState(() {});
      }
    } else if (response.statusCode == 401) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAll(() => SignInTabsHandle());
    }
  }
}
