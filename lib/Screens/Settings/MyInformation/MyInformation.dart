import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rooya_app/utils/AppFonts.dart';

class MyInformation extends StatefulWidget {
  const MyInformation({Key? key}) : super(key: key);

  @override
  _MyInformationState createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (c, size) {
      var height = size.maxHeight;
      var width = size.maxWidth;
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Get.back();
            },
            color: Colors.white,
          ),
          centerTitle: false,
          title: Text(
            'My Information',
            style: TextStyle(
                fontFamily: AppFonts.segoeui,
                fontSize: 14,
                color: Colors.black),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.030),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.030,
              ),
              Row(
                children: [
                  getCard(
                      height: height,
                      width: width,
                      title: 'Photos',
                      path: 'assets/svg/photo.svg'),
                  SizedBox(
                    width: width * 0.060,
                  ),
                  getCard(
                      height: height,
                      width: width,
                      title: 'Videos',
                      path: 'assets/svg/video.svg'),
                ],
              ),
              SizedBox(
                height: height * 0.020,
              ),
              Row(
                children: [
                  getCard(
                      height: height,
                      width: width,
                      title: 'Links',
                      path: 'assets/svg/links.svg'),
                  SizedBox(
                    width: width * 0.060,
                  ),
                  getCard(
                      height: height,
                      width: width,
                      title: 'Documents',
                      path: 'assets/svg/doc.svg'),
                ],
              ),
              SizedBox(
                height: height * 0.020,
              ),
              Row(
                children: [
                  getCard(
                      height: height,
                      width: width,
                      title: 'Posts',
                      path: 'assets/svg/post.svg'),
                  SizedBox(
                    width: width * 0.060,
                  ),
                  getCard(
                      height: height,
                      width: width,
                      title: 'Souq',
                      path: 'assets/svg/souq.svg'),
                ],
              ),
              SizedBox(
                height: height * 0.020,
              ),
              Row(
                children: [
                  getCard(
                      height: height,
                      width: width,
                      title: 'Events',
                      path: 'assets/svg/event.svg'),
                  SizedBox(
                    width: width * 0.060,
                  ),
                  getCard(
                      height: height,
                      width: width,
                      title: 'My Events',
                      path: 'assets/svg/event.svg'),
                ],
              )
            ],
          ),
        ),
      ));
    });
  }

  Widget getCard({double? height, double? width, String? path, String? title}) {
    return Expanded(
      child: Container(
        height: height! * 0.080,
        child: Row(
          children: [
            SizedBox(
              child: SvgPicture.asset('$path'),
              width: width! / 6,
            ),
            SizedBox(
              width: width * 0.050,
            ),
            Text(
              '$title',
              style: TextStyle(fontFamily: AppFonts.segoeui),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.green.withOpacity(0.10),
                  offset: Offset(4, 4),
                  blurRadius: 3),
              BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  offset: Offset(-0.5, -0.5),
                  blurRadius: 1)
            ],
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
