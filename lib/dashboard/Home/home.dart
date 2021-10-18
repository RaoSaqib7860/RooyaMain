import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/ApiUtils/AuthUtils.dart';
import 'package:rooya_app/create_all.dart';
import 'package:rooya_app/dashboard/Home/HomeController/HomeController.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import 'package:rooya_app/story/create_story.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/dashboard/Home/HomeComponents/user_post.dart';
import 'package:sizer/sizer.dart';

import 'HomeComponents/StoryViews.dart';

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
    // getRooyaPost();
    AuthUtils.getAllStoriesAPI(controller: controller);
    AuthUtils.getgetHomeBanner(controller: controller);
    AuthUtils.getgetRooyaPostByLimite(controller: controller);
    super.initState();
  }

  Future<void> _pullRefresh() async {
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await AuthUtils.getgetRooyaPostByLimite(controller: controller);
        },
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
                                InkWell(
                                  child: Container(
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
                                      color: Colors.blueGrey[100]!
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onTap: () {
                                    selectLocation(controller);
                                  },
                                ),
                                Expanded(
                                  child: Obx(
                                    () => !controller.storyLoad.value
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            physics: BouncingScrollPhysics(),
                                            itemCount: 4,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return ShimerEffect(
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: 14.0.h,
                                                      width: 20.0.w,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  0.5.h),
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
                                            })
                                        : controller.listofStories.isEmpty
                                            ? SizedBox()
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemCount: controller
                                                    .listofStories.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  String type = controller
                                                      .listofStories[index]
                                                      .storyobjects![0]
                                                      .type!;
                                                  return Stack(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Get.to(MoreStories(
                                                            storyobjects: controller
                                                                .listofStories[
                                                                    index]
                                                                .storyobjects,
                                                          ));
                                                        },
                                                        child: Container(
                                                          height: 14.0.h,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child: type ==
                                                                    'photo'
                                                                ? CachedNetworkImage(
                                                                    imageUrl:
                                                                        "$baseImageUrl${controller.listofStories[index].storyobjects![0].src}",
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    progressIndicatorBuilder: (context,
                                                                            url,
                                                                            downloadProgress) =>
                                                                        ShimerEffect(
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/images/home_banner.png',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image
                                                                            .asset(
                                                                      'assets/images/home_banner.png',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  )
                                                                : Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .play_circle_fill,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 30,
                                                                    ),
                                                                  ),
                                                          ),
                                                          width: 20.0.w,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      0.5.h),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  top: 5),
                                                          child:
                                                              CircularProfileAvatar(
                                                            '',
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  "$baseImageUrl${controller.listofStories[index].storyobjects![0].userPicture}",
                                                              fit: BoxFit.cover,
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                          downloadProgress) =>
                                                                      ShimerEffect(
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/home_banner.png',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Image.asset(
                                                                'assets/images/home_banner.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            borderColor:
                                                                primaryColor,
                                                            elevation: 5,
                                                            borderWidth: 1,
                                                            radius: 10,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
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
                                  AuthUtils.getgetRooyaPostByLimite(
                                      controller: controller);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(1.0.h),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xff0bab0d)),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text('Add Rooya',
                                      style: TextStyle(
                                        fontFamily: AppFonts.segoeui,
                                        fontSize: 12,
                                        color: const Color(0xff0bab0d),
                                        fontWeight: FontWeight.w700,
                                      )),
                                ),
                              )
                            ],
                          ),
                          Obx(() => !controller.storyLoad.value
                              ? Container(
                                  height: 300,
                                  width: width,
                                  child: Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                )
                              : controller.listofpost.isEmpty
                                  ? Container(
                                      height: 300,
                                      width: width,
                                      child: Center(
                                        child: Text(
                                          '',
                                          style: TextStyle(
                                              fontFamily: AppFonts.segoeui),
                                        ),
                                      ),
                                    )
                                  : Flexible(
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              controller.listofpost.length,
                                          itemBuilder: (context, index) {
                                            return UserPost(
                                              rooyaPostModel:
                                                  controller.listofpost[index],
                                              onPostLike: () {
                                                setState(() {
                                                  controller.listofpost[index]
                                                      .islike = true;
                                                  // ++mRooyaPostsList[index].likecount;
                                                });
                                              },
                                              onPostUnLike: () {
                                                setState(() {
                                                  controller.listofpost[index]
                                                      .islike = false;
                                                  // --mRooyaPostsList[index].likecount;
                                                });
                                              },
                                            );
                                          })))
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
}

selectLocation(HomeController controller) {
  var height = MediaQuery.of(Get.context!).size.height;
  var width = MediaQuery.of(Get.context!).size.width;
  showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.black.withOpacity(0.5),
          insetPadding: EdgeInsets.symmetric(horizontal: width / 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)),
          //this right here
          child: Container(
            height: height / 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(CreateStory(
                      from: 'video',
                    ))!
                        .then((value) {
                      AuthUtils.getAllStoriesAPI(controller: controller);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.all(7),
                    child: Text(
                      'Upload Videos',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.segoeui,
                          fontSize: 13),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(CreateStory(
                      from: 'image',
                    ))!
                        .then((value) {
                      AuthUtils.getAllStoriesAPI(controller: controller);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.all(7),
                    child: Text(
                      'Upload Images',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.segoeui,
                          fontSize: 13),
                    ),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8)),
          ),
        );
      });
}