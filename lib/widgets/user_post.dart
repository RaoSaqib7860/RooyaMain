import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/models/RooyaPostModel.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/view_pic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserPost extends StatefulWidget {
  RooyaPostModel? rooyaPostModel;
  Function? onPostLike;
  Function? onPostUnLike;

  UserPost({Key? key, this.rooyaPostModel, this.onPostLike, this.onPostUnLike})
      : super(key: key);

  @override
  _UserPostState createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  List<String> mHashTags = [
    '#longdrive',
    '#lovelyweather',
    '#mildsunlight',
    '#mindfreshing',
    '#longdrive',
    '#lovelyweather',
    '#mildsunlight',
    '#mindfreshing'
  ];
  List<String> mTagPersons = [
    'assets/images/story.png',
    'assets/images/story.png',
    'assets/images/story.png',
    'assets/images/story.png',
    'assets/images/story.png',
    'assets/images/story.png',
    'assets/images/story.png',
    'assets/images/story.png'
  ];

  bool isLikeLoading = false;
  bool isCommentLoading = false;
  TextEditingController mCommentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    // debugPrint(widget.rooyaPostModel.toJson().toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                height: 7.0.h,
                width: 7.0.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: widget.rooyaPostModel!.userPicture != null
                            ? NetworkImage(
                                '${baseImageUrl}${widget.rooyaPostModel!.userPicture}')
                            : NetworkImage(
                                'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm'))),
              ),
              SizedBox(
                width: 5.0.w,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.rooyaPostModel!.userfullname}',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 12,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      )),
                  Text(
                    '@${widget.rooyaPostModel!.userName}',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 10,
                      color: const Color(0xff000000),
                      height: 1.8,
                    ),
                    textAlign: TextAlign.left,
                  )
                ],
              )),
              Text(
                '${timeago.format(DateTime.parse(widget.rooyaPostModel!.time!), locale: 'en_short')} ago',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 10,
                  color: const Color(0xff000000),
                  height: 1.8,
                ),
                textAlign: TextAlign.right,
              )
            ],
          ),
          SizedBox(
            height: 1.0.h,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(1.5.h)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.rooyaPostModel!.attachment!.length > 0
                    ? InkWell(
                        onTap: () {
                          Get.to(() => ViewPic(
                                attachment: widget.rooyaPostModel!.attachment!,
                              ));
                        },
                        child: widget.rooyaPostModel!.attachment!.length == 1
                            ? CachedNetworkImage(
                                imageUrl:
                                    "$baseImageUrl${widget.rooyaPostModel!.attachment![0].attachment}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 30.0.h,
                                  width: 100.0.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(1.5.h),
                                          topRight: Radius.circular(1.5.h)),
                                      image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          image: imageProvider)),
                                ),
                                placeholder: (context, url) => Container(
                                    height: 30.0.h,
                                    width: 100.0.w,
                                    child: Center(
                                        child: CircularProgressIndicator())),
                                errorWidget: (context, url, error) => Container(
                                    height: 30.0.h,
                                    width: 100.0.w,
                                    child: Center(child: Icon(Icons.error))),
                              )
                            : widget.rooyaPostModel!.attachment!.length == 2
                                ? Column(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl:
                                            "$baseImageUrl${widget.rooyaPostModel!.attachment![0].attachment}",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 30.0.h,
                                          width: 100.0.w,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(1.5.h),
                                                  topRight:
                                                      Radius.circular(1.5.h)),
                                              image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image: imageProvider)),
                                        ),
                                        placeholder: (context, url) => Container(
                                            height: 30.0.h,
                                            width: 100.0.w,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator())),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                                height: 30.0.h,
                                                width: 100.0.w,
                                                child: Center(
                                                    child: Icon(Icons.error))),
                                      ),
                                      CachedNetworkImage(
                                        imageUrl:
                                            "$baseImageUrl${widget.rooyaPostModel!.attachment![1].attachment}",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 30.0.h,
                                          width: 100.0.w,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(1.5.h),
                                                  topRight:
                                                      Radius.circular(1.5.h)),
                                              image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image: imageProvider)),
                                        ),
                                        placeholder: (context, url) => Container(
                                            height: 30.0.h,
                                            width: 100.0.w,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator())),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                                height: 30.0.h,
                                                width: 100.0.w,
                                                child: Center(
                                                    child: Icon(Icons.error))),
                                      )
                                    ],
                                  )
                                : widget.rooyaPostModel!.attachment!.length == 3
                                    ? Column(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                                "$baseImageUrl${widget.rooyaPostModel!.attachment![0].attachment}",
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: 25.0.h,
                                              width: 100.0.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  1.5.h),
                                                          topRight:
                                                              Radius.circular(
                                                                  1.5.h)),
                                                  image: DecorationImage(
                                                      fit: BoxFit.fitWidth,
                                                      image: imageProvider)),
                                            ),
                                            placeholder: (context, url) =>
                                                Container(
                                                    height: 25.0.h,
                                                    width: 100.0.w,
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator())),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Container(
                                                    height: 25.0.h,
                                                    width: 100.0.w,
                                                    child: Center(
                                                        child:
                                                            Icon(Icons.error))),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "$baseImageUrl${widget.rooyaPostModel!.attachment![1].attachment}",
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      height: 50.0.w,
                                                      width: 50.0.w,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          1.5
                                                                              .h),
                                                                  topRight: Radius
                                                                      .circular(1.5
                                                                          .h)),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  imageProvider)),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        Container(
                                                            height: 50.0.w,
                                                            width: 50.0.w,
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator())),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Container(
                                                            height: 50.0.w,
                                                            width: 50.0.w,
                                                            child: Center(
                                                                child: Icon(Icons
                                                                    .error))),
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "$baseImageUrl${widget.rooyaPostModel!.attachment![2].attachment}",
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      height: 50.0.w,
                                                      width: 50.0.w,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          1.5
                                                                              .h),
                                                                  topRight: Radius
                                                                      .circular(1.5
                                                                          .h)),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  imageProvider)),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        Container(
                                                            height: 50.0.w,
                                                            width: 50.0.w,
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator())),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Container(
                                                            height: 50.0.w,
                                                            width: 50.0.w,
                                                            child: Center(
                                                                child: Icon(Icons
                                                                    .error))),
                                                  ))
                                            ],
                                          )
                                        ],
                                      )
                                    : widget.rooyaPostModel!.attachment!
                                                .length ==
                                            4
                                        ? Column(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    "$baseImageUrl${widget.rooyaPostModel!.attachment![0].attachment}",
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: 25.0.h,
                                                  width: 100.0.w,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      1.5.h),
                                                              topRight: Radius
                                                                  .circular(
                                                                      1.5.h)),
                                                      image: DecorationImage(
                                                          fit: BoxFit.fitWidth,
                                                          image:
                                                              imageProvider)),
                                                ),
                                                placeholder: (context, url) =>
                                                    Container(
                                                        height: 25.0.h,
                                                        width: 100.0.w,
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator())),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Container(
                                                        height: 25.0.h,
                                                        width: 100.0.w,
                                                        child: Center(
                                                            child: Icon(
                                                                Icons.error))),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "$baseImageUrl${widget.rooyaPostModel!.attachment![1].attachment}",
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          height: 100.0.w / 3,
                                                          width: 100.0.w / 3,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          1.5
                                                                              .h),
                                                                  topRight: Radius
                                                                      .circular(1.5
                                                                          .h)),
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image:
                                                                      imageProvider)),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            Container(
                                                                height:
                                                                    100.0.w / 3,
                                                                width:
                                                                    100.0.w / 3,
                                                                child: Center(
                                                                    child:
                                                                        CircularProgressIndicator())),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Container(
                                                                height:
                                                                    100.0.w / 3,
                                                                width:
                                                                    100.0.w / 3,
                                                                child: Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .error))),
                                                      )),
                                                  Expanded(
                                                      flex: 1,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "$baseImageUrl${widget.rooyaPostModel!.attachment![2].attachment}",
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          height: 100.0.w / 3,
                                                          width: 100.0.w / 3,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          1.5
                                                                              .h),
                                                                  topRight: Radius
                                                                      .circular(1.5
                                                                          .h)),
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image:
                                                                      imageProvider)),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            Container(
                                                                height:
                                                                    100.0.w / 3,
                                                                width:
                                                                    100.0.w / 3,
                                                                child: Center(
                                                                    child:
                                                                        CircularProgressIndicator())),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Container(
                                                                height:
                                                                    100.0.w / 3,
                                                                width:
                                                                    100.0.w / 3,
                                                                child: Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .error))),
                                                      )),
                                                  Expanded(
                                                      flex: 1,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "$baseImageUrl${widget.rooyaPostModel!.attachment![3].attachment}",
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          height: 100.0.w / 3,
                                                          width: 100.0.w / 3,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          1.5
                                                                              .h),
                                                                  topRight: Radius
                                                                      .circular(1.5
                                                                          .h)),
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image:
                                                                      imageProvider)),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            Container(
                                                                height:
                                                                    100.0.w / 3,
                                                                width:
                                                                    100.0.w / 3,
                                                                child: Center(
                                                                    child:
                                                                        CircularProgressIndicator())),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Container(
                                                                height:
                                                                    100.0.w / 3,
                                                                width:
                                                                    100.0.w / 3,
                                                                child: Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .error))),
                                                      ))
                                                ],
                                              )
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    "$baseImageUrl${widget.rooyaPostModel!.attachment![0].attachment}",
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: 25.0.h,
                                                  width: 100.0.w,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      1.5.h),
                                                              topRight: Radius
                                                                  .circular(
                                                                      1.5.h)),
                                                      image: DecorationImage(
                                                          fit: BoxFit.fitWidth,
                                                          image:
                                                              imageProvider)),
                                                ),
                                                placeholder: (context, url) =>
                                                    Container(
                                                        height: 25.0.h,
                                                        width: 100.0.w,
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator())),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Container(
                                                        height: 25.0.h,
                                                        width: 100.0.w,
                                                        child: Center(
                                                            child: Icon(
                                                                Icons.error))),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "$baseImageUrl${widget.rooyaPostModel!.attachment![1].attachment}",
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          height: 100.0.w / 3,
                                                          width: 100.0.w / 3,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          1.5
                                                                              .h),
                                                                  topRight: Radius
                                                                      .circular(1.5
                                                                          .h)),
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image:
                                                                      imageProvider)),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            Container(
                                                                height:
                                                                    100.0.w / 3,
                                                                width:
                                                                    100.0.w / 3,
                                                                child: Center(
                                                                    child:
                                                                        CircularProgressIndicator())),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Container(
                                                                height:
                                                                    100.0.w / 3,
                                                                width:
                                                                    100.0.w / 3,
                                                                child: Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .error))),
                                                      )),
                                                  Expanded(
                                                      flex: 1,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "$baseImageUrl${widget.rooyaPostModel!.attachment![2].attachment}",
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          height: 100.0.w / 3,
                                                          width: 100.0.w / 3,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          1.5
                                                                              .h),
                                                                  topRight: Radius
                                                                      .circular(1.5
                                                                          .h)),
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image:
                                                                      imageProvider)),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            Container(
                                                                height:
                                                                    100.0.w / 3,
                                                                width:
                                                                    100.0.w / 3,
                                                                child: Center(
                                                                    child:
                                                                        CircularProgressIndicator())),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Container(
                                                                height:
                                                                    100.0.w / 3,
                                                                width:
                                                                    100.0.w / 3,
                                                                child: Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .error))),
                                                      )),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Stack(
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl:
                                                                "$baseImageUrl${widget.rooyaPostModel!.attachment![3].attachment}",
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              height:
                                                                  100.0.w / 3,
                                                              width:
                                                                  100.0.w / 3,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(1.5
                                                                              .h),
                                                                      topRight: Radius
                                                                          .circular(1.5
                                                                              .h)),
                                                                  image: DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image:
                                                                          imageProvider)),
                                                            ),
                                                            placeholder: (context,
                                                                    url) =>
                                                                Container(
                                                                    height:
                                                                        100.0.w /
                                                                            3,
                                                                    width: 100.0
                                                                            .w /
                                                                        3,
                                                                    child: Center(
                                                                        child:
                                                                            CircularProgressIndicator())),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                Container(
                                                                    height:
                                                                        100.0.w /
                                                                            3,
                                                                    width: 100.0
                                                                            .w /
                                                                        3,
                                                                    child: Center(
                                                                        child: Icon(
                                                                            Icons.error))),
                                                          ),
                                                          Container(
                                                            height: 100.0.w / 3,
                                                            width: 100.0.w / 3,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                            child: Center(
                                                                child: Text(
                                                              '+${widget.rooyaPostModel!.attachment!.length - 4}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0.sp,
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                          )
                                                        ],
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                      )
                    : Container(),

                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 2.0.w),
                  child: Text(
                    '${widget.rooyaPostModel!.text}',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 12,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                widget.rooyaPostModel!.posthashtags!.isNotEmpty
                    ? Container(
                        width: 100.0.w,
                        color: Colors.grey[200],
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.0.w, vertical: 2.0.w),
                        child: Wrap(
                          children: widget.rooyaPostModel!.posthashtags!
                              .map((hashTag) => Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 1.0.w),
                                    child: Text('${hashTag.hashtag}',
                                        style: TextStyle(
                                          fontFamily: 'Segoe UI',
                                          fontSize: 12,
                                          color: const Color(0xff5a5a5a),
                                        )),
                                  ))
                              .toList(),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 2.0.h,
                ),
                widget.rooyaPostModel!.postusertags!.isNotEmpty
                    ? Container(
                        width: 100.0.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(1.5.h),
                              bottomRight: Radius.circular(1.5.h)),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.0.w, vertical: 2.0.w),
                        child: Row(
                          children: [
                            Text('@',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 13,
                                  color: const Color(0xff5a5a5a),
                                )),
                            SizedBox(
                              width: 2.0.w,
                            ),
                            Expanded(
                              child: Container(
                                // width: 100.0.w,
                                // color:Colors.grey[200],
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(1.5.h),
                                      bottomRight: Radius.circular(1.5.h)),
                                ),
                                child: Wrap(
                                  children: widget.rooyaPostModel!.postusertags!
                                      .map((user) => Container(
                                            height: 4.0.h,
                                            width: 4.0.h,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 0.5.w),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: user.userPicture !=
                                                                null &&
                                                            user.userPicture !=
                                                                ''
                                                        ? NetworkImage(
                                                            '${baseImageUrl}${user.userPicture}')
                                                        : NetworkImage(
                                                            'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm'))),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                // SizedBox(height: 2.0.h,),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 2.0.w),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if (!isLikeLoading) {
                      widget.rooyaPostModel!.islike!
                          ? rooyaPostUnLike()
                          : rooyaPostLike();
                    }
                  },
                  child: Image.asset(
                    'assets/icons/like.png',
                    height: 2.5.h,
                    color: widget.rooyaPostModel!.islike!
                        ? primaryColor
                        : Colors.black54,
                  ),
                ),
                SizedBox(
                  width: 3.0.w,
                ),
                Image.asset(
                  'assets/icons/comment.png',
                  height: 2.5.h,
                  color: Colors.black54,
                ),
                SizedBox(
                  width: 3.0.w,
                ),
                Image.asset(
                  'assets/icons/repeat.png',
                  height: 2.0.h,
                  color: Colors.black54,
                ),
                SizedBox(
                  width: 3.0.w,
                ),
                Image.asset(
                  'assets/icons/share.png',
                  height: 2.5.h,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 3.0.w,
          ),
          Container(
            height: 7.0.h,
            margin: EdgeInsets.symmetric(horizontal: 3.0.w),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: mCommentController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 5, top: 5, right: 15),
                      hintText: 'Type your comment here...',
                      hintStyle: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 13,
                        color: const Color(0xff1e1e1e),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (!isCommentLoading &&
                        mCommentController.text.isNotEmpty) {
                      rooyaPostComment();
                    }
                  },
                  icon: Icon(
                    Icons.send,
                    color: primaryColor,
                  ),
                )
              ],
            ),
          ),
          Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.rooyaPostModel!.commentsText!.length > 2
                      ? 2
                      : widget.rooyaPostModel!.commentsText!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 2.0.h, horizontal: 3.0.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 5.0.h,
                            width: 5.0.h,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: widget
                                                    .rooyaPostModel!
                                                    .commentsText![index]
                                                    .profileImg !=
                                                null &&
                                            widget
                                                    .rooyaPostModel!
                                                    .commentsText![index]
                                                    .profileImg !=
                                                ''
                                        ? NetworkImage(
                                            '$baseImageUrl${widget.rooyaPostModel!.commentsText![index].profileImg}')
                                        : NetworkImage(
                                            'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm'))),
                          ),
                          SizedBox(
                            width: 2.0.w,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${widget.rooyaPostModel!.commentsText![index].userfullname}',
                                  style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 11.0.sp,
                                    color: const Color(0xff5a5a5a),
                                  )),
                              Text(
                                  '${timeago.format(DateTime.parse(widget.rooyaPostModel!.commentsText![index].time!), locale: 'en_short')} ago',
                                  style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 8.0.sp,
                                    color: const Color(0xff000000),
                                  )),
                              SizedBox(
                                height: 0.5.h,
                              ),
                              Text(
                                  '${widget.rooyaPostModel!.commentsText![index].text}',
                                  style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    fontSize: 8.0.sp,
                                    color: const Color(0xff000000),
                                  )),
                              SizedBox(
                                height: 1.0.h,
                              ),
                              Row(
                                children: [
                                  Text(
                                      '${widget.rooyaPostModel!.commentsText![index].numbersOfLikes}',
                                      style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 12.0.sp,
                                        color: const Color(0xff5a5a5a),
                                      )),
                                  SizedBox(
                                    width: 1.0.w,
                                  ),
                                  Image.asset(
                                    'assets/icons/like.png',
                                    height: 2.5.h,
                                    color: widget.rooyaPostModel!
                                            .commentsText![index].islike!
                                        ? primaryColor
                                        : Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 2.0.w,
                                  ),
                                  Text(
                                      '${widget.rooyaPostModel!.commentsText![index].replies}',
                                      style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 12.0.sp,
                                        color: const Color(0xff5a5a5a),
                                      )),
                                  SizedBox(
                                    width: 1.0.w,
                                  ),
                                  Image.asset(
                                    'assets/icons/comment.png',
                                    height: 2.5.h,
                                    color: Colors.black54,
                                  ),
                                ],
                              )
                            ],
                          ))
                        ],
                      ),
                    );
                  })),
          SizedBox(
            height: 2.0.h,
          )
        ],
      ),
    );
  }

  Future<void> rooyaPostLike() async {
    setState(() {
      isLikeLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    int? userId = await prefs.getInt('user_id');
    final response = await http.post(Uri.parse('${baseUrl}postLike${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode(
            {"post_id": widget.rooyaPostModel!.postId, "user_id": userId}));

    setState(() {
      isLikeLoading = false;
    });

    // print(response.request);
    // print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          widget.onPostLike!();
        });
      } else {
        setState(() {});
      }
    }
  }

  Future<void> rooyaPostUnLike() async {
    setState(() {
      isLikeLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    int? userId = await prefs.getInt('user_id');
    final response = await http.post(Uri.parse('${baseUrl}postUnLike${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode(
            {"post_id": widget.rooyaPostModel!.postId, "user_id": userId}));

    setState(() {
      isLikeLoading = false;
    });

    // print(response.request);
    // print(response.statusCode);
    // print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          widget.onPostUnLike!();
        });
      } else {
        setState(() {});
      }
    }
  }

  Future<void> rooyaPostComment() async {
    setState(() {
      isCommentLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    int? userId = await prefs.getInt('user_id');
    final response = await http.post(Uri.parse('${baseUrl}postComments${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "post_id": widget.rooyaPostModel!.postId,
          "post_type": "post",
          "user_id": userId,
          "user_type": "user",
          "text": mCommentController.text
        }));

    setState(() {
      isCommentLoading = false;
    });

    // print(response.request);
    // print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          mCommentController.text = '';
        });
      } else {
        setState(() {});
      }
    }
  }
}
