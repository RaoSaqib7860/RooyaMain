import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rooya_app/AppThemes/AppThemes.dart';
import 'package:rooya_app/GlobalClass/TextEditingController.dart';
import 'package:rooya_app/utils/AppFonts.dart';

import 'HashTageExplore.dart';

class HashTags extends StatefulWidget {
  const HashTags({Key? key}) : super(key: key);

  @override
  _HashTagsState createState() => _HashTagsState();
}

class _HashTagsState extends State<HashTags> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      var height = size.maxHeight;
      var width = size.maxWidth;
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
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (c, i) {
                      return InkWell(
                        onTap: () {
                          pushNewScreen(
                            context,
                            screen: HashTageExplore(),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: height * 0.010),
                              height: height * 0.050,
                              child: Center(
                                child: Text(
                                  'Entertainment',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: AppFonts.segoeui),
                                ),
                              ),
                              width: width,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '#arabsonmars',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontFamily: AppFonts.segoeui),
                                ),
                                Text(
                                  '#arabsonmars',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontFamily: AppFonts.segoeui),
                                ),
                                SizedBox(
                                  width: width * 0.1,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '0.5K posts',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: greenColor,
                                      fontFamily: AppFonts.segoeui),
                                ),
                                Text(
                                  '0.5K posts',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: greenColor,
                                      fontFamily: AppFonts.segoeui),
                                ),
                                SizedBox(
                                  width: width * 0.1,
                                )
                              ],
                            ),
                            SizedBox(
                              height: height * 0.020,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: 10,
                    physics: BouncingScrollPhysics(),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
