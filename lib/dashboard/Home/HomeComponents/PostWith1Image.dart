import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:sizer/sizer.dart';

class PostWith1Image extends StatefulWidget {
  final RooyaPostModel? rooyaPostModel;

  const PostWith1Image({Key? key, this.rooyaPostModel}) : super(key: key);

  @override
  _PostWith1ImageState createState() => _PostWith1ImageState();
}

class _PostWith1ImageState extends State<PostWith1Image> {
  @override
  Widget build(BuildContext context) {
    return widget.rooyaPostModel!.attachment![0].type == 'image'
        ? CachedNetworkImage(
            imageUrl:
                "$baseImageUrl${widget.rooyaPostModel!.attachment![0].attachment}",
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => ShimerEffect(
              child: Container(
                height: 30.0.h,
                width: 100.0.w,
                child: Image.asset(
                  'assets/images/home_banner.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
                height: 30.0.h,
                width: 100.0.w,
                child: Center(child: Icon(Icons.image))),
          )
        : Container(
            height: 30.0.h,
            width: 100.0.w,
            decoration: BoxDecoration(color: Colors.black),
            child: Center(
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 40,
              ),
            ),
          );
  }
}
