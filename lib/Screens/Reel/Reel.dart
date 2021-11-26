import 'dart:async';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rooya_app/Screens/VideoPlayerService/VideoPlayer.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/colors.dart';

import 'ReelCamera/ReelCamera.dart';

StreamController<double> controller = StreamController<double>.broadcast();

class ReelPage extends StatefulWidget {
  const ReelPage({Key? key}) : super(key: key);

  @override
  _ReelPageState createState() => _ReelPageState();
}

class _ReelPageState extends State<ReelPage> {
  List listofTag = [
    '#expo',
    '#dubaiexpo',
    '#expo2020',
    '#expo20',
    '#party',
    '#enjoy',
    '#expohype',
    '#expolove',
    '#expolive'
  ];
  String basePath = 'assets/videos/';

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: height,
        width: width,
        child: PageView.builder(
          itemBuilder: (c, i) {
            return Stack(
              children: [
                Container(
                  height: height,
                  width: width,
                  child: VideoApp(
                    assetsPath:
                        'https://play.rooya.com/upload/videos/appvids/Snaptik_6770615490269187334_kuczynskamaja.mp4',
                  ),
                  decoration: BoxDecoration(color: Colors.black),
                ),
                Column(
                  children: [
                    Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.050),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircularProfileAvatar(
                                '',
                                child: Image.asset(
                                  'assets/images/model.jpeg',
                                  fit: BoxFit.cover,
                                ),
                                borderColor: Colors.white,
                                borderWidth: 1,
                                elevation: 2,
                                radius: 20,
                              ),
                              SizedBox(
                                width: width * 0.040,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '@ahmad',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: AppFonts.segoeui,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    '15h ago',
                                    style: TextStyle(
                                        fontFamily: AppFonts.segoeui,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Dubai Expo 2020. Come & enjoy!',
                            style: TextStyle(
                                fontFamily: AppFonts.segoeui,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: width * 0.1),
                            child: Wrap(
                              children: listofTag.map((e) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      right: width * 0.030,
                                      bottom: height * 0.008),
                                  child: Text(
                                    '$e',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w200,
                                        fontSize: 13),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.010,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: height * 0.045,
                                    width: width * 0.090,
                                    child: Center(
                                      child: Icon(
                                        Icons.music_note,
                                        color: Colors.black,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: width * 0.040,
                                  ),
                                  Text(
                                    'relaxing_music',
                                    style: TextStyle(
                                        fontFamily: AppFonts.segoeui,
                                        color: Colors.white,
                                        fontSize: 12),
                                  )
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  //  Get.to(CameraApp());
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                      color: greenColor,
                                      shape: BoxShape.circle),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.010,
                    ),
                    Container(
                      height: height * 0.080,
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.060),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          bottomIcon(text: '1999', svg: 'share'),
                          bottomIcon(text: '345', svg: 'message'),
                          bottomIcon(text: '6.7k', svg: 'like'),
                          bottomIcon(text: '2999', svg: 'watch'),
                          SvgPicture.asset('assets/svg/more.svg'),
                        ],
                      ),
                      margin: EdgeInsets.symmetric(horizontal: width * 0.090),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(40)),
                    ),
                    SizedBox(
                      height: height * 0.020,
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: height * 0.030),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Following',
                        style: TextStyle(
                          fontFamily: AppFonts.segoeui,
                          color: Colors.white,
                          letterSpacing: 0.7,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 1,
                        height: 15,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Follow',
                        style: TextStyle(
                            fontFamily: AppFonts.segoeui,
                            color: Colors.white.withOpacity(0.5),
                            letterSpacing: 0.7,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      )
                    ],
                  ),
                )
              ],
            );
          },
          itemCount: [
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
            10,
            11,
            12,
            13,
            14,
            15,
            16,
            17,
            15,
            19,
            20,
            21,
            22,
            23,
            24,
            25,
            26,
            27,
            28
          ].length,
          scrollDirection: Axis.vertical,
        ),
      ),
    ));
  }

  Widget bottomIcon({String? svg, String? text}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/svg/$svg.svg'),
        SizedBox(
          height: 7,
        ),
        Text(
          '$text',
          style: TextStyle(
              fontFamily: AppFonts.segoeui, color: Colors.white, fontSize: 12),
        )
      ],
    );
  }
}
