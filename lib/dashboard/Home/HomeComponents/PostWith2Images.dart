import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:sizer/sizer.dart';

class PostWith2Images extends StatefulWidget {
  final RooyaPostModel? rooyaPostModel;

  const PostWith2Images({Key? key, this.rooyaPostModel}) : super(key: key);

  @override
  _PostWith2ImagesState createState() => _PostWith2ImagesState();
}

class _PostWith2ImagesState extends State<PostWith2Images> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: widget.rooyaPostModel!.attachment![0].type == 'image'
                  ? CachedNetworkImage(
                      imageUrl:
                          "$baseImageUrl${widget.rooyaPostModel!.attachment![0].attachment}",
                      height: 40.0.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => ShimerEffect(
                        child: Container(
                          height: 40.0.w,
                          child: Image.asset(
                            'assets/images/home_banner.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                          height: 40.0.w,
                          child: Center(child: Icon(Icons.image))),
                    )
                  : Container(
                      height: 40.0.w,
                      decoration: BoxDecoration(color: Colors.black),
                      child: Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
            )),
            SizedBox(
              width: 3,
            ),
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: widget.rooyaPostModel!.attachment![1].type == 'image'
                  ? CachedNetworkImage(
                      imageUrl:
                          "$baseImageUrl${widget.rooyaPostModel!.attachment![1].attachment}",
                      height: 40.0.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => ShimerEffect(
                        child: Container(
                          height: 40.0.w,
                          child: Image.asset(
                            'assets/images/home_banner.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                          height: 40.0.w,
                          child: Center(child: Icon(Icons.image))),
                    )
                  : Container(
                      height: 40.0.w,
                      decoration: BoxDecoration(color: Colors.black),
                      child: Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
            ))
          ],
        ),
        // CachedNetworkImage(
        //   imageUrl:
        //       "$baseImageUrl${widget.rooyaPostModel!.attachment![0].attachment}",
        //   placeholder: (context, url) => ShimerEffect(
        //     child: Container(
        //       height: 30.0.h,
        //       width: 100.0.w,
        //       child: Image.asset(
        //         'assets/images/home_banner.png',
        //         fit: BoxFit.cover,
        //       ),
        //     ),
        //   ),
        //   errorWidget: (context, url, error) => Container(
        //       height: 30.0.h,
        //       width: 100.0.w,
        //       child: Center(child: Icon(Icons.image))),
        // ),
        // CachedNetworkImage(
        //   imageUrl:
        //       "$baseImageUrl${widget.rooyaPostModel!.attachment![1].attachment}",
        //   imageBuilder: (context, imageProvider) => Container(
        //     height: 30.0.h,
        //     width: 100.0.w,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(1.5.h),
        //             topRight: Radius.circular(1.5.h)),
        //         image: DecorationImage(
        //             fit: BoxFit.fitWidth, image: imageProvider)),
        //   ),
        //   placeholder: (context, url) => Container(
        //       height: 30.0.h,
        //       width: 100.0.w,
        //       child: Center(child: CircularProgressIndicator())),
        //   errorWidget: (context, url, error) => Container(
        //       height: 30.0.h,
        //       width: 100.0.w,
        //       child: Center(child: Icon(Icons.error))),
        // )
      ],
    );
  }
}
