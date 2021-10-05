import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';
import 'package:rooya_app/models/RooyaPostModel.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/widgets/user_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class EventDetails extends StatefulWidget {
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool isLoading = false;
  List<RooyaPostModel> mRooyaPostsList = [];
  int selectedValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    getRooyaPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 30.0.h,
                    width: 100.0.w,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/home_banner.png'),
                            fit: BoxFit.fill)),
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    fontFamily: 'Segoe UI',
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
                                    'LIVE',
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
                                    'BRIEF',
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
                                    'FACILITIES',
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
                                    'LOCATION AND TIME',
                                    style: TextStyle(
                                      fontFamily: 'Segoe UI',
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
                                      fontFamily: 'Segoe UI',
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
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.0.h),
                      child: selectedValue == 0
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 1.0.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                        return Container(
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
                                        );
                                      }),
                                ),
                              ],
                            )
                          : selectedValue == 1
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 1.0.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Live',
                                          style: TextStyle(
                                            fontFamily: 'Segoe UI',
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
                                      height: 18.0.h,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Container(
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
                                            );
                                          }),
                                    ),
                                  ],
                                )
                              : selectedValue == 2
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 1.0.h,
                                        ),
                                        Text(
                                          'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore',
                                          style: TextStyle(
                                            fontFamily: 'Segoe UI',
                                            fontSize: 10.0.sp,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    )
                                  : selectedValue == 3
                                      ? Container(
                                          child: Flexible(
                                            child: ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: 4,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.0.w,
                                                            vertical: 2.0.w),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 1.5.h,
                                                          width: 1.5.h,
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        SizedBox(
                                                          width: 5.0.w,
                                                        ),
                                                        Text(
                                                          'Free Wi-Fi',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Segoe UI',
                                                            fontSize: 14.0.sp,
                                                            color: Colors.black,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                        )
                                      : selectedValue == 4
                                          ? Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 20.0.h,
                                                    child: false?Center(
                                                      /// Declare your static map
                                                      child: StaticMap(
                                                        width: 80.0.w,
                                                        height: 20.0.h,
                                                        scaleToDevicePixelRatio: true,
                                                        googleApiKey: "AIzaSyBUHybR7LFY1NoOwWxQR8FifKtSsum-xBU",
                                                        /// Declare optional markers
                                                        markers: <Marker>[
                                                          /// Define marker style
                                                          Marker(
                                                            color: Colors.lightBlue,
                                                            label: "A",
                                                            locations: [
                                                              /// Provide locations for markers of a defined style
                                                              Location(-3.1178833, -60.0029284),
                                                            ],
                                                          ),
                                                          /// Define another marker style with custom icon
                                                          // Marker.custom(
                                                          //   anchor: MarkerAnchor.bottom,
                                                          //   icon: "https://goo.gl/1oTJ9Y",
                                                          //   locations: [
                                                          //     Location(-3.1694166, -60.1041517),
                                                          //   ],
                                                          // )
                                                        ],
                                                      ),
                                                    ):Center(child: Text('Google Map'),),
                                                  ),
                                                  SizedBox(height: 3.0.h,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Material(
                                                              shape: CircleBorder(),
                                                              elevation: 5,
                                                              child: Container(
                                                                  padding: EdgeInsets.all(15),
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape.circle
                                                                  ),

                                                                  child: Image.asset('assets/icons/call.png',height: 3.0.h,width: 3.0.h,))),
                                                          SizedBox(height: 1.0.h,),
                                                          Text('Call',
                                                              style: TextStyle(
                                                                fontFamily: 'Segoe UI',
                                                                fontSize: 12.0.sp,
                                                                color: Colors.black,
                                                              ) )
                                                        ],
                                                      ),
                                                      SizedBox(width: 4.0.w,),
                                                      Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Material(
                                                              shape: CircleBorder(),
                                                              elevation: 5,
                                                              child: Container(
                                                                  padding: EdgeInsets.all(15),
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape.circle
                                                                  ),

                                                                  child: Image.asset('assets/icons/location.png',height: 3.0.h,width: 3.0.h,))),
                                                          SizedBox(height: 1.0.h,),
                                                          Text('Directions',
                                                              style: TextStyle(
                                                                fontFamily: 'Segoe UI',
                                                                fontSize: 12.0.sp,
                                                                color: Colors.black,
                                                              ) )
                                                        ],
                                                      ),
                                                      SizedBox(width: 4.0.w,),
                                                      Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Material(
                                                              shape: CircleBorder(),
                                                              elevation: 5,
                                                              child: Container(
                                                                  padding: EdgeInsets.all(15),
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape.circle
                                                                  ),

                                                                  child: Image.asset('assets/icons/globe.png',height: 3.0.h,width: 3.0.h,))),
                                                          SizedBox(height: 1.0.h,),
                                                          Text('Website',
                                                              style: TextStyle(
                                                                fontFamily: 'Segoe UI',
                                                                fontSize: 12.0.sp,
                                                                color: Colors.black,
                                                              ) )
                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                  SizedBox(height: 5.0.h,),
                                                  Container(
                                                    width: 70.0.w,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    padding: EdgeInsets.all(4.0.w),
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text('01',
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    'Segoe UI',
                                                                    fontSize: 14.0.sp,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.black,
                                                                  ),),
                                                                SizedBox(width: 5.0.w,),
                                                                Text('04',
                                                                    style: TextStyle(
                                                                      fontFamily:
                                                                      'Segoe UI',
                                                                      fontSize: 14.0.sp,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.black,
                                                                    )),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text('/')
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text('Jul',
                                                                    style: TextStyle(
                                                                      fontFamily:
                                                                      'Segoe UI',
                                                                      fontSize: 10.0.sp,
                                                                      color: Colors.black,
                                                                    )),
                                                                SizedBox(width: 5.0.w,),
                                                                Text('Jul',
                                                                    style: TextStyle(
                                                                      fontFamily:
                                                                      'Segoe UI',
                                                                      fontSize: 10.0.sp,
                                                                      color: Colors.black,
                                                                    )),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(width: 4.0.w),
                                                        Container(
                                                          height: 10.0.h,
                                                          width: 1,
                                                          color: Colors.grey[500],
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text('Thu, 1 July 2021',
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    'Segoe UI',
                                                                    fontSize: 13.0.sp,
                                                                    color: Colors.black,
                                                                  )),
                                                              SizedBox(height: 1.0.h,),
                                                              Text('4 Days Event',
                                                                  style: TextStyle(
                                                                    fontFamily:
                                                                    'Segoe UI',
                                                                    fontSize: 11.0.sp,
                                                                    color: primaryColor
                                                                  )),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 2.0.h,),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.black),
                                                      borderRadius: BorderRadius.circular(20)
                                                    ),
                                                    child: Text('Add to Calender',
                                                        style: TextStyle(
                                                          fontFamily:
                                                          'Segoe UI',
                                                          fontSize: 12.0.sp,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                  SizedBox(height: 5.0.h,),
                                                  Container(
                                                    width: 60.0.w,
                                                    height: 8.0.h,
                                                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                                    decoration: BoxDecoration(
                                                      color: primaryColor,
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    child: Center(
                                                      child: Text('ATTEND',
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Segoe UI',
                                                            fontSize: 16.0.sp,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                          )),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.0.h,),
                                                ],
                                              ),
                                            )
                                          : selectedValue == 5
                                              ? Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 1.0.h,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Your Events',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Segoe UI',
                                                            fontSize: 16,
                                                            color: const Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 1.0.h,
                                                    ),
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
                                                                  100.0.w /
                                                                      22.0.h,
                                                              crossAxisCount:
                                                                  2),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return InkWell(
                                                            onTap: () {},
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border
                                                                      .all(
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
                                              : Container()),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.0.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                                  //  Get.to(()=>CreatePost()).then((value) => getRooyaPost());
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
                          SizedBox(
                            height: 2.0.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text(
                                    'By Expo 2021',
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
                                    'By Fans',
                                    style: TextStyle(
                                      fontFamily: 'Segoe UI',
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  )))
                            ],
                          ),
                          SizedBox(
                            height: 2.0.h,
                          ),
                          Flexible(
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: mRooyaPostsList.length,
                                  itemBuilder: (context, index) {
                                    return UserPost(
                                      rooyaPostModel: mRooyaPostsList[index],
                                    );
                                  }))
                        ],
                      ))
                ],
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
        body: jsonEncode({"page_size": 100, "page_number": 1}));

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
    }
  }
}
