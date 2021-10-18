import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:sizer/sizer.dart';

class PostWith3Images extends StatefulWidget {
  final RooyaPostModel? rooyaPostModel;

  const PostWith3Images({Key? key, this.rooyaPostModel}) : super(key: key);

  @override
  _PostWith3ImagesState createState() => _PostWith3ImagesState();
}

class _PostWith3ImagesState extends State<PostWith3Images> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.rooyaPostModel!.attachment![0].type == 'image'
            ? CachedNetworkImage(
                imageUrl:
                    "$baseImageUrl${widget.rooyaPostModel!.attachment![0].attachment}",
                width: double.infinity,
                placeholder: (context, url) => ShimerEffect(
                  child: Container(
                    height: 25.0.h,
                    width: 100.0.w,
                    child: Image.asset(
                      'assets/images/home_banner.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                    height: 25.0.h,
                    width: 100.0.w,
                    child: Center(child: Icon(Icons.image))),
              )
            : Container(
                height: 25.0.h,
                width: 100.0.w,
                decoration: BoxDecoration(color: Colors.black),
                child: Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
        SizedBox(
          height: 3,
        ),
        Row(
          children: [
            Expanded(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: widget.rooyaPostModel!.attachment![1].type == 'image'
                  ? CachedNetworkImage(
                      imageUrl:
                          "$baseImageUrl${widget.rooyaPostModel!.attachment![1].attachment}",
                      height: 40.0.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                          height: 40.0.w,
                          child: Center(child: CircularProgressIndicator())),
                      errorWidget: (context, url, error) => Container(
                          height: 40.0.w,
                          child: Center(child: Icon(Icons.error))),
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
              child: widget.rooyaPostModel!.attachment![2].type == 'image'
                  ? CachedNetworkImage(
                      imageUrl:
                          "$baseImageUrl${widget.rooyaPostModel!.attachment![2].attachment}",
                      height: 40.0.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                          height: 40.0.w,
                          child: Center(child: CircularProgressIndicator())),
                      errorWidget: (context, url, error) => Container(
                          height: 40.0.w,
                          child: Center(child: Icon(Icons.error))),
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
        )
      ],
    );
  }
}
