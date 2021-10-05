import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'models/RooyaPostModel.dart';
import 'ApiUtils/baseUrl.dart';
import 'package:sizer/sizer.dart';

class ViewPic extends StatefulWidget {
  List<Attachment>? attachment;

  ViewPic({Key? key, @required this.attachment}) : super(key: key);

  @override
  _ViewPicState createState() => _ViewPicState();
}

class _ViewPicState extends State<ViewPic> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final double height = MediaQuery.of(context).size.height;
        return CarouselSlider(
          options: CarouselOptions(
              height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              enableInfiniteScroll: false
              // autoPlay: false,
              ),
          items: widget.attachment!
              .map((item) => CachedNetworkImage(
                        imageUrl: "$baseImageUrl${item.attachment}",
                        imageBuilder: (context, imageProvider) => Container(
                          height: 100.0.h,
                          width: 100.0.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(1.5.h),
                                  topRight: Radius.circular(1.5.h)),
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth, image: imageProvider)),
                        ),
                        placeholder: (context, url) => Container(
                            height: 100.0.h,
                            width: 100.0.w,
                            child: Center(child: CircularProgressIndicator())),
                        errorWidget: (context, url, error) => Container(
                            height: 100.0.h,
                            width: 100.0.w,
                            child: Center(child: Icon(Icons.error))),
                      )
                  // Image.network(
                  //   '$baseImageUrl${item.attachment}',
                  //   fit: BoxFit.contain,
                  //   //height: height,
                  // )
                  )
              .toList(),
        );
      },
    );
  }
}
