import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/events/event_detail.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'Models/UpCommingEventModel.dart';

class UpComingEvents extends StatefulWidget {
  @override
  _UpComingEventsState createState() => _UpComingEventsState();
}

class _UpComingEventsState extends State<UpComingEvents> {
  @override
  void initState() {
    createEvent();
    super.initState();
  }

  List<UpComingEventsModel> listofUpcommingEvents = [];

  Future<void> createEvent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(
        Uri.parse('${baseUrl}getRooyaEventByLimite$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"page_size": 100, "page_number": 0}));
    print('Event response is = ${response.body}');
    var data = jsonDecode(response.body);
    listofUpcommingEvents = List<UpComingEventsModel>.from(
        data['data'].map((model) => UpComingEventsModel.fromJson(model)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Upcoming Events',
            style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: AppFonts.segoeui),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back, color: Colors.black)),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 1.5.w),
          child: Column(
            children: [
              SizedBox(
                height: 2.0.w,
              ),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: listofUpcommingEvents.isEmpty
                      ? 6
                      : listofUpcommingEvents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 3.0.w,
                      mainAxisSpacing: 3.0.w,
                      childAspectRatio: 1.8,
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return listofUpcommingEvents.isEmpty
                        ? ShimerEffect(
                            child: Container(
                              height: 15.0.h,
                              width: 100.0.w,
                              color: Colors.blue,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Get.to(() => EventDetails(
                                    eventId:
                                        listofUpcommingEvents[index].eventId,
                                    Upcommingmodel:
                                        listofUpcommingEvents[index],
                                  ));
                            },
                            child: CachedNetworkImage(
                              imageUrl: '$baseImageUrl' +
                                  '${listofUpcommingEvents[index].eventCover}',
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
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
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
                              placeholder: (context, url) => ShimerEffect(
                                child: Container(
                                  height: 15.0.h,
                                  width: 100.0.w,
                                  color: Colors.blue,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
