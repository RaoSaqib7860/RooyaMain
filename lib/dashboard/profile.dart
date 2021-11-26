import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rooya_app/Screens/Reel/ReelCamera/ReelCamera.dart';
import 'package:rooya_app/Screens/Settings/Settings.dart';
import 'package:rooya_app/events/CreateNewEvent/CreateNewEvent.dart';
import 'package:rooya_app/events/Models/UpCommingEventModel.dart';
import 'package:rooya_app/events/event_detail.dart';
import 'package:rooya_app/models/ProfileInfoModel.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import 'package:rooya_app/models/RooyaSouqModel.dart';
import 'package:rooya_app/models/UserStoryModel.dart';
import 'package:rooya_app/rooya_souq/create_souq.dart';
import 'package:rooya_app/rooya_souq/rooya_ad_display.dart';
import 'package:rooya_app/story/create_story.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/SnackbarCustom.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/dashboard/Home/HomeComponents/user_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../Screens/ProfileData/AllFolowFolowers.dart';
import '../SharePost.dart';
import '../view_pic.dart';
import '../view_story.dart';
import 'Home/home.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  List<UpComingEventsModel> listofUpcommingEvents = [];
  ProfileInfoModel? profileInfoModel;
  UserStoryModel? userStoryModel;
  List<Items>? listofStoryItem;
  String? userID = '';
  String displayName = '';
  int selectedValue = 0;
  bool isFOlow = false;
  String folowStatus = '4';

  Future<bool> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_firstname = await prefs.getString('user_firstname');
    String? user_lastname = await prefs.getString('user_lastname');
    displayName = user_firstname! + ' ' + user_lastname!;
    userID = await prefs.getString('user_id');
    print('user id = ${widget.userID} and $userID');
    setState(() {});
    return true;
  }

  //https://apis.rooya.com/Alphaapis/getRooyaMyEventByLimite?code=ROOYA-5574499
  Future<void> createEvent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}getRooyaMyEventByLimite$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "page_size": 100,
          "page_number": 0,
          "profile_id": widget.userID,
          "user_id": userId,
        }));
    print('response is = ${response.body}');
    var data = jsonDecode(response.body);
    listofUpcommingEvents = List<UpComingEventsModel>.from(
        data['data'].map((model) => UpComingEventsModel.fromJson(model)));
    setState(() {});
  }

  GetStorage storage = GetStorage();

  @override
  void initState() {
    print('widget.userID = ${widget.userID}');
    getProfile();
    getProfileInfo();
    getRooyaPost();
    getRooyaSouqbyLimit();
    getStories();
    createEvent();
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
                              InkWell(
                                child: CachedNetworkImage(
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
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.0.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${profileInfoModel!.userFirstname} ${profileInfoModel!.userLastname}',
                                              style: TextStyle(
                                                fontFamily: AppFonts.segoeui,
                                                fontSize: 16.0.sp,
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w600,
                                                shadows: [
                                                  Shadow(
                                                    color:
                                                        const Color(0x47000000),
                                                    offset: Offset(0, 3),
                                                    blurRadius: 6,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.020,
                                            ),
                                            profileInfoModel!.user_verified ==
                                                    '1'
                                                ? Container(
                                                    padding: EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        shape: BoxShape.circle),
                                                    child: Icon(
                                                      Icons.check,
                                                      size: 12,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : SizedBox()
                                          ],
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
                                onTap: () {
                                  if (profileInfoModel!.userCover != null) {
                                    Attachment atachments = Attachment(
                                        attachment:
                                            '${profileInfoModel!.userCover}',
                                        photoId: 1,
                                        type: 'abc');
                                    Get.to(ViewPic(
                                      attachment: [atachments],
                                    ));
                                  } else {
                                    Attachment atachments = Attachment(
                                        attachment:
                                            'https://thumbs.dreamstime.com/b/nature-web-banner-concept-design-vector-illustration-theme-ecology-environment-natural-products-natural-healthy-life-94337908.jpg',
                                        photoId: 1,
                                        type: '');
                                    Get.to(ViewPic(
                                      attachment: [atachments],
                                    ));
                                  }
                                },
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
                                  child: profileInfoModel!.userPicture == null
                                      ? CircularProfileAvatar(
                                          '',
                                          child: Image.asset(
                                              'assets/images/logo.png'),
                                          radius: 35,
                                          borderColor: primaryColor,
                                          elevation: 10,
                                          borderWidth: 1,
                                        )
                                      : CircularProfileAvatar(
                                          '$baseImageUrl${profileInfoModel!.userPicture!}',
                                          radius: 35,
                                          borderColor: primaryColor,
                                          elevation: 10,
                                          onTap: () {
                                            Attachment atachments = Attachment(
                                                attachment:
                                                    '${profileInfoModel!.userPicture!}',
                                                photoId: 1,
                                                type: 'abc');
                                            Get.to(ViewPic(
                                              attachment: [atachments],
                                            ));
                                          },
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
                            InkWell(
                              onTap: () async {
                                if (widget.userID == storage.read('userID')) {
                                  Get.to(AllFolowFolowers(
                                    folowers: false,
                                    owner: true,
                                    userID: widget.userID,
                                    userName:
                                        '${profileInfoModel!.userFirstname} ${profileInfoModel!.userLastname}',
                                  ))!
                                      .then((value) {
                                    getProfileInfo(load: false);
                                  });
                                } else {
                                  if (profileInfoModel!.private_account !=
                                      '1') {
                                    Get.to(AllFolowFolowers(
                                      folowers: false,
                                      userID: widget.userID,
                                      userName:
                                          '${profileInfoModel!.userFirstname} ${profileInfoModel!.userLastname}',
                                    ))!
                                        .then((value) {
                                      getProfileInfo(load: false);
                                    });
                                  }
                                }
                              },
                              child: Text.rich(
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
                            ),
                            SizedBox(
                              width: 4.0.w,
                            ),
                            InkWell(
                              onTap: () async {
                                if (widget.userID == storage.read('userID')) {
                                  Get.to(AllFolowFolowers(
                                    folowers: true,
                                    userID: widget.userID,
                                    owner: true,
                                    userName:
                                        '${profileInfoModel!.userFirstname} ${profileInfoModel!.userLastname}',
                                  ))!
                                      .then((value) {
                                    getProfileInfo(load: false);
                                  });
                                } else {
                                  if (profileInfoModel!.private_account !=
                                      '1') {
                                    Get.to(AllFolowFolowers(
                                      folowers: true,
                                      userID: widget.userID,
                                      userName:
                                          '${profileInfoModel!.userFirstname} ${profileInfoModel!.userLastname}',
                                    ))!
                                        .then((value) {
                                      getProfileInfo(load: false);
                                    });
                                  }
                                }
                              },
                              child: Text.rich(
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
                            ),
                            SizedBox(
                              width: width * 0.030,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Container(
                                height: height * 0.045,
                                width: width * 0.2,
                                margin: EdgeInsets.only(
                                  right: width * 0.030,
                                ),
                                child: userID != widget.userID
                                    ? Center(
                                        child: Text(
                                          'MESSAGE',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: AppFonts.segoeui),
                                        ),
                                      )
                                    : SizedBox(),
                                decoration: BoxDecoration(
                                    color: userID != widget.userID
                                        ? greenColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                            SizedBox(
                              width: 2.0.w,
                            ),
                            profileInfoModel!.already_requested == 'true'
                                ? Container(
                                    height: height * 0.045,
                                    width: width * 0.2,
                                    child: userID != widget.userID
                                        ? Center(
                                            child: Text(
                                              'REQUESTED',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontFamily: AppFonts.segoeui),
                                            ),
                                          )
                                        : SizedBox(),
                                    decoration: BoxDecoration(
                                        color: userID != widget.userID
                                            ? greenColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                  )
                                : InkWell(
                                    onTap: () async {
                                      if (profileInfoModel!.isFollow!) {
                                        print('unFolow Call');
                                        await unfolow();
                                        getProfileInfo(load: false);
                                        getRooyaPost();
                                        getStories();
                                        getRooyaSouqbyLimit();
                                        createEvent();
                                      } else {
                                        print('Folow Call');
                                        if (profileInfoModel!.private_account ==
                                                '0' ||
                                            profileInfoModel!.private_account!
                                                    .trim() ==
                                                '') {
                                          await folow();
                                          getProfileInfo(load: false);
                                          getRooyaPost();
                                          getStories();
                                          getRooyaSouqbyLimit();
                                          createEvent();
                                        } else {
                                          await allowfollowers();
                                          getProfileInfo(load: false);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: height * 0.045,
                                      width: width * 0.2,
                                      child: userID != widget.userID
                                          ? Center(
                                              child: Text(
                                                !profileInfoModel!.isFollow!
                                                    ? 'FOLLOW'
                                                    : profileInfoModel!
                                                                    .private_account ==
                                                                '0' ||
                                                            profileInfoModel!
                                                                    .private_account!
                                                                    .trim() ==
                                                                ''
                                                        ? 'UNFOLLOW'
                                                        : profileInfoModel!
                                                                    .already_requested ==
                                                                'false'
                                                            ? 'UNFOLLOW'
                                                            : 'REQUESTED',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        AppFonts.segoeui),
                                              ),
                                            )
                                          : SizedBox(),
                                      decoration: BoxDecoration(
                                          color: userID != widget.userID
                                              ? greenColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                  ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 2.0.h,
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                        //   child: Text(
                        //     //'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.',
                        //   '',
                        //     style: TextStyle(
                        //       fontFamily: AppFonts.segoeui,
                        //       fontSize: 11,
                        //       color: const Color(0xff5a5a5a),
                        //     ),
                        //     textAlign: TextAlign.left,
                        //   ),
                        // ),
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
                                            if (mRooyaPostsList[index]
                                                    .origin_id !=
                                                '0') {
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      mRooyaPostsList[index]
                                                                  .userPicture ==
                                                              null
                                                          ? CircularProfileAvatar(
                                                              '',
                                                              child: Image.asset(
                                                                  'assets/images/logo.png'),
                                                              elevation: 5,
                                                              radius: 23,
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder: (c) => Profile(
                                                                              userID: '${mRooyaPostsList[index].userPosted}',
                                                                            )));
                                                              },
                                                              borderColor:
                                                                  primaryColor,
                                                              borderWidth: 1,
                                                            )
                                                          : CircularProfileAvatar(
                                                              '$baseImageUrl${mRooyaPostsList[index].userPicture}',
                                                              elevation: 5,
                                                              radius: 23,
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder: (c) => Profile(
                                                                              userID: '${mRooyaPostsList[index].userPosted}',
                                                                            )));
                                                              },
                                                              borderColor:
                                                                  primaryColor,
                                                              borderWidth: 1,
                                                            ),
                                                      SizedBox(
                                                        width: 4.0.w,
                                                      ),
                                                      Expanded(
                                                          child: InkWell(
                                                        onTap: () {
                                                          print(
                                                              'Click on profile');
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (c) =>
                                                                      Profile(
                                                                        userID:
                                                                            '${mRooyaPostsList[index].userPosted}',
                                                                      )));
                                                        },
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    '${mRooyaPostsList[index].userfullname}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          AppFonts
                                                                              .segoeui,
                                                                      fontSize:
                                                                          13,
                                                                      color: const Color(
                                                                          0xff000000),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    )),
                                                                Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                        ' Shared a ${mRooyaPostsList[index].pre_user_name} post',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              AppFonts.segoeui,
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.black38,
                                                                        )),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              '@${mRooyaPostsList[index].userName}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppFonts
                                                                        .segoeui,
                                                                fontSize: 10,
                                                                color: const Color(
                                                                    0xff000000),
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        child: Text(
                                                          '${timeago.format(DateTime.parse(mRooyaPostsList[index].time!), locale: 'en_short')} ago',
                                                          style: TextStyle(
                                                            fontFamily: AppFonts
                                                                .segoeui,
                                                            fontSize: 10,
                                                            color: const Color(
                                                                0xff000000),
                                                            height: 1.8,
                                                          ),
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 1.0.h,
                                                  ),
                                                  SharePost(
                                                    rooyaPostModel:
                                                        mRooyaPostsList[index],
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.020,
                                                  )
                                                ],
                                              );
                                            } else {
                                              return UserPost(
                                                rooyaPostModel:
                                                    mRooyaPostsList[index],
                                              );
                                            }
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
                                      ? Column(
                                          children: [
                                            userID == widget.userID
                                                ? InkWell(
                                                    onTap: () {
                                                      fromHomeStory = '0';
                                                      Get.to(CameraApp(
                                                        fromStory: true,
                                                      ))!
                                                          .then((value) {
                                                        fromHomeStory = '0';
                                                        getStories();
                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.add_circle,
                                                          color: primaryColor,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          'ADD STORY',
                                                          style: TextStyle(
                                                            fontFamily: AppFonts
                                                                .segoeui,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 9.0.sp,
                                                            color:
                                                                selectedValue ==
                                                                        4
                                                                    ? primaryColor
                                                                    : Colors
                                                                        .black,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
                                            SizedBox(
                                              height: height * 0.010,
                                            ),
                                            GridView.builder(
                                              shrinkWrap: true,
                                              physics: BouncingScrollPhysics(),
                                              itemCount: userStoryModel == null
                                                  ? 0
                                                  : userStoryModel!
                                                      .items!.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      childAspectRatio: 0.8,
                                                      // crossAxisSpacing: 5.0.w,
                                                      mainAxisSpacing: 2.0.w,
                                                      crossAxisCount: 4),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Stack(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Get.to(ViewStory(
                                                          model: userStoryModel,
                                                          index: index,
                                                        ))!
                                                            .then((value) {
                                                          if (value is int) {
                                                            userStoryModel!
                                                                .items!
                                                                .removeAt(
                                                                    value);
                                                            setState(() {});
                                                          }
                                                        });
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
                                                                  width: double
                                                                      .infinity,
                                                                  height: double
                                                                      .infinity,
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
                                                              : Container(
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .play_circle_fill,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                        ),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    0.8.h),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8, top: 5),
                                                      width: 20.0.w,
                                                      child: Row(
                                                        children: [
                                                          CircularProfileAvatar(
                                                            '',
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: userStoryModel!
                                                                          .userPicture ==
                                                                      null
                                                                  ? 'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm'
                                                                  : "$baseImageUrl${userStoryModel!.userPicture}",
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
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              '${userStoryModel!.userFirstname} ${userStoryModel!.userLastname}',
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 8),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      : selectedValue == 3
                                          ? Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                userID == widget.userID
                                                    ? InkWell(
                                                        onTap: () {
                                                          Get.to(() =>
                                                              CreateNewEvent());
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.add_circle,
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              'ROOYA EVENT',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppFonts
                                                                        .segoeui,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize:
                                                                    9.0.sp,
                                                                color: selectedValue ==
                                                                        4
                                                                    ? primaryColor
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox(),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                GridView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  itemCount:
                                                      listofUpcommingEvents
                                                              .isEmpty
                                                          ? 6
                                                          : listofUpcommingEvents
                                                              .length,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisSpacing:
                                                              3.0.w,
                                                          mainAxisSpacing:
                                                              3.0.w,
                                                          childAspectRatio: 1.8,
                                                          crossAxisCount: 2),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return listofUpcommingEvents
                                                            .isEmpty
                                                        ? ShimerEffect(
                                                            child: Container(
                                                              height: 15.0.h,
                                                              width: 100.0.w,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              Get.to(() =>
                                                                  EventDetails(
                                                                    eventId: listofUpcommingEvents[
                                                                            index]
                                                                        .eventId,
                                                                  ));
                                                            },
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  '$baseImageUrl' +
                                                                      '${listofUpcommingEvents[index].eventCover}',
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                height: 25.0.h,
                                                                width: 100.0.w,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    image: DecorationImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        image:
                                                                            imageProvider)),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        Text(
                                                                          '${listofUpcommingEvents[index].eventTitle}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                AppFonts.segoeui,
                                                                            fontSize:
                                                                                11.0.sp,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              Text(
                                                                            '${listofUpcommingEvents[index].eventDescription}',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            maxLines:
                                                                                1,
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: AppFonts.segoeui,
                                                                              fontSize: 7.0.sp,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              placeholder: (context,
                                                                      url) =>
                                                                  ShimerEffect(
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      15.0.h,
                                                                  width:
                                                                      100.0.w,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Icon(Icons
                                                                      .error),
                                                            ),
                                                          );
                                                  },
                                                ),
                                              ],
                                            )
                                          : selectedValue == 4
                                              ? Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    userID == widget.userID
                                                        ? InkWell(
                                                            onTap: () {
                                                              Get.to(() =>
                                                                  CreateSouq());
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .add_circle,
                                                                  color:
                                                                      primaryColor,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  'ROOYA SOUQ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .segoeui,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        9.0.sp,
                                                                    color: selectedValue ==
                                                                            4
                                                                        ? primaryColor
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
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
                                                                            mRooyaSouqList[index],
                                                                      ))!
                                                                  .then(
                                                                      (value) {
                                                                if (value
                                                                    is bool) {
                                                                  getRooyaSouqbyLimit();
                                                                }
                                                              });
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
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        '$baseImageUrl${mRooyaSouqList[index].images![0].attachment}',
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
                                                                  ),
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
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Icon(
                                                                            mRooyaSouqList[index].isLike!
                                                                                ? Icons.favorite
                                                                                : Icons.favorite_border,
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
                        Navigator.of(context).pop();
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
    String? userId = await prefs.getString('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}getRooyaProfilePosts${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "page_size": 100,
          "page_number": 0,
          "user_id": userId,
          "profile_id": widget.userID
        }));

    setState(() {
      isLoading = false;
    });

    print(response.request);
    print(response.statusCode);
    print('${response.body}');

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
    String? userId = await prefs.getString('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}getProfileSouqProducts${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": userId,
          "page_size": 100,
          "page_number": 0,
          "profile_id": widget.userID
        }));

    setState(() {
      isLoading = false;
    });

    print(response.request);
    print(response.statusCode);
    print('getRooyaSouqbyLimit = ${response.body}');
    log('getRooyaSouqbyLimit = ${response.body}');
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
    String? userId = await prefs.getString('user_id');
    final response = await http.post(Uri.parse('${baseUrl}getStories${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"user_id": userId, "profile_id": widget.userID}));
    setState(() {
      isLoading = false;
    });

    print(response.request);
    print(response.statusCode);
    print('getStories all data  = ${response.body}');
    log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          userStoryModel = UserStoryModel.fromJson(data['data'][0], false);
          List<UserStoryModel> storystory = List<UserStoryModel>.from(
              data['data']
                  .map((model) => UserStoryModel.fromJson(model, true)));
          for (var i in storystory) {
            userStoryModel!.items!.addAll(i.items!);
          }
        });
      } else {
        userStoryModel!.items = [];
        setState(() {});
      }
    }
  }

  Future<void> folow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}ProfileFollow$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({'following_id': widget.userID, "user_id": userId}));
    isFOlow = true;
    profileInfoModel!.isFollow = true;
    setState(() {});
    var data = jsonDecode(response.body);
    snackBarSuccess('${data['message']}');
    print(response.request);
    print(response.statusCode);
    log(response.body);
  }

//https://apis.rooya.com/Alphaapis/allowfollowers?code=ROOYA-5574499
  Future<void> allowfollowers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}allowfollowers$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({'request_sender': widget.userID, "user_id": userId}));
    isFOlow = true;
    profileInfoModel!.isFollow = true;
    setState(() {});
    var data = jsonDecode(response.body);
    snackBarSuccess('${data['message']}');
    print(response.request);
    print(response.statusCode);
    log('allowfollowers = ${response.body}');
  }

  Future<void> checkAlreadySend() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}checkAlreadySend$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"user_id": userId, "request_sender": widget.userID}));
    var data = jsonDecode(response.body);
    if (data['result'] == 'success') {
      if (data['data'][0]['allow'] == '0') {
        folowStatus = '2';
      } else if (data['data'][0]['allow'] == '1') {
        folowStatus = '1';
      }
    } else {
      folowStatus = '3';
    }
    setState(() {});
    print('checkAlreadySend data is = $data');
  }

  Future<void> unfolow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}ProfileUnFollow$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({'follow_id': widget.userID, "user_id": userId}));
    isFOlow = false;
    profileInfoModel!.isFollow = false;
    setState(() {});
    var data = jsonDecode(response.body);
    snackBarSuccess('${data['message']}');
    setState(() {});
    print(response.request);
    print(response.statusCode);
    log(response.body);
  }

  Future<void> getProfileInfo({bool? load = true}) async {
    setState(() {
      isLoadingProfile = load!;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}getProfileInfo${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"profile_id": widget.userID, "user_id": userId}));

    setState(() {
      isLoadingProfile = false;
    });

    print(response.request);
    print(response.statusCode);
    log('getProfileInfo = ${response.body}');
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
