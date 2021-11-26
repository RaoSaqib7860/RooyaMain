import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rooya_app/utils/SizedConfig.dart';

import 'Screens/VideoPlayerService/VideoPlayer.dart';
import 'dashboard/Home/Models/RooyaPostModel.dart';
import 'ApiUtils/baseUrl.dart';
import 'package:sizer/sizer.dart';

class ViewPic extends StatefulWidget {
  List<Attachment>? attachment;

  ViewPic({Key? key, @required this.attachment}) : super(key: key);

  @override
  _ViewPicState createState() => _ViewPicState();
}

class _ViewPicState extends State<ViewPic> {
  int? index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                  height: height,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                  onPageChanged: (i, dd) {
                    setState(() {
                      index = i;
                    });
                  }),
              items: widget.attachment!.map((item) {
                if (item.type == 'video') {
                  return VideoForURL(
                    url: "$baseImageUrl${item.attachment}",
                  );
                } else {
                  return PhotoView(
                    imageProvider: NetworkImage("$baseImageUrl${item.attachment}"),
                  );
                  // return CachedNetworkImage(
                  //   imageUrl: "$baseImageUrl${item.attachment}",
                  //   fit: BoxFit.contain,
                  //   placeholder: (context, url) => Container(
                  //       height: 100.0.h,
                  //       width: 100.0.w,
                  //       child: Center(child: CircularProgressIndicator())),
                  //   errorWidget: (context, url, error) => Container(
                  //       height: 100.0.h,
                  //       width: 100.0.w,
                  //       child: Center(child: Icon(Icons.error))),
                  // );
                }
              }).toList(),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '${index! + 1} /' + '${widget.attachment!.length}',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
