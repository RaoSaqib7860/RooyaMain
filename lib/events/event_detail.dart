import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rooya_app/ApiUtils/AuthUtils.dart';
import 'package:rooya_app/Screens/Reel/Reel.dart';
import 'package:rooya_app/Screens/Reel/ReelCamera/ReelCamera.dart';
import 'package:rooya_app/dashboard/Home/HomeComponents/StoryViews.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import 'package:rooya_app/dashboard/Home/home.dart';
import 'package:rooya_app/dashboard/profile.dart';
import 'package:rooya_app/events/EventDetailController.dart';
import 'package:rooya_app/rooya_post/CreatePost/create_post.dart';
import 'package:rooya_app/rooya_post/Story/CreateStory.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/dashboard/Home/HomeComponents/user_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../create_all.dart';
import 'CreateNewEvent/CreateNewEvent.dart';
import 'Models/UpCommingEventModel.dart';
import 'create_event.dart';

class EventDetails extends StatefulWidget {
  final String? eventId;
  final UpComingEventsModel? Upcommingmodel;

  const EventDetails({Key? key, this.eventId, this.Upcommingmodel})
      : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool isLoading = false;
  List<RooyaPostModel> mRooyaPostsList = [];
  int selectedValue = 0;
  final controller = Get.put(EventDetailController());
  var searchText = ''.obs;
  bool showMyPost = true;
  List<UpComingEventsModel> listofUpcommingEvents = [];
  var kGooglePlex;
  GetStorage storage = GetStorage();

  @override
  void initState() {
    marker.add(Marker(
      position: LatLng(
        double.parse('${widget.Upcommingmodel!.eventLat}'),
        double.parse('${widget.Upcommingmodel!.eventLong}'),
      ),
      markerId: MarkerId('abc'),
    ));
    kGooglePlex = CameraPosition(
      target: LatLng(
        double.parse('${widget.Upcommingmodel!.eventLat}'),
        double.parse('${widget.Upcommingmodel!.eventLong}'),
      ),
      zoom: 13.4746,
    );
    AuthUtils.getAllStoriesAPIEvent(
        controller: controller, eventID: widget.eventId);
    AuthUtils.getgetRooyaEventByLimite(
        controller: controller, eventID: widget.eventId);
    debounce(searchText, (value) {
      print('Search value is =$value');
      if (value.toString().isEmpty) {
        controller.listofSearch.value = [];
        setState(() {});
      } else {
        AuthUtils.getgetRooyaEventSearchPostByLimite(
            controller: controller,
            word: value.toString(),
            event_id: widget.eventId);
      }
    }, time: Duration(milliseconds: 600));
    createEvent();
    AuthUtils.getEventBanner(controller: controller, eventID: widget.eventId);
    super.initState();
  }

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
          "profile_id": widget.Upcommingmodel!.eventAdmin,
          "user_id": userId,
        }));
    print('createEvent response is = ${response.body}');
    var data = jsonDecode(response.body);
    listofUpcommingEvents = List<UpComingEventsModel>.from(
        data['data'].map((model) => UpComingEventsModel.fromJson(model)));
    setState(() {});
  }

  ScrollController scrollController = ScrollController();
  late Set<Marker> marker = {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await AuthUtils.getgetRooyaEventByLimite(
                controller: controller, eventID: widget.eventId);
            AuthUtils.getAllStoriesAPIEvent(
                controller: controller, eventID: widget.eventId);
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
                          Get.to(() => CreateNewEvent());
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
                                ? CachedNetworkImage(
                                    imageUrl:
                                        "$baseImageUrl${widget.Upcommingmodel!.eventCover}",
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
                                  )
                                : CarouselSlider(
                                    items: controller.listofbanner.map((e) {
                                      int index =
                                          controller.listofbanner.indexOf(e);
                                      return CachedNetworkImage(
                                        imageUrl:
                                            "$baseImageUrl${controller.listofbanner.isEmpty ? widget.Upcommingmodel!.eventCover : controller.listofbanner[index].attachment}",
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
                        height: 2.0.h,
                      )),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0.w),
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
                                          'EVENT',
                                          style: TextStyle(
                                            fontFamily: AppFonts.segoeui,
                                            fontSize: 9.0.sp,
                                            fontWeight: FontWeight.w600,
                                            color: selectedValue == 0
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
                                            selectedValue = 1;
                                          });
                                        },
                                        child: Text(
                                          'LIVE',
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
                                          'BRIEF',
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
                                          'FACILITIES',
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
                                          'LOCATION AND TIME',
                                          style: TextStyle(
                                            fontFamily: AppFonts.segoeui,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 9.0.sp,
                                            color: selectedValue == 4
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
                                            selectedValue = 5;
                                          });
                                        },
                                        child: Text(
                                          'MY EVENTS',
                                          style: TextStyle(
                                            fontFamily: AppFonts.segoeui,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 9.0.sp,
                                            color: selectedValue == 5
                                                ? primaryColor
                                                : Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: selectedValue == 0
                            ? SizedBox()
                            : selectedValue == 1
                                ? Container(
                                    height: 14.0.h,
                                    width: 20.0.w,
                                    margin: EdgeInsets.symmetric(vertical: 15),
                                    child: ListView.builder(
                                      itemBuilder: (c, i) {
                                        return Container(
                                          height: 14.0.h,
                                          width: 20.0.w,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 0.5.h),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage(
                                                      'assets/images/story.png'))),
                                        );
                                      },
                                      itemCount: 5,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                  )
                                : selectedValue == 2
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.030,
                                                vertical: 5),
                                            child: Text(
                                                '${widget.Upcommingmodel!.eventDescription}'),
                                          )
                                        ],
                                      )
                                    : selectedValue == 3
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: height * 0.250,
                                                width: width,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: width * 0.030),
                                                child: ListView.builder(
                                                  itemBuilder: (c, i) {
                                                    var data = widget
                                                        .Upcommingmodel!
                                                        .eventFacility!
                                                        .toString()
                                                        .split(',')[i];
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      child: Text(
                                                        '${i + 1}. $data',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  itemCount: widget
                                                      .Upcommingmodel!
                                                      .eventFacility!
                                                      .toString()
                                                      .split(',')
                                                      .length,
                                                ),
                                              )
                                            ],
                                          )
                                        : selectedValue == 4
                                            ? Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: width * 0.060,
                                                    vertical: 10),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: height * 0.2,
                                                      width: width,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .blueGrey[50]),
                                                      child: GoogleMap(
                                                        zoomControlsEnabled:
                                                            true,
                                                        zoomGesturesEnabled:
                                                            true,
                                                        mapType: MapType.normal,
                                                        myLocationButtonEnabled:
                                                            false,
                                                        myLocationEnabled:
                                                            false,
                                                        markers: marker,
                                                        initialCameraPosition:
                                                            kGooglePlex,
                                                        // onMapCreated: (GoogleMapController c) {
                                                        //   controller.mapcontroller.complete();
                                                        // },
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 15),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              InkWell(
                                                                child:
                                                                    Container(
                                                                  height: 50,
                                                                  width: 50,
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .phone,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            color: Colors.black.withOpacity(
                                                                                0.150),
                                                                            offset: Offset(2,
                                                                                2),
                                                                            blurRadius:
                                                                                5),
                                                                        BoxShadow(
                                                                            color: Colors.black.withOpacity(
                                                                                0.150),
                                                                            offset: Offset(-2,
                                                                                -2),
                                                                            blurRadius:
                                                                                5)
                                                                      ]),
                                                                ),
                                                                onTap: () {
                                                                  launchURL(
                                                                      'tel:+${widget.Upcommingmodel!.eventContact}');
                                                                },
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Text(
                                                                'Call',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Column(
                                                            children: [
                                                              InkWell(
                                                                child:
                                                                    Container(
                                                                  height: 50,
                                                                  width: 50,
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .location_on,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            color: Colors.black.withOpacity(
                                                                                0.150),
                                                                            offset: Offset(2,
                                                                                2),
                                                                            blurRadius:
                                                                                5),
                                                                        BoxShadow(
                                                                            color: Colors.black.withOpacity(
                                                                                0.150),
                                                                            offset: Offset(-2,
                                                                                -2),
                                                                            blurRadius:
                                                                                5)
                                                                      ]),
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  print(
                                                                      '${widget.Upcommingmodel!.eventLat},${widget.Upcommingmodel!.eventLong}');
                                                                  Position?
                                                                      position =
                                                                      await Geolocator
                                                                          .getLastKnownPosition();
                                                                  launchURL(
                                                                      'https://www.google.com/maps/dir/?api=1&origin=${position!.latitude},${position.latitude}&destination=${widget.Upcommingmodel!.eventLat},${widget.Upcommingmodel!.eventLong}&travelmode=driving&dir_action=navigate');
                                                                },
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Text(
                                                                'Directions',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Column(
                                                            children: [
                                                              InkWell(
                                                                child:
                                                                    Container(
                                                                  height: 50,
                                                                  width: 50,
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .language_rounded,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            color: Colors.black.withOpacity(
                                                                                0.150),
                                                                            offset: Offset(2,
                                                                                2),
                                                                            blurRadius:
                                                                                5),
                                                                        BoxShadow(
                                                                            color: Colors.black.withOpacity(
                                                                                0.150),
                                                                            offset: Offset(-2,
                                                                                -2),
                                                                            blurRadius:
                                                                                5)
                                                                      ]),
                                                                ),
                                                                onTap: () {
                                                                  launchURL(
                                                                      '${widget.Upcommingmodel!.eventWebsite}');
                                                                },
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Text(
                                                                'Website',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                      ),
                                                    ),
                                                    Container(
                                                      height: height * 0.2,
                                                      width: width,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      '${widget.Upcommingmodel!.eventDate!.split(' ')[0].split('-')[2]}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    SizedBox(
                                                                      height: height *
                                                                          0.050,
                                                                    ),
                                                                    Text(
                                                                      '${DateFormat('MMM').format(DateTime.parse('${widget.Upcommingmodel!.eventDate}'))}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              5),
                                                                  child: Text(
                                                                    '/',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      '${widget.Upcommingmodel!.eventEndDate!.split(' ')[0].split('-')[2]}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    SizedBox(
                                                                      height: height *
                                                                          0.050,
                                                                    ),
                                                                    Text(
                                                                      '${DateFormat('MMM').format(DateTime.parse('${widget.Upcommingmodel!.eventEndDate}'))}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height:
                                                                height * 0.150,
                                                            width: 1,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                          ),
                                                          Expanded(
                                                              child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Text(
                                                                    '${DateFormat('dd').format(DateTime.parse('${widget.Upcommingmodel!.eventDate}'))}, ${DateFormat('MMM').format(DateTime.parse('${widget.Upcommingmodel!.eventDate}'))} ${DateFormat('yyyy').format(DateTime.parse('${widget.Upcommingmodel!.eventDate}'))}',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            11),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    '${DateTime.parse('${widget.Upcommingmodel!.eventDate}').difference(DateTime.parse('${widget.Upcommingmodel!.eventEndDate}')).inDays.abs()} Days Event',
                                                                    style: TextStyle(
                                                                        color:
                                                                            primaryColor,
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                ],
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                              )
                                                            ],
                                                          )),
                                                        ],
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                      ),
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .blueGrey[50]),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  width *
                                                                      0.150),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Center(
                                                      child: Container(
                                                        height: height * 0.050,
                                                        width: width * 0.350,
                                                        child: Center(
                                                          child: Text(
                                                            'Add to Calendar',
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Center(
                                                      child: Container(
                                                        height: height * 0.065,
                                                        width: width * 0.4,
                                                        child: Center(
                                                          child: Text(
                                                            'ATTEND',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    0.5),
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : selectedValue == 5
                                                ? Container(
                                                    height: height * 0.3,
                                                    width: width,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                width * 0.030,
                                                            vertical: 10),
                                                    child: GridView.builder(
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
                                                              childAspectRatio:
                                                                  1.8,
                                                              crossAxisCount:
                                                                  2),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return listofUpcommingEvents
                                                                .isEmpty
                                                            ? ShimerEffect(
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      15.0.h,
                                                                  width:
                                                                      100.0.w,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              )
                                                            : InkWell(
                                                                onTap: () {
                                                                  Get.to(() =>
                                                                      EventDetails(
                                                                        eventId:
                                                                            listofUpcommingEvents[index].eventId,
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
                                                                    height:
                                                                        25.0.h,
                                                                    width:
                                                                        100.0.w,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10),
                                                                        image: DecorationImage(
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            image: imageProvider)),
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomLeft,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Text(
                                                                              '${listofUpcommingEvents[index].eventTitle}',
                                                                              style: TextStyle(
                                                                                fontFamily: AppFonts.segoeui,
                                                                                fontSize: 11.0.sp,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              width: double.infinity,
                                                                              child: Text(
                                                                                '${listofUpcommingEvents[index].eventDescription}',
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 1,
                                                                                style: TextStyle(
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
                                                                          100.0
                                                                              .w,
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
                                                  )
                                                : Column(
                                                    children: [],
                                                  ),
                      ),
                      selectedValue != 0
                          ? SliverToBoxAdapter()
                          : SliverPadding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.030),
                              sliver: SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 1.0.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onTap: () {
                                              fromHomeStory =
                                                  '${widget.eventId}';
                                              Get.to(CameraApp(
                                                fromStory: true,
                                              ))!
                                                  .then((value) {
                                                fromHomeStory =
                                                    '${widget.eventId}';
                                                AuthUtils.getAllStoriesAPIEvent(
                                                    controller: controller,
                                                    eventID: widget.eventId);
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: Obx(
                                              () => !controller.storyLoad.value
                                                  ? ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      itemCount: 4,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (context, index) {
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
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        image: AssetImage(
                                                                            'assets/images/story.png'))),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      })
                                                  : controller
                                                          .listofStories.isEmpty
                                                      ? SizedBox()
                                                      : ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              BouncingScrollPhysics(),
                                                          itemCount: controller
                                                              .listofStories
                                                              .length,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemBuilder:
                                                              (context, index) {
                                                            String type = controller
                                                                .listofStories[
                                                                    index]
                                                                .storyobjects![
                                                                    0]
                                                                .type!;
                                                            return Stack(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    Get.to(
                                                                            MoreStories(
                                                                      storyobjects: controller
                                                                          .listofStories[
                                                                              index]
                                                                          .storyobjects,
                                                                    ))!
                                                                        .then(
                                                                            (value) {
                                                                      if (value
                                                                          is bool) {
                                                                        controller
                                                                            .storyLoad
                                                                            .value = false;
                                                                        AuthUtils.getAllStoriesAPIEvent(
                                                                            controller:
                                                                                controller,
                                                                            eventID:
                                                                                widget.eventId);
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        14.0.h,
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      child: type ==
                                                                              'photo'
                                                                          ? CachedNetworkImage(
                                                                              imageUrl: "$baseImageUrl${controller.listofStories[index].storyobjects![0].src}",
                                                                              fit: BoxFit.cover,
                                                                              progressIndicatorBuilder: (context, url, downloadProgress) => ShimerEffect(
                                                                                child: Image.asset(
                                                                                  'assets/images/home_banner.png',
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                              errorWidget: (context, url, error) => Image.asset(
                                                                                'assets/images/home_banner.png',
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            )
                                                                          : Center(
                                                                              child: Icon(
                                                                                Icons.play_circle_fill,
                                                                                color: Colors.white,
                                                                                size: 30,
                                                                              ),
                                                                            ),
                                                                    ),
                                                                    width:
                                                                        20.0.w,
                                                                    margin: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            0.5.h),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .black,
                                                                        borderRadius:
                                                                            BorderRadius.circular(8)),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              8,
                                                                          top:
                                                                              5),
                                                                  width: 20.0.w,
                                                                  child: Row(
                                                                    children: [
                                                                      CircularProfileAvatar(
                                                                        '',
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl: controller.listofStories[index].storyobjects![0].userPicture == null
                                                                              ? 'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm'
                                                                              : "$baseImageUrl${controller.listofStories[index].storyobjects![0].userPicture}",
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                                              ShimerEffect(
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/home_banner.png',
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                          errorWidget: (context, url, error) =>
                                                                              Image.asset(
                                                                            'assets/images/home_banner.png',
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                        borderColor:
                                                                            primaryColor,
                                                                        elevation:
                                                                            5,
                                                                        borderWidth:
                                                                            1,
                                                                        radius:
                                                                            10,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            3,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          '${controller.listofStories[index].storyobjects![0].userName}',
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 8),
                                                                        ),
                                                                      )
                                                                    ],
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
                                  ],
                                ),
                              ),
                            ),
                      selectedValue != 0
                          ? SliverToBoxAdapter()
                          : SliverToBoxAdapter(
                              child: SizedBox(
                              height: 2.0.h,
                            )),
                      selectedValue != 0
                          ? SliverToBoxAdapter()
                          : SliverToBoxAdapter(
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            showMyPost = true;
                                          });
                                        },
                                        child: Center(
                                            child: Text(
                                          '${widget.Upcommingmodel!.eventTitle}',
                                          style: TextStyle(
                                            fontFamily: AppFonts.segoeui,
                                            fontSize: 14,
                                            color: showMyPost
                                                ? primaryColor
                                                : Colors.black45,
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
                                          setState(() {
                                            showMyPost = false;
                                          });
                                        },
                                        child: Center(
                                            child: Text(
                                          'By Fans',
                                          style: TextStyle(
                                            fontFamily: AppFonts.segoeui,
                                            fontSize: 14,
                                            color: !showMyPost
                                                ? primaryColor
                                                : Colors.black45,
                                          ),
                                          textAlign: TextAlign.center,
                                        )),
                                      )),
                                ],
                              ),
                            ),
                      selectedValue != 0
                          ? SliverToBoxAdapter()
                          : SliverToBoxAdapter(
                              child: SizedBox(
                              height: 2.0.h,
                            )),
                      selectedValue != 0
                          ? SliverToBoxAdapter()
                          : SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.030),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        Get.to(CreatePost(
                                          fromEvent: true,
                                          event_id: widget.eventId,
                                        ));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(1.0.h),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xff0bab0d)),
                                            borderRadius:
                                                BorderRadius.circular(5)),
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
                              ),
                            ),
                      selectedValue != 0
                          ? SliverToBoxAdapter()
                          : !controller.storyLoad.value
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
                                            if (showMyPost) {
                                              if (controller.listofSearch[index]
                                                      .userPosted
                                                      .toString() ==
                                                  widget.Upcommingmodel!
                                                      .eventAdmin
                                                      .toString()) {
                                                return UserPost(
                                                  rooyaPostModel: controller
                                                      .listofSearch[index],
                                                  onPostLike: () {
                                                    setState(() {
                                                      controller
                                                          .listofSearch[index]
                                                          .islike = true;
                                                      controller
                                                          .listofSearch[index]
                                                          .likecount = controller
                                                              .listofSearch[
                                                                  index]
                                                              .likecount! +
                                                          1;
                                                    });
                                                  },
                                                  onPostUnLike: () {
                                                    setState(() {
                                                      controller
                                                          .listofSearch[index]
                                                          .islike = false;
                                                      controller
                                                          .listofSearch[index]
                                                          .likecount = controller
                                                              .listofSearch[
                                                                  index]
                                                              .likecount! -
                                                          1;
                                                    });
                                                  },
                                                  comment: () {
                                                    AuthUtils
                                                        .getgetRooyaEventSearchPostByLimite(
                                                            controller:
                                                                controller,
                                                            word: searchText
                                                                .value
                                                                .toString(),
                                                            event_id:
                                                                widget.eventId);
                                                  },
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            } else {
                                              if (controller.listofSearch[index]
                                                      .userPosted
                                                      .toString() !=
                                                  widget.Upcommingmodel!
                                                      .eventAdmin
                                                      .toString()) {
                                                return UserPost(
                                                  rooyaPostModel: controller
                                                      .listofSearch[index],
                                                  onPostLike: () {
                                                    setState(() {
                                                      controller
                                                          .listofSearch[index]
                                                          .islike = true;
                                                      controller
                                                          .listofSearch[index]
                                                          .likecount = controller
                                                              .listofSearch[
                                                                  index]
                                                              .likecount! +
                                                          1;
                                                    });
                                                  },
                                                  onPostUnLike: () {
                                                    setState(() {
                                                      controller
                                                          .listofSearch[index]
                                                          .islike = false;
                                                      controller
                                                          .listofSearch[index]
                                                          .likecount = controller
                                                              .listofSearch[
                                                                  index]
                                                              .likecount! -
                                                          1;
                                                    });
                                                  },
                                                  comment: () {
                                                    AuthUtils
                                                        .getgetRooyaEventSearchPostByLimite(
                                                            controller:
                                                                controller,
                                                            word: searchText
                                                                .value
                                                                .toString(),
                                                            event_id:
                                                                widget.eventId);
                                                  },
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            }
                                          },
                                          childCount:
                                              controller.listofSearch.length,
                                        ),
                                      ),
                                    )
                                  : SliverPadding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.030),
                                      sliver: SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            if (showMyPost) {
                                              if (controller.listofpost[index]
                                                      .userPosted
                                                      .toString() ==
                                                  widget.Upcommingmodel!
                                                      .eventAdmin
                                                      .toString()) {
                                                return UserPost(
                                                  rooyaPostModel: controller
                                                      .listofpost[index],
                                                  onPostLike: () {
                                                    setState(() {
                                                      controller
                                                          .listofpost[index]
                                                          .islike = true;
                                                      controller
                                                              .listofpost[index]
                                                              .likecount =
                                                          controller
                                                                  .listofpost[
                                                                      index]
                                                                  .likecount! +
                                                              1;
                                                    });
                                                  },
                                                  onPostUnLike: () {
                                                    setState(() {
                                                      controller
                                                          .listofpost[index]
                                                          .islike = false;
                                                      controller
                                                              .listofpost[index]
                                                              .likecount =
                                                          controller
                                                                  .listofpost[
                                                                      index]
                                                                  .likecount! -
                                                              1;
                                                    });
                                                  },
                                                  comment: () {
                                                    AuthUtils
                                                        .getgetRooyaEventByLimite(
                                                            controller:
                                                                controller,
                                                            eventID:
                                                                widget.eventId);
                                                  },
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            } else {
                                              if (controller.listofpost[index]
                                                      .userPosted
                                                      .toString() !=
                                                  widget.Upcommingmodel!
                                                      .eventAdmin
                                                      .toString()) {
                                                return UserPost(
                                                  rooyaPostModel: controller
                                                      .listofpost[index],
                                                  onPostLike: () {
                                                    setState(() {
                                                      controller
                                                          .listofpost[index]
                                                          .islike = true;
                                                      controller
                                                              .listofpost[index]
                                                              .likecount =
                                                          controller
                                                                  .listofpost[
                                                                      index]
                                                                  .likecount! +
                                                              1;
                                                    });
                                                  },
                                                  onPostUnLike: () {
                                                    setState(() {
                                                      controller
                                                          .listofpost[index]
                                                          .islike = false;
                                                      controller
                                                              .listofpost[index]
                                                              .likecount =
                                                          controller
                                                                  .listofpost[
                                                                      index]
                                                                  .likecount! -
                                                              1;
                                                    });
                                                  },
                                                  comment: () {
                                                    AuthUtils
                                                        .getgetRooyaEventByLimite(
                                                            controller:
                                                                controller,
                                                            eventID:
                                                                widget.eventId);
                                                  },
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            }
                                          },
                                          childCount:
                                              controller.listofpost.length,
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
      ),
    );
  }
}

launchURL(String aaa) async {
  final url = '$aaa';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
