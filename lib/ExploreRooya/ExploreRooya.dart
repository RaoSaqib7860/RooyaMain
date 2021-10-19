import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rooya_app/GlobalClass/HomePageGridView.dart';
import 'package:rooya_app/GlobalClass/TextEditingController.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/colors.dart';

import 'HashTags.dart';

class ExploreRooya extends StatefulWidget {
  const ExploreRooya({Key? key}) : super(key: key);

  @override
  _ExploreRooyaState createState() => _ExploreRooyaState();
}

class _ExploreRooyaState extends State<ExploreRooya> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      var height = size.maxHeight;
      var width = size.maxWidth;
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.030),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.015,
              ),
              TextFromFieldsCustom(
                hint: 'Search here',
                posticon: Icon(
                  CupertinoIcons.search,
                  color: greenColor,
                  size: 17,
                ),
              ),
              SizedBox(
                height: height * 0.020,
              ),
              Row(
                children: [
                  Text(
                    'Reel',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontFamily: AppFonts.segoeui),
                  ),
                  SizedBox(
                    width: width * 0.030,
                  ),
                  Container(
                    width: 1,
                    height: 10,
                    decoration: BoxDecoration(color: Colors.blueGrey[100]),
                  ),
                  SizedBox(
                    width: width * 0.030,
                  ),
                  Text(
                    'Play',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontFamily: AppFonts.segoeui),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              SizedBox(
                height: height * 0.020,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  catText('ALL'),
                  divider(),
                  catText('EDUCATION'),
                  divider(),
                  catText('SCIENCE'),
                  divider(),
                  catText('MUSIC'),
                  divider(),
                  catText('COMEDY'),
                  divider(),
                  catText('COMEDY'),
                  divider(),
                  catText('SCI-FI'),
                ],
              ),
              SizedBox(
                height: height * 0.020,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: catText('#expo2020'),
                    onTap: () {
                      pushNewScreen(
                        context,
                        screen: HashTags(),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                  ),
                  divider(),
                  InkWell(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: HashTags(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: catText('#dubai10x')),
                  divider(),
                  InkWell(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: HashTags(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: catText('#arabsonmars')),
                  divider(),
                  InkWell(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: HashTags(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: catText('#uaegreens')),
                  divider(),
                  InkWell(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: HashTags(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: catText('#expo')),
                  divider(),
                  InkWell(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: HashTags(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: catText('#covid19')),
                ],
              ),
              SizedBox(
                height: height * 0.020,
              ),
              Expanded(
                  child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      height: height * 0.2,
                      width: width,
                      child: ListView.builder(
                        itemBuilder: (c, i) {
                          return Container(
                            margin: EdgeInsets.only(right: width * 0.015),
                            child: Column(
                              children: [
                                Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset(
                                      'assets/images/one.jpeg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: height * 0.140,
                                  width: width * 0.4,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                SizedBox(
                                  width: width * 0.4,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        child: ClipRRect(
                                          child: Image.asset(
                                            'assets/images/one.jpeg',
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        backgroundColor: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: width * 0.010,
                                      ),
                                      Text(
                                        'Dubai United Arab,emirates',
                                        style: TextStyle(
                                            fontSize: 8.5,
                                            fontFamily: AppFonts.segoeui),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                SizedBox(
                                  width: width * 0.4,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: width * 0.065),
                                        child: Text(
                                          '4322 views',
                                          style: TextStyle(
                                              fontSize: 7,
                                              fontFamily: AppFonts.segoeui,
                                              fontWeight: FontWeight.w400),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '27 Feb, 2021',
                                        style: TextStyle(
                                            fontSize: 7,
                                            fontFamily: AppFonts.segoeui,
                                            fontWeight: FontWeight.w400),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: height * 0.2,
                      width: width,
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/images/one.jpeg',
                                fit: BoxFit.cover,
                                width: width,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 10,
                                child: ClipRRect(
                                  child: Image.asset(
                                    'assets/images/one.jpeg',
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              SizedBox(
                                width: width * 0.010,
                              ),
                              Text(
                                'Dubai United Arab,emirates',
                                style: TextStyle(
                                    fontSize: 8.5,
                                    fontFamily: AppFonts.segoeui),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: width * 0.065),
                                  child: Text(
                                    '4322 views',
                                    style: TextStyle(
                                        fontSize: 7,
                                        fontFamily: AppFonts.segoeui,
                                        fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.030,
                                ),
                                Text(
                                  '27 Feb, 2021',
                                  style: TextStyle(
                                      fontSize: 7,
                                      fontFamily: AppFonts.segoeui,
                                      fontWeight: FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 5,
                    ),
                  ),
                  SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.20,
                          crossAxisSpacing: 15),
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return HomePageGridView(
                          width: width,
                          height: height,
                        );
                      }, childCount: 20)),
                ],
              ))
            ],
          ),
        ),
      );
    });
  }

  Widget catText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 10, color: Colors.black54, fontFamily: AppFonts.segoeui),
    );
  }

  Widget divider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 1,
      height: 10,
      decoration: BoxDecoration(color: Colors.blueGrey[100]),
    );
  }
}
