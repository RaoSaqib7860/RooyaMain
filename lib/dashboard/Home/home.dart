import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rooya_app/ApiUtils/AuthUtils.dart';
import 'package:rooya_app/Screens/Reel/ReelCamera/ReelCamera.dart';
import 'package:rooya_app/create_all.dart';
import 'package:rooya_app/dashboard/Home/HomeController/HomeController.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import 'package:rooya_app/dashboard/profile.dart';
import 'package:rooya_app/rooya_post/CreatePost/create_post.dart';
import 'package:rooya_app/rooya_post/Story/CreateStory.dart';
import 'package:rooya_app/story/create_story.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/dashboard/Home/HomeComponents/user_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../SharePost.dart';
import 'HomeComponents/StoryViews.dart';
import 'package:timeago/timeago.dart' as timeago;

ScrollController scrollController = ScrollController();
String fromHomeStory = '0';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  List<RooyaPostModel> mRooyaPostsList = [];
  final controller = Get.put(HomeController());
  var searchText = ''.obs;

  @override
  void initState() {
    AuthUtils.getAllStoriesAPI(controller: controller);
    AuthUtils.getgetHomeBanner(controller: controller);
    AuthUtils.getgetRooyaPostByLimite(controller: controller);
    debounce(searchText, (value) {
      print('Search value is =$value');
      if (value.toString().isEmpty) {
        controller.listofSearch.value = [];
        setState(() {});
      } else {
        AuthUtils.getgetRooyaSearchPostByLimite(
            controller: controller, word: value.toString());
      }
    }, time: Duration(milliseconds: 600));
    super.initState();
  }

  Future<void> _pullRefresh() async {
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  SharedPreferences? prefs;

  GetStorage storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await AuthUtils.getgetRooyaPostByLimite(controller: controller);
          AuthUtils.getAllStoriesAPI(controller: controller);
        },
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 1.0.h, vertical: 1.30.h),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      SharedPreferences? prefs =
                          await SharedPreferences.getInstance();
                      String? userId = await prefs.getString('user_id');
                      Get.to(Profile(
                        userID: userId,
                      ));
                    },
                    child: storage.read('user_picture') == null ||
                            storage.read('user_picture') == ''
                        ? CircularProfileAvatar(
                            '',
                            child: Image.asset('assets/images/logo.png'),
                            radius: 15,
                            borderColor: primaryColor,
                            borderWidth: 1,
                          )
                        : CircularProfileAvatar(
                            '$baseImageUrl${storage.read('user_picture')}',
                            radius: 15,
                            borderColor: primaryColor,
                            borderWidth: 1,
                          ),
                  ),
                  Expanded(
                    child: Container(
                      height: 4.50.h,
                      margin: EdgeInsets.symmetric(horizontal: 2.0.w),
                      padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25)),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        onChanged: (v) {
                          searchText.value = v;
                        },
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Search here...',
                          hintStyle: TextStyle(
                            fontFamily: AppFonts.segoeui,
                            fontSize: 11.0.sp,
                            color: const Color(0xff5a5a5a),
                          ),
                        ),
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
              child: Obx(
                () => CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
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
                                    autoPlay: false,
                                    autoPlayInterval: Duration(seconds: 5),
                                    autoPlayAnimationDuration:
                                        Duration(seconds: 4),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                  )),
                        ),
                        decoration: BoxDecoration(color: Colors.black),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: SizedBox(
                      height: 1.0.h,
                    )),
                    SliverToBoxAdapter(
                      child: Obx(
                        () => Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    controller.isForyou.value = true;
                                    AuthUtils.getgetRooyaPostByLimite(
                                        controller: controller);
                                  },
                                  child: Center(
                                      child: Text(
                                    'For you',
                                    style: TextStyle(
                                      fontFamily: AppFonts.segoeui,
                                      fontSize: 14,
                                      color: controller.isForyou.value
                                          ? primaryColor
                                          : Colors.black38,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                                )),
                            Container(
                              height: 3.50.h,
                              width: 1,
                              color: Colors.grey,
                            ),
                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    controller.isForyou.value = false;
                                    AuthUtils.getRooyaPostByFollowing(
                                        controller: controller);
                                  },
                                  child: Center(
                                      child: Text(
                                    'Following',
                                    style: TextStyle(
                                      fontFamily: AppFonts.segoeui,
                                      fontSize: 14,
                                      color: !controller.isForyou.value
                                          ? primaryColor
                                          : Colors.black38,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                                )),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.030),
                      sliver: SliverToBoxAdapter(
                        child: Column(
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
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 0.5.h),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey[100]!
                                            .withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onTap: () {
                                      // Get.to(CreatePostStrory())!.then((value) {
                                      //   AuthUtils.getAllStoriesAPI(
                                      //       controller: controller);
                                      // });
                                      fromHomeStory = '0';
                                      Get.to(CameraApp(
                                        fromStory: true,
                                      ))!
                                          .then((value) {
                                        fromHomeStory = '0';
                                        AuthUtils.getAllStoriesAPI(
                                            controller: controller);
                                      });
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
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    0.5.h),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            image: DecorationImage(
                                                                fit:
                                                                    BoxFit.fill,
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
                                                  itemBuilder:
                                                      (context, index) {
                                                    String type = controller
                                                        .listofStories[index]
                                                        .storyobjects![0]
                                                        .type!;
                                                    if (controller
                                                            .listofStories[
                                                                index]
                                                            .storyobjects![0]
                                                            .event_id !=
                                                        '0') {
                                                      return SizedBox();
                                                    } else {
                                                      return Stack(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Get.to(MoreStories(
                                                                storyobjects: controller
                                                                    .listofStories[
                                                                        index]
                                                                    .storyobjects,
                                                              ))!
                                                                  .then((value) {
                                                                controller
                                                                        .storyLoad
                                                                        .value =
                                                                    false;
                                                                AuthUtils.getAllStoriesAPI(
                                                                    controller:
                                                                        controller);
                                                              });
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
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/home_banner.png',
                                                                            fit:
                                                                                BoxFit.cover,
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
                                                                    : Center(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .play_circle_fill,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              30,
                                                                        ),
                                                                      ),
                                                              ),
                                                              width: 20.0.w,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          0.5.h),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8)),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8,
                                                                    top: 5),
                                                            width: 20.0.w,
                                                            child: Row(
                                                              children: [
                                                                CircularProfileAvatar(
                                                                  '',
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: controller.listofStories[index].storyobjects![0].userPicture ==
                                                                            null
                                                                        ? 'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm'
                                                                        : "$baseImageUrl${controller.listofStories[index].storyobjects![0].userPicture}",
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
                                                                  borderColor:
                                                                      primaryColor,
                                                                  elevation: 5,
                                                                  borderWidth:
                                                                      1,
                                                                  radius: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    '${controller.listofStories[index].storyobjects![0].userName}',
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            8),
                                                                  ),
                                                                )
                                                              ],
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
                            // SizedBox(
                            //   height: 3.0.h,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(
                            //       'Rooya',
                            //       style: TextStyle(
                            //         fontFamily: AppFonts.segoeui,
                            //         fontSize: 16,
                            //         color: Color(0xff000000),
                            //         fontWeight: FontWeight.w700,
                            //       ),
                            //       textAlign: TextAlign.left,
                            //     ),
                            //     InkWell(
                            //       onTap: () {
                            //         Get.to(CreatePost())!.then((value) {
                            //           AuthUtils.getgetRooyaPostByLimite(
                            //               controller: controller);
                            //         });
                            //       },
                            //       child: Container(
                            //         padding: EdgeInsets.all(1.0.h),
                            //         decoration: BoxDecoration(
                            //             border: Border.all(
                            //                 color: Color(0xff0bab0d)),
                            //             borderRadius: BorderRadius.circular(5)),
                            //         child: Text('Add Rooya',
                            //             style: TextStyle(
                            //               fontFamily: AppFonts.segoeui,
                            //               fontSize: 12,
                            //               color: const Color(0xff0bab0d),
                            //               fontWeight: FontWeight.w700,
                            //             )),
                            //       ),
                            //     )
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.030),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 1.0.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Event Stories',
                                  style: TextStyle(
                                    fontFamily: AppFonts.segoeui,
                                    fontSize: 16,
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
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
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    0.5.h),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            image: DecorationImage(
                                                                fit:
                                                                    BoxFit.fill,
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
                                                  itemBuilder:
                                                      (context, index) {
                                                    String type = controller
                                                        .listofStories[index]
                                                        .storyobjects![0]
                                                        .type!;
                                                    if (controller
                                                            .listofStories[
                                                                index]
                                                            .storyobjects![0]
                                                            .event_id ==
                                                        '0') {
                                                      return SizedBox();
                                                    } else {
                                                      return Stack(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Get.to(MoreStories(
                                                                storyobjects: controller
                                                                    .listofStories[
                                                                        index]
                                                                    .storyobjects,
                                                              ))!
                                                                  .then((value) {
                                                                controller
                                                                        .storyLoad
                                                                        .value =
                                                                    false;
                                                                AuthUtils.getAllStoriesAPI(
                                                                    controller:
                                                                        controller);
                                                              });
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
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/home_banner.png',
                                                                            fit:
                                                                                BoxFit.cover,
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
                                                                    : Center(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .play_circle_fill,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              30,
                                                                        ),
                                                                      ),
                                                              ),
                                                              width: 20.0.w,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          0.5.h),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8)),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8,
                                                                    top: 5),
                                                            width: 20.0.w,
                                                            child: Row(
                                                              children: [
                                                                CircularProfileAvatar(
                                                                  '',
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: controller.listofStories[index].storyobjects![0].userPicture ==
                                                                            null
                                                                        ? 'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm'
                                                                        : "$baseImageUrl${controller.listofStories[index].storyobjects![0].userPicture}",
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
                                                                  borderColor:
                                                                      primaryColor,
                                                                  elevation: 5,
                                                                  borderWidth:
                                                                      1,
                                                                  radius: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    '${controller.listofStories[index].storyobjects![0].userName}',
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            8),
                                                                  ),
                                                                )
                                                              ],
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
                                    Get.to(CreatePost())!.then((value) {
                                      AuthUtils.getgetRooyaPostByLimite(
                                          controller: controller);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(1.0.h),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xff0bab0d)),
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
                          ],
                        ),
                      ),
                    ),
                    !controller.storyLoad.value
                        ? SliverToBoxAdapter(
                            child: Container(
                              height: 300,
                              width: width,
                              child: Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            ),
                          )
                        : controller.listofSearch.isNotEmpty
                            ? SliverPadding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.030),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return UserPost(
                                        rooyaPostModel:
                                            controller.listofSearch[index],
                                        onPostLike: () {
                                          setState(() {
                                            controller.listofSearch[index]
                                                .islike = true;
                                            controller.listofSearch[index]
                                                .likecount = controller
                                                    .listofSearch[index]
                                                    .likecount! +
                                                1;
                                          });
                                        },
                                        onPostUnLike: () {
                                          setState(() {
                                            controller.listofSearch[index]
                                                .islike = false;
                                            controller.listofSearch[index]
                                                .likecount = controller
                                                    .listofSearch[index]
                                                    .likecount! -
                                                1;
                                          });
                                        },
                                        comment: () {
                                          AuthUtils
                                              .getgetRooyaSearchPostByLimite(
                                                  controller: controller,
                                                  word: searchText.value
                                                      .toString());
                                        },
                                      );
                                    },
                                    childCount: controller.listofSearch.length,
                                  ),
                                ),
                              )
                            : SliverPadding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.030),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (controller
                                              .listofpost[index].origin_id !=
                                          '0') {
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                controller.listofpost[index]
                                                            .userPicture ==
                                                        null
                                                    ? CircularProfileAvatar(
                                                        '',
                                                        child: Image.asset(
                                                            'assets/images/logo.png'),
                                                        elevation: 5,
                                                        radius: 23,
                                                        onTap: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (c) =>
                                                                      Profile(
                                                                        userID:
                                                                            '${controller.listofpost[index].userPosted}',
                                                                      )));
                                                        },
                                                        borderColor:
                                                            primaryColor,
                                                        borderWidth: 1,
                                                      )
                                                    : CircularProfileAvatar(
                                                        '$baseImageUrl${controller.listofpost[index].userPicture}',
                                                        elevation: 5,
                                                        radius: 23,
                                                        onTap: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (c) =>
                                                                      Profile(
                                                                        userID:
                                                                            '${controller.listofpost[index].userPosted}',
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
                                                    print('Click on profile');
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (c) =>
                                                                Profile(
                                                                  userID:
                                                                      '${controller.listofpost[index].userPosted}',
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
                                                              '${controller.listofpost[index].userfullname} ',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppFonts
                                                                        .segoeui,
                                                                fontSize: 13,
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
                                                                  ' Shared a ${controller.listofpost[index].pre_user_name} post',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppFonts
                                                                            .segoeui,
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .black38,
                                                                  )),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        '@${controller.listofpost[index].userName}',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              AppFonts.segoeui,
                                                          fontSize: 10,
                                                          color: const Color(
                                                              0xff000000),
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      )
                                                    ],
                                                  ),
                                                )),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Text(
                                                    '${timeago.format(DateTime.parse(controller.listofpost[index].time!), locale: 'en_short')} ago',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.segoeui,
                                                      fontSize: 10,
                                                      color: const Color(
                                                          0xff000000),
                                                      height: 1.8,
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 1.0.h,
                                            ),
                                            SharePost(
                                              rooyaPostModel:
                                                  controller.listofpost[index],
                                              onPostLike: () {
                                                setState(() {
                                                  controller.listofpost[index]
                                                      .islike = true;
                                                  controller.listofpost[index]
                                                      .likecount = controller
                                                          .listofpost[index]
                                                          .likecount! +
                                                      1;
                                                });
                                              },
                                              onPostUnLike: () {
                                                setState(() {
                                                  controller.listofpost[index]
                                                      .islike = false;
                                                  controller.listofpost[index]
                                                      .likecount = controller
                                                          .listofpost[index]
                                                          .likecount! -
                                                      1;
                                                });
                                              },
                                              comment: () {
                                                AuthUtils
                                                    .getgetRooyaPostByLimite(
                                                        controller: controller);
                                              },
                                            ),
                                            SizedBox(
                                              height: height * 0.020,
                                            )
                                          ],
                                        );
                                      } else {
                                        return UserPost(
                                          rooyaPostModel:
                                              controller.listofpost[index],
                                          onPostLike: () {
                                            setState(() {
                                              controller.listofpost[index]
                                                  .islike = true;
                                              controller.listofpost[index]
                                                  .likecount = controller
                                                      .listofpost[index]
                                                      .likecount! +
                                                  1;
                                            });
                                          },
                                          onPostUnLike: () {
                                            setState(() {
                                              controller.listofpost[index]
                                                  .islike = false;
                                              controller.listofpost[index]
                                                  .likecount = controller
                                                      .listofpost[index]
                                                      .likecount! -
                                                  1;
                                            });
                                          },
                                          comment: () {
                                            AuthUtils.getgetRooyaPostByLimite(
                                                controller: controller);
                                          },
                                        );
                                      }
                                    },
                                    childCount: controller.listofpost.length,
                                  ),
                                ),
                              ),
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
