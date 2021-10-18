import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/create_all.dart';
import 'package:rooya_app/events/upcoming_events.dart';
import 'package:rooya_app/explore_uae/explore_uae.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:sizer/sizer.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<String> mMenuIcons = [
    'assets/icons/create.png',
    'assets/icons/events.png',
    'assets/icons/explore.png',
    'assets/icons/explore_uae.png',
    'assets/icons/news.png',
    'assets/icons/offers.png',
    'assets/icons/parking.png',
    'assets/icons/prayer.png',
    'assets/icons/tourism.png',
    'assets/icons/weather.png',
    'assets/icons/hotels.png',
  ];
  List<String> mMenuTitle = [
    'Create',
    'Events',
    'Explore',
    'Explore UAE',
    'News',
    'Offers',
    'Parking',
    'Prayer',
    'Tourism',
    'Weather',
    'Restaurants/ Hotels',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.w),
        child: Column(
          children: [
            SizedBox(
              height: 2.0.h,
            ),
            Image.asset(
              'assets/images/logo.png',
              height: 8.0.h,
            ),
            SizedBox(
              height: 2.0.h,
            ),
            Expanded(
              child: GridView.builder(
                itemCount: mMenuTitle.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 5.0.w,
                    mainAxisSpacing: 5.0.w,
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      switch (index) {
                        case 0:
                          Get.to(() => CreateAll());
                          break;
                        case 1:
                          Get.to(() => UpComingEvents());
                          break;
                        case 3:
                          Get.to(() => ExploreUAE());
                          break;
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x290bab0d),
                            offset: Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              mMenuIcons[index],
                              height: 3.5.h,
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Text(
                              '${mMenuTitle[index]}',
                              style: TextStyle(
                                fontFamily: AppFonts.segoeui,
                                fontSize: 12,
                                color: const Color(0xff1e1e1e),
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
