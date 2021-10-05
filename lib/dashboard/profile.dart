import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/models/ProfileInfoModel.dart';
import 'package:rooya_app/models/RooyaPostModel.dart';
import 'package:rooya_app/models/RooyaSouqModel.dart';
import 'package:rooya_app/models/UserStoryModel.dart';
import 'package:rooya_app/rooya_souq/rooya_ad_display.dart';
import 'package:rooya_app/settings/settings.dart';
import 'package:rooya_app/story/create_story.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/widgets/user_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../view_story.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  bool isLoadingProfile = false;
  List<RooyaPostModel> mRooyaPostsList = [];
  List<RooyaSouqModel> mRooyaSouqList = [];
  ProfileInfoModel? profileInfoModel;
  UserStoryModel? userStoryModel;

  String displayName = '';
  int selectedValue = 0;

  Future<bool> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_firstname = await prefs.getString('user_firstname');
    String? user_lastname = await prefs.getString('user_lastname');
    displayName = user_firstname! + ' ' + user_lastname!;
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    getProfile();
    getProfileInfo();
    getRooyaPost();
    getRooyaSouqbyLimit();
    getStories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child: Scaffold(
          body: isLoadingProfile
              ? Container()
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 29.0.h,
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: profileInfoModel!.userCover ??
                                  'https://thumbs.dreamstime.com/b/nature-web-banner-concept-design-vector-illustration-theme-ecology-environment-natural-products-natural-healthy-life-94337908.jpg',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 25.0.h,
                                width: 100.0.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: imageProvider)),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0.h),
                                    child: Text(
                                      '${profileInfoModel!.userFirstname} ${profileInfoModel!.userLastname}',
                                      style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 16.0.sp,
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w600,
                                        shadows: [
                                          Shadow(
                                            color: const Color(0x47000000),
                                            offset: Offset(0, 3),
                                            blurRadius: 6,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                  height: 15.0.h,
                                  width: 100.0.w,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.0.w, vertical: 4.0.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(0.8.h),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 1.0.w),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: Icon(
                                      Icons.notifications,
                                      color: primaryColor,
                                      size: 2.5.h,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(0.8.h),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 1.0.w),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: Icon(
                                      Icons.edit,
                                      color: primaryColor,
                                      size: 2.5.h,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => Settings());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(0.8.h),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 1.0.w),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Icon(
                                        Icons.settings,
                                        color: primaryColor,
                                        size: 2.5.h,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(0.8.h),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 1.0.w),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: Icon(
                                      Icons.voicemail,
                                      color: primaryColor,
                                      size: 2.5.h,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: CachedNetworkImage(
                                imageUrl: profileInfoModel!.userPicture ??
                                    'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 13.0.h,
                                  width: 13.0.h,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: imageProvider)),
                                ),
                                placeholder: (context, url) => Container(
                                    height: 15.0.h,
                                    width: 100.0.w,
                                    child: Center(
                                        child: CircularProgressIndicator())),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 14.0.sp,
                                color: const Color(0xff0bab0d),
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '${profileInfoModel!.totalFollowings}\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Following',
                                  style: TextStyle(
                                    color: const Color(0xff5a5a5a),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: 4.0.w,
                          ),
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 14.0.sp,
                                color: const Color(0xff0bab0d),
                              ),
                              children: [
                                TextSpan(
                                  text: '${profileInfoModel!.totalFollowers}\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Followers',
                                  style: TextStyle(
                                    color: const Color(0xff5a5a5a),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: 4.0.w,
                          ),
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 14.0.sp,
                                color: const Color(0xff0bab0d),
                              ),
                              children: [
                                TextSpan(
                                  text: '${profileInfoModel!.totalPosts}\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Posts',
                                  style: TextStyle(
                                    color: const Color(0xff5a5a5a),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 2.0.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                        child: Text(
                          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 12,
                            color: const Color(0xff5a5a5a),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: 2.0.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // InkWell(
                                  //   onTap: () {
                                  //     setState(() {
                                  //       selectedValue = 0;
                                  //     });
                                  //   },
                                  //   child: Text(
                                  //     'ALL',
                                  //     style: TextStyle(
                                  //       fontFamily: 'Segoe UI',
                                  //       fontSize: 9.0.sp,
                                  //       fontWeight: FontWeight.w600,
                                  //       color: selectedValue == 0
                                  //           ? primaryColor
                                  //           : Colors.black,
                                  //     ),
                                  //     textAlign: TextAlign.center,
                                  //   ),
                                  // ),
                                  // Container(
                                  //   width: 1,
                                  //   height: 2.0.h,
                                  //   color: Colors.grey[500],
                                  // ),

                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedValue = 1;
                                        });
                                      },
                                      child: Text(
                                        'ROOYA',
                                        style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontSize: 9.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: selectedValue == 1
                                              ? primaryColor
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                  Container(
                                    width: 1,
                                    height: 2.0.h,
                                    color: Colors.grey[500],
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedValue = 2;
                                        });
                                      },
                                      child: Text(
                                        'STORY',
                                        style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 9.0.sp,
                                          color: selectedValue == 2
                                              ? primaryColor
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                  Container(
                                    width: 1,
                                    height: 2.0.h,
                                    color: Colors.grey[500],
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedValue = 3;
                                        });
                                      },
                                      child: Text(
                                        'MY EVENTS',
                                        style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 9.0.sp,
                                          color: selectedValue == 3
                                              ? primaryColor
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                  Container(
                                    width: 1,
                                    height: 2.0.h,
                                    color: Colors.grey[500],
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedValue = 4;
                                        });
                                      },
                                      child: Text(
                                        'ROOYA SOUQ',
                                        style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 9.0.sp,
                                          color: selectedValue == 4
                                              ? primaryColor
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 2.0.w,
                            ),
                            // Image.asset(
                            //   'assets/icons/history.png',
                            //   height: 4.0.h,
                            //   width: 4.0.h,
                            // )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.0.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                        child: selectedValue == 0
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 7.0.h,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 6.0.w),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Center(
                                      child: TextFormField(
                                        // controller: mMobileNumber,
                                        cursorColor: Colors.black,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontSize: 10.0.sp,
                                          color: const Color(0xff1e1e1e),
                                        ),
                                        decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 15, right: 15),
                                          hintText: 'Search here...',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Segoe UI',
                                            fontSize: 9.0.sp,
                                            color: const Color(0xff1e1e1e),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.0.w),
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: mRooyaPostsList.length,
                                        itemBuilder: (context, index) {
                                          return UserPost(
                                            rooyaPostModel:
                                                mRooyaPostsList[index],
                                          );
                                        }),
                                  ))
                                ],
                              )
                            : selectedValue == 1
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        height: 7.0.h,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 6.0.w),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Center(
                                          child: TextFormField(
                                            // controller: mMobileNumber,
                                            cursorColor: Colors.black,
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                              fontFamily: 'Segoe UI',
                                              fontSize: 10.0.sp,
                                              color: const Color(0xff1e1e1e),
                                            ),
                                            decoration: new InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  left: 15, right: 15),
                                              hintText: 'Search here...',
                                              hintStyle: TextStyle(
                                                fontFamily: 'Segoe UI',
                                                fontSize: 9.0.sp,
                                                color: const Color(0xff1e1e1e),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                          child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.0.w),
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: mRooyaPostsList.length,
                                            itemBuilder: (context, index) {
                                              return UserPost(
                                                rooyaPostModel:
                                                    mRooyaPostsList[index],
                                              );
                                            }),
                                      ))
                                    ],
                                  )
                                : selectedValue == 2
                                    ? GridView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        itemCount:
                                            userStoryModel!.items!.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 0.8,
                                                // crossAxisSpacing: 5.0.w,
                                                mainAxisSpacing: 2.0.w,
                                                crossAxisCount: 4),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return index == 0
                                              ? InkWell(
                                                  onTap: () {
                                                    Get.to(() => CreateStory())!
                                                        .then((value) {
                                                      if (value != null) {
                                                        getStories();
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 18.0.h,
                                                    width: 25.0.w,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0.8.h),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Center(
                                                        child: Icon(
                                                      Icons.add_circle,
                                                      color: primaryColor,
                                                      size: 5.0.h,
                                                    )),
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    Get.to(() => ViewStory(
                                                        picUrl:
                                                            '$baseImageUrl${userStoryModel!.items![index].src}'));
                                                  },
                                                  child: Container(
                                                    height: 18.0.h,
                                                    width: 25.0.w,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0.8.h),
                                                    decoration: BoxDecoration(
                                                        // color: Colors.red,
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey[300]!),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: NetworkImage(
                                                                '$baseImageUrl${userStoryModel!.items![index].src}'))),
                                                  ),
                                                );
                                          return InkWell(
                                            onTap: () {},
                                            child: Container(
                                              height: 18.0.h,
                                              width: 25.0.w,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 0.8.h),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                  child: Icon(
                                                Icons.add_circle,
                                                color: primaryColor,
                                                size: 5.0.h,
                                              )),
                                            ),
                                          );
                                        },
                                      )
                                    : selectedValue == 3
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemCount: 4,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisSpacing: 2.0.w,
                                                        mainAxisSpacing: 2.0.w,
                                                        childAspectRatio:
                                                            100.0.w / 22.0.h,
                                                        crossAxisCount: 2),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return InkWell(
                                                      onTap: () {},
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    primaryColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'OM Chanting @Breathe Yoga Studio',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Segoe UI',
                                                                fontSize:
                                                                    8.0.sp,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Wed, 23 Dec 2020, 8:00 pm',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Segoe UI',
                                                                fontSize:
                                                                    8.0.sp,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                },
                                              ),
                                            ],
                                          )
                                        : selectedValue == 4
                                            ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                    child: GridView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          mRooyaSouqList.length,
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisSpacing:
                                                                  5.0.w,
                                                              mainAxisSpacing:
                                                                  2.0.w,
                                                              crossAxisCount:
                                                                  2),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return InkWell(
                                                          onTap: () {
                                                            Get.to(() =>
                                                                RooyaAdDisplay(
                                                                  rooyaSouqModel:
                                                                      mRooyaSouqList[
                                                                          index],
                                                                ));
                                                          },
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                height: 15.0.h,
                                                                width: 100.0.w,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    image: DecorationImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        image: NetworkImage(
                                                                            '$baseImageUrl${mRooyaSouqList[index].attachment![0].source}'))),
                                                              ),
                                                              SizedBox(
                                                                height: 0.5.h,
                                                              ),
                                                              Text(
                                                                '${mRooyaSouqList[index].name} (${mRooyaSouqList[index].categoryName})',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Segoe UI',
                                                                  fontSize: 9,
                                                                  color: const Color(
                                                                      0xff000000),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                              SizedBox(
                                                                height: 0.5.h,
                                                              ),
                                                              Text(
                                                                '${mRooyaSouqList[index].text}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Segoe UI',
                                                                  fontSize: 9,
                                                                  color: const Color(
                                                                      0xff000000),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                            'AED ${mRooyaSouqList[index].price}',
                                                                            overflow: TextOverflow
                                                                                .ellipsis,
                                                                            style: TextStyle(
                                                                                color: const Color(0xff0bab0d),
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 8.0.sp)),
                                                                        Icon(
                                                                          Icons
                                                                              .favorite,
                                                                          color:
                                                                              primaryColor,
                                                                          size:
                                                                              2.0.h,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      '${mRooyaSouqList[index].status}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Segoe UI',
                                                                        fontSize:
                                                                            8.0.sp,
                                                                        color: const Color(
                                                                            0xff5a5a5a),
                                                                      ))
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Container(),
                      )
                    ],
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
    int? userId = await prefs.getInt('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}getRooyaProfilePosts${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode(
            {"page_size": 100, "page_number": 1, "user_id": userId}));

    setState(() {
      isLoading = false;
    });

    print(response.request);
    print(response.statusCode);
    print(response.body);

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
    }
  }

  Future<void> getRooyaSouqbyLimit() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? user_id = await prefs.getString('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}getProfileSouqProducts${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode(
            {"user_id": user_id, "page_size": 100, "page_number": 1}));

    setState(() {
      isLoading = false;
    });

    print(response.request);
    print(response.statusCode);
    // print(response.body);
    // log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          mRooyaSouqList = List<RooyaSouqModel>.from(
              data['data'].map((model) => RooyaSouqModel.fromJson(model)));
        });
      } else {
        setState(() {});
      }
    }
  }

  Future<void> getStories() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? user_id = await prefs.getString('user_id');
    final response = await http.post(Uri.parse('${baseUrl}getStories${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"user_id": user_id}));

    setState(() {
      isLoading = false;
    });

    print(response.request);
    print(response.statusCode);
    // print(response.body);
    // log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          userStoryModel = UserStoryModel.fromJson(data['data'][0]);
          userStoryModel!.items!.insert(0, Items(type: 'newUserStory'));
        });
      } else {
        setState(() {});
      }
    }
  }

  Future<void> getProfileInfo() async {
    setState(() {
      isLoadingProfile = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    int? user_id = await prefs.getInt('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}getProfileInfo${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"profile_id": user_id, "user_id": user_id}));

    setState(() {
      isLoadingProfile = false;
    });

    print(response.request);
    print(response.statusCode);
    // print(response.body);
    // log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          profileInfoModel = ProfileInfoModel.fromJson(data['data'][0]);
        });
      } else {
        setState(() {});
      }
    }
  }
}
