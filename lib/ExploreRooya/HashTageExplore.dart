import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rooya_app/AppThemes/AppThemes.dart';
import 'package:rooya_app/GlobalClass/TextEditingController.dart';
import 'package:rooya_app/utils/AppFonts.dart';

import 'HashTags.dart';

class HashTageExplore extends StatefulWidget {
  const HashTageExplore({Key? key}) : super(key: key);

  @override
  _HashTageExploreState createState() => _HashTageExploreState();
}

class _HashTageExploreState extends State<HashTageExplore> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      var height = size.maxHeight;
      var width = size.minWidth;
      return SafeArea(
          child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.030),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.020,
              ),
              Row(
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: TextFromFieldsCustom(
                      hint: 'Search here',
                      posticon: Icon(
                        CupertinoIcons.search,
                        color: greenColor,
                        size: 17,
                      ),
                    ),
                  ),
                ],
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
                  InkWell(
                    child: catText(text: '#expo2020'),
                    onTap: () {
                      //     Get.to(HashTags());
                    },
                  ),
                  divider(),
                  InkWell(
                      onTap: () {
                        //     Get.to(HashTags());
                      },
                      child: catText(text: '#dubai10x')),
                  divider(),
                  InkWell(
                      onTap: () {
                        //    Get.to(HashTags());
                      },
                      child: catText(text: '#arabsonmars')),
                  divider(),
                  InkWell(
                      onTap: () {
                        //    Get.to(HashTags());
                      },
                      child: catText(text: '#uaegreens')),
                  divider(),
                  InkWell(
                      onTap: () {
                        // Get.to(HashTags());
                      },
                      child: catText(text: '#expo')),
                  divider(),
                  InkWell(
                      onTap: () {
                        //        Get.to(HashTags());
                      },
                      child: catText(text: '#covid19')),
                ],
              ),
              SizedBox(
                height: height * 0.020,
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    slideOne(width: width, height: height),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: height * 0.030,
                      ),
                    ),
                    slideOne(width: width, height: height),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: height * 0.030,
                      ),
                    ),
                    slideOne(width: width, height: height),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: height * 0.030,
                      ),
                    ),
                    slideOne(width: width, height: height),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: height * 0.030,
                      ),
                    ),
                  ],
                  physics: BouncingScrollPhysics(),
                ),
              )
            ],
          ),
        ),
      ));
    });
  }

  Widget slideOne({final height, final width}) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Text(
            '#expo2020',
            style: TextStyle(
                fontFamily: AppFonts.segoeui,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
          Text(
            '101.1 M',
            style: TextStyle(fontFamily: AppFonts.segoeui, fontSize: 10),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            height: height * 0.150,
            width: width,
            child: ListView.builder(
              itemBuilder: (c, i) {
                return Stack(
                  children: [
                    Container(
                      height: height * 0.150,
                      width: width * 0.220,
                      margin: EdgeInsets.only(right: width * 0.025),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          'assets/images/model.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.150,
                      width: width * 0.220,
                      padding: EdgeInsets.all(3),
                      child: Column(
                        children: [
                          Text(
                            '5326 Views',
                            style: TextStyle(
                                fontSize: 8,
                                fontFamily: AppFonts.segoeui,
                                color: Colors.white),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    )
                  ],
                );
              },
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 10,
            ),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}

Widget catText({String? text, Color? color = Colors.black54}) {
  return Text(
    text!,
    style: TextStyle(fontSize: 10, color: color, fontFamily: AppFonts.segoeui),
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
