import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:sizer/sizer.dart';

class PostWith5Images extends StatefulWidget {
  final RooyaPostModel? rooyaPostModel;

  const PostWith5Images({Key? key, this.rooyaPostModel}) : super(key: key);

  @override
  _PostWith5ImagesState createState() => _PostWith5ImagesState();
}

class _PostWith5ImagesState extends State<PostWith5Images> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          child: widget.rooyaPostModel!.attachment![0].type == 'image'
              ? CachedNetworkImage(
                  imageUrl:
                      "$baseImageUrl${widget.rooyaPostModel!.attachment![0].attachment}",
                  fit: BoxFit.cover,
                  width: double.infinity,
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
                ),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
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
                      fit: BoxFit.cover,
                      height: height * 0.140,
                      placeholder: (context, url) => Container(
                          height: height * 0.140,
                          child: ShimerEffect(
                            child: Image.asset(
                              'assets/images/home_banner.png',
                              fit: BoxFit.cover,
                            ),
                          )),
                      errorWidget: (context, url, error) => Container(
                          height: height * 0.140,
                          child: Center(child: Icon(Icons.image))),
                    )
                  : Container(
                      height: height * 0.140,
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
                      fit: BoxFit.cover,
                      height: height * 0.140,
                      placeholder: (context, url) => Container(
                          height: height * 0.140,
                          child: ShimerEffect(
                            child: Image.asset(
                              'assets/images/home_banner.png',
                              fit: BoxFit.cover,
                            ),
                          )),
                      errorWidget: (context, url, error) => Container(
                          height: height * 0.140,
                          child: Center(child: Icon(Icons.image))),
                    )
                  : Container(
                      height: height * 0.140,
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
                child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: widget.rooyaPostModel!.attachment![3].type == 'image'
                      ? CachedNetworkImage(
                          imageUrl:
                              "$baseImageUrl${widget.rooyaPostModel!.attachment![3].attachment}",
                          fit: BoxFit.cover,
                          height: height * 0.140,
                          placeholder: (context, url) => Container(
                              height: height * 0.140,
                              child: ShimerEffect(
                                child: Image.asset(
                                  'assets/images/home_banner.png',
                                  fit: BoxFit.cover,
                                ),
                              )),
                          errorWidget: (context, url, error) => Container(
                              height: height * 0.140,
                              child: Center(child: Icon(Icons.image))),
                        )
                      : Container(
                          height: height * 0.140,
                          decoration: BoxDecoration(color: Colors.black),
                          child: Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: height * 0.140,
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                        child: Text(
                      '+${widget.rooyaPostModel!.attachment!.length - 4}',
                      style: TextStyle(fontSize: 18.0.sp, color: Colors.white),
                    )),
                  ),
                )
              ],
            ))
          ],
        )
      ],
    );
  }
}
