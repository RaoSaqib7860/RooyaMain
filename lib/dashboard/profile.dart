import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/Screens/Settings/Settings.dart';
import 'package:rooya_app/models/ProfileInfoModel.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import 'package:rooya_app/models/RooyaSouqModel.dart';
import 'package:rooya_app/models/UserStoryModel.dart';
import 'package:rooya_app/rooya_souq/rooya_ad_display.dart';
import 'package:rooya_app/story/create_story.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/dashboard/Home/HomeComponents/user_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../view_story.dart';

class Profile extends StatefulWidget {
  final String? userID;

  const Profile({Key? key, this.userID}) : super(key: key);

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
    getProfile();
    getProfileInfo();
    getRooyaPost();
    getRooyaSouqbyLimit();
    getStories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoadingProfile
            ? ShimerEffect(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 29.0.h,
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl:
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
                                      'ABC acc',
                                      style: TextStyle(
                                        fontFamily: AppFonts.segoeui,
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
                                  horizontal: 2.0.w, vertical: 1.0.h),
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
                                  Container(
                                    padding: EdgeInsets.all(0.8.h),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 1.0.w),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: Icon(
                                      Icons.settings,
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
                              child: Container(
                                margin: EdgeInsets.only(left: width * 0.090),
                                child: CircularProfileAvatar(
                                  'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm',
                                  radius: 35,
                                  borderColor: primaryColor,
                                  elevation: 10,
                                  borderWidth: 1,
                                ),
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
                                fontFamily: AppFonts.segoeui,
                                fontSize: 12,
                                color: const Color(0xff0bab0d),
                              ),
                              children: [
                                TextSpan(
                                  text: '23',
                                  style: TextStyle(
                                    fontFamily: AppFonts.segoeui,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Following',
                                  style: TextStyle(
                                    fontFamily: AppFonts.segoeui,
                                    color: const Color(0xff5a5a5a),
                                    fontSize: 13,
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
                                fontFamily: AppFonts.segoeui,
                                fontSize: 12,
                                color: const Color(0xff0bab0d),
                              ),
                              children: [
                                TextSpan(
                                  text: '12',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    fontFamily: AppFonts.segoeui,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Followers',
                                  style: TextStyle(
                                    color: const Color(0xff5a5a5a),
                                    fontSize: 13,
                                    fontFamily: AppFonts.segoeui,
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
                                color: const Color(0xff5a5a5a),
                                fontSize: 12,
                                fontFamily: AppFonts.segoeui,
                              ),
                              children: [
                                TextSpan(
                                  text: '32',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 15,
                                    fontFamily: AppFonts.segoeui,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Posts',
                                  style: TextStyle(
                                    color: const Color(0xff5a5a5a),
                                    fontSize: 13,
                                    fontFamily: AppFonts.segoeui,
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
                            fontFamily: AppFonts.segoeui,
                            fontSize: 11,
                            color: const Color(0xff5a5a5a),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: 2.0.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ALL',
                                    style: TextStyle(
                                      fontFamily: AppFonts.segoeui,
                                      fontSize: 9.0.sp,
                                      fontWeight: FontWeight.w600,
                                      color: selectedValue == 0
                                          ? primaryColor
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Container(
                                    width: 1,
                                    height: 2.0.h,
                                    color: Colors.grey[500],
                                  ),
                                  Text(
                                    'ROOYA',
                                    style: TextStyle(
                                      fontFamily: AppFonts.segoeui,
                                      fontSize: 9.0.sp,
                                      fontWeight: FontWeight.w600,
                                      color: selectedValue == 1
                                          ? primaryColor
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Container(
                                    width: 1,
                                    height: 2.0.h,
                                    color: Colors.grey[500],
                                  ),
                                  Text(
                                    'STORY',
                                    style: TextStyle(
                                      fontFamily: AppFonts.segoeui,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9.0.sp,
                                      color: selectedValue == 2
                                          ? primaryColor
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Container(
                                    width: 1,
                                    height: 2.0.h,
                                    color: Colors.grey[500],
                                  ),
                                  Text(
                                    'MY EVENTS',
                                    style: TextStyle(
                                      fontFamily: AppFonts.segoeui,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9.0.sp,
                                      color: selectedValue == 3
                                          ? primaryColor
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Container(
                                    width: 1,
                                    height: 2.0.h,
                                    color: Colors.grey[500],
                                  ),
                                  Text(
                                    'ROOYA SOUQ',
                                    style: TextStyle(
                                      fontFamily: AppFonts.segoeui,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9.0.sp,
                                      color: selectedValue == 4
                                          ? primaryColor
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
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
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 29.0.h,
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: profileInfoModel!.userCover == null
                                    ? 'https://thumbs.dreamstime.com/b/nature-web-banner-concept-design-vector-illustration-theme-ecology-environment-natural-products-natural-healthy-life-94337908.jpg'
                                    : '$baseImageUrl${profileInfoModel!.userCover}',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 25.0.h,
                                  width: 100.0.w,
                                  decoration: BoxDecoration(
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
                                          fontFamily: AppFonts.segoeui,
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
                                placeholder: (context, url) => ShimerEffect(
                                  child: Container(
                                    height: 15.0.h,
                                    width: 100.0.w,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.0.w, vertical: 1.0.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(0.8.h),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 1.0.w),
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
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 1.0.w),
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
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 1.0.w),
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
                                child: Container(
                                  margin: EdgeInsets.only(left: width * 0.090),
                                  child: CircularProfileAvatar(
                                    profileInfoModel!.userPicture == null
                                        ? 'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm'
                                        : '$baseImageUrl${profileInfoModel!.userPicture!}',
                                    radius: 35,
                                    borderColor: primaryColor,
                                    elevation: 10,
                                    borderWidth: 1,
                                  ),
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
                                  fontFamily: AppFonts.segoeui,
                                  fontSize: 12,
                                  color: const Color(0xff0bab0d),
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '${profileInfoModel!.totalFollowings}\n',
                                    style: TextStyle(
                                      fontFamily: AppFonts.segoeui,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Following',
                                    style: TextStyle(
                                      fontFamily: AppFonts.segoeui,
                                      color: const Color(0xff5a5a5a),
                                      fontSize: 13,
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
                                  fontFamily: AppFonts.segoeui,
                                  fontSize: 12,
                                  color: const Color(0xff0bab0d),
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '${profileInfoModel!.totalFollowers}\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      fontFamily: AppFonts.segoeui,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Followers',
                                    style: TextStyle(
                                      color: const Color(0xff5a5a5a),
                                      fontSize: 13,
                                      fontFamily: AppFonts.segoeui,
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
                                  color: const Color(0xff5a5a5a),
                                  fontSize: 12,
                                  fontFamily: AppFonts.segoeui,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${profileInfoModel!.totalPosts}\n',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 15,
                                      fontFamily: AppFonts.segoeui,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Posts',
                                    style: TextStyle(
                                      color: const Color(0xff5a5a5a),
                                      fontSize: 13,
                                      fontFamily: AppFonts.segoeui,
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
                              fontFamily: AppFonts.segoeui,
                              fontSize: 11,
                              color: const Color(0xff5a5a5a),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedValue = 0;
                                        });
                                      },
                                      child: Text(
                                        'ALL',
                                        style: TextStyle(
                                          fontFamily: AppFonts.segoeui,
                                          fontSize: 9.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: selectedValue == 0
                                              ? primaryColor
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 2.0.h,
                                      color: Colors.grey[500],
                                    ),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedValue = 1;
                                          });
                                        },
                                        child: Text(
                                          'ROOYA',
                                          style: TextStyle(
                                            fontFamily: AppFonts.segoeui,
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
                                            fontFamily: AppFonts.segoeui,
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
                                            fontFamily: AppFonts.segoeui,
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
                                            fontFamily: AppFonts.segoeui,
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
                                      height: 5.5.h,
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
                                            fontFamily: AppFonts.segoeui,
                                            fontSize: 10.0.sp,
                                            color: const Color(0xff1e1e1e),
                                          ),
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            isDense: true,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                                left: 15, right: 15),
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
                              : selectedValue == 1
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 5.5.h,
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
                                                fontFamily: AppFonts.segoeui,
                                                fontSize: 10.0.sp,
                                                color: const Color(0xff1e1e1e),
                                              ),
                                              decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                isDense: true,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: 15, right: 15),
                                                hintText: 'Search here...',
                                                hintStyle: TextStyle(
                                                  fontFamily: AppFonts.segoeui,
                                                  fontSize: 9.0.sp,
                                                  color:
                                                      const Color(0xff1e1e1e),
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
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return index == 0
                                                ? InkWell(
                                                    onTap: () {
                                                      selectLocation();
                                                    },
                                                    child: Container(
                                                      height: 18.0.h,
                                                      width: 25.0.w,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  0.8.h),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Center(
                                                          child: Icon(
                                                        Icons.add_circle,
                                                        color: primaryColor,
                                                        size: 4.0.h,
                                                      )),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      if (userStoryModel!
                                                              .items![index]
                                                              .type ==
                                                          'photo') {}
                                                      Get.to(ViewStory(
                                                        picUrl:
                                                            '$baseImageUrl${userStoryModel!.items![index].src}',
                                                        src: userStoryModel!
                                                            .items![index]
                                                            .type!,
                                                      ));
                                                    },
                                                    child: Container(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: userStoryModel!
                                                                    .items![
                                                                        index]
                                                                    .type ==
                                                                'photo'
                                                            ? CachedNetworkImage(
                                                                imageUrl:
                                                                    '$baseImageUrl${userStoryModel!.items![index].src}',
                                                                fit: BoxFit
                                                                    .cover,
                                                                progressIndicatorBuilder:
                                                                    (context,
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
                                                                    Image.asset(
                                                                  'assets/images/home_banner.png',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              )
                                                            : Container(
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .play_circle_fill,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                      ),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  0.8.h),
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
                                                          crossAxisSpacing:
                                                              2.0.w,
                                                          mainAxisSpacing:
                                                              2.0.w,
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
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'OM Chanting @Breathe Yoga Studio',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Segoe UI',
                                                                  fontSize:
                                                                      8.0.sp,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Wed, 23 Dec 2020, 8:00 pm',
                                                                style:
                                                                    TextStyle(
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Flexible(
                                                      child: GridView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            mRooyaSouqList
                                                                .length,
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisSpacing:
                                                                    5.0.w,
                                                                mainAxisSpacing:
                                                                    2.0.w,
                                                                crossAxisCount:
                                                                    2),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
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
                                                                  height:
                                                                      15.0.h,
                                                                  width:
                                                                      100.0.w,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          image:
                                                                              NetworkImage('$baseImageUrl${mRooyaSouqList[index].images![0].attachment}'))),
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
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                              'AED ${mRooyaSouqList[index].price}',
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(color: const Color(0xff0bab0d), fontWeight: FontWeight.w600, fontSize: 8.0.sp)),
                                                                          Icon(
                                                                            Icons.favorite,
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
                                                                          color:
                                                                              const Color(0xff5a5a5a),
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  )
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
        Uri.parse('${baseUrl}getRooyaProfilePosts${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode(
            {"page_size": 100, "page_number": 1, "user_id": widget.userID}));

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
    final response = await http.post(
        Uri.parse('${baseUrl}getProfileSouqProducts${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode(
            {"user_id": widget.userID, "page_size": 100, "page_number": 1}));

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
    final response = await http.post(Uri.parse('${baseUrl}getStories${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"user_id": widget.userID}));
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
    final response = await http.post(
        Uri.parse('${baseUrl}getProfileInfo${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode(
            {"profile_id": widget.userID, "user_id": widget.userID}));

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

  selectLocation() {
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
                        getStories();
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
                        getStories();
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
}
