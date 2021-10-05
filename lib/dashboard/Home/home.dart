import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/ApiUtils/AuthUtils.dart';
import 'package:rooya_app/Screens/AuthScreens/sign_in_tabs_handle.dart';
import 'package:rooya_app/create_all.dart';
import 'package:rooya_app/dashboard/Home/HomeController.dart';
import 'package:rooya_app/models/RooyaPostModel.dart';
import 'package:rooya_app/rooya_post/create_post.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/view_story.dart';
import 'package:rooya_app/widgets/user_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import 'HomeBannerModel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  List<RooyaPostModel> mRooyaPostsList = [];
  final controller = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    print('Home call now ');
    getRooyaPost();
    AuthUtils.getAllStoriesAPI(controller: controller);
    AuthUtils.getgetHomeBanner(controller: controller);
    super.initState();
  }

  Future<void> _pullRefresh() async {
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: getRooyaPost,
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 1.0.h, vertical: 1.30.h),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 4.0.h,
                  ),
                  Expanded(
                    child: Container(
                      height: 4.50.h,
                      margin: EdgeInsets.symmetric(horizontal: 2.0.w),
                      padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'Search here...',
                              style: TextStyle(
                                  fontFamily: AppFonts.segoeui,
                                  fontSize: 9.0.sp),
                            ),
                          ),
                          Icon(
                            CupertinoIcons.search,
                            size: 17,
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
                        size: 22,
                      )),
                  SizedBox(
                    width: 1.0.w,
                  ),
                  Icon(
                    Icons.notifications,
                    color: Colors.black,
                    size: 22,
                  ),
                  SizedBox(
                    width: 1.0.w,
                  ),
                  Icon(
                    Icons.mail,
                    size: 22,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: height * 0.240,
                      width: width,
                      child: Obx(
                        () => controller.listofbanner.isEmpty
                            ? ShimerEffect(
                                child: Image.asset(
                                  'assets/images/home_banner.png',
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CarouselSlider(
                                items: controller.listofbanner.map((e) {
                                  int index =
                                      controller.listofbanner.indexOf(e);
                                  return CachedNetworkImage(
                                    imageUrl:
                                        "$baseImageUrl${controller.listofbanner[index].bannerImage}",
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            ShimerEffect(
                                      child: Image.asset(
                                        'assets/images/home_banner.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      'assets/images/home_banner.png',
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                  height: height * 0.280,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 1,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 5),
                                  autoPlayAnimationDuration:
                                      Duration(seconds: 2),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                )),
                      ),
                      decoration: BoxDecoration(color: Colors.black),
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
                                fontFamily: AppFonts.segoeui,
                                fontSize: 14,
                                color: const Color(0xff0bab0d),
                              ),
                              textAlign: TextAlign.center,
                            ))),
                        Container(
                          height: 3.50.h,
                          width: 1,
                          color: Colors.grey,
                        ),
                        Expanded(
                            flex: 1,
                            child: Center(
                                child: Text(
                              'For you',
                              style: TextStyle(
                                fontFamily: AppFonts.segoeui,
                                fontSize: 14,
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
                                  fontFamily: AppFonts.segoeui,
                                  fontSize: 16,
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 20,
                                color: primaryColor,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 1.0.h,
                          ),
                          Container(
                            height: 14.0.h,
                            width: width,
                            child: Row(
                              children: [
                                Container(
                                  height: 14.0.h,
                                  width: 20.0.w,
                                  child: Center(
                                    child: Icon(
                                      Icons.add_circle,
                                      color: primaryColor,
                                      size: 30,
                                    ),
                                  ),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 0.5.h),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.blueGrey[100]!.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                Expanded(
                                  child: Obx(
                                    () => ListView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: controller
                                                .listofStories.isEmpty
                                            ? 4
                                            : controller.listofStories.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          if (controller
                                              .listofStories.isEmpty) {
                                            return ShimerEffect(
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: 14.0.h,
                                                    width: 20.0.w,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0.5.h),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: AssetImage(
                                                                'assets/images/story.png'))),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Stack(
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 14.0.h,
                                                    width: 20.0.w,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0.5.h),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: AssetImage(
                                                                'assets/images/story.png'))),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8, top: 5),
                                                    child:
                                                        CircularProfileAvatar(
                                                      '',
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "$baseImageUrl${controller.listofStories[index].userPicture}",
                                                        fit: BoxFit.cover,
                                                        progressIndicatorBuilder:
                                                            (context, url,
                                                                    downloadProgress) =>
                                                                ShimerEffect(
                                                          child: Image.asset(
                                                            'assets/images/home_banner.png',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          'assets/images/home_banner.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      borderColor: primaryColor,
                                                      elevation: 5,
                                                      borderWidth: 1,
                                                      radius: 10,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3.0.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rooya',
                                style: TextStyle(
                                  fontFamily: AppFonts.segoeui,
                                  fontSize: 16,
                                  color: Color(0xff000000),
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
                                      borderRadius: BorderRadius.circular(5)),
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
          ],
        ),
      ),
    );
  }

  Future<void> getRooyaPost() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}getRooyaPostByLimite$code'),
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
