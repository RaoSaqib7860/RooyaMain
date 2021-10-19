import 'dart:convert';
import 'dart:developer';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/dashboard/Home/HomeComponents/PostWith1Image.dart';
import 'package:rooya_app/dashboard/Home/HomeComponents/PostWith2Images.dart';
import 'package:rooya_app/dashboard/Home/HomeComponents/PostWith3Images.dart';
import 'package:rooya_app/dashboard/Home/HomeComponents/PostWith4Images.dart';
import 'package:rooya_app/dashboard/Home/HomeComponents/PostWith5Images.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/view_pic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../profile.dart';

class UserPost extends StatefulWidget {
  RooyaPostModel? rooyaPostModel;
  Function()? onPostLike;
  Function()? onPostUnLike;
  Function()? comment;

  UserPost(
      {Key? key,
      this.rooyaPostModel,
      this.onPostLike,
      this.onPostUnLike,
      this.comment})
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
              CircularProfileAvatar(
                widget.rooyaPostModel!.userPicture == null
                    ? 'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm'
                    : '$baseImageUrl${widget.rooyaPostModel!.userPicture}',
                elevation: 5,
                radius: 23,
                onTap: () {
                  Get.to(Profile(
                    userID: '${widget.rooyaPostModel!.userPosted}',
                  ));
                },
                borderColor: primaryColor,
                borderWidth: 1,
              ),
              SizedBox(
                width: 4.0.w,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.rooyaPostModel!.userfullname}',
                      style: TextStyle(
                        fontFamily: AppFonts.segoeui,
                        fontSize: 13,
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w600,
                      )),
                  Text(
                    '@${widget.rooyaPostModel!.userName}',
                    style: TextStyle(
                      fontFamily: AppFonts.segoeui,
                      fontSize: 10,
                      color: const Color(0xff000000),
                    ),
                    textAlign: TextAlign.left,
                  )
                ],
              )),
              Text(
                '${timeago.format(DateTime.parse(widget.rooyaPostModel!.time!), locale: 'en_short')} ago',
                style: TextStyle(
                  fontFamily: AppFonts.segoeui,
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
                borderRadius: BorderRadius.circular(7)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.rooyaPostModel!.attachment!.length > 0
                      ? InkWell(
                          onTap: () {
                            Get.to(ViewPic(
                              attachment: widget.rooyaPostModel!.attachment!,
                            ));
                          },
                          child: widget.rooyaPostModel!.attachment!.length == 1
                              ? PostWith1Image(
                                  rooyaPostModel: widget.rooyaPostModel,
                                )
                              : widget.rooyaPostModel!.attachment!.length == 2
                                  ? PostWith2Images(
                                      rooyaPostModel: widget.rooyaPostModel,
                                    )
                                  : widget.rooyaPostModel!.attachment!.length ==
                                          3
                                      ? PostWith3Images(
                                          rooyaPostModel: widget.rooyaPostModel,
                                        )
                                      : widget.rooyaPostModel!.attachment!
                                                  .length ==
                                              4
                                          ? PostWith4Images(
                                              rooyaPostModel:
                                                  widget.rooyaPostModel,
                                            )
                                          : PostWith5Images(
                                              rooyaPostModel:
                                                  widget.rooyaPostModel,
                                            ),
                        )
                      : Container(),
                  widget.rooyaPostModel!.text!.trim().isEmpty
                      ? SizedBox()
                      : Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 2.0.w),
                          child: Text(
                            '${widget.rooyaPostModel!.text}',
                            style: TextStyle(
                              fontFamily: AppFonts.segoeui,
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
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 1.0.w),
                                      child: Text('#${hashTag.hashtag}',
                                          style: TextStyle(
                                            fontFamily: AppFonts.segoeui,
                                            fontSize: 12,
                                            color: const Color(0xff5a5a5a),
                                          )),
                                    ))
                                .toList(),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: !widget.rooyaPostModel!.postusertags!.isNotEmpty
                        ? 0
                        : 1.0.h,
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
                                    fontFamily: AppFonts.segoeui,
                                    fontSize: 13,
                                    color: const Color(0xff5a5a5a),
                                  )),
                              SizedBox(
                                width: 2.0.w,
                              ),
                              Expanded(
                                child: Container(
                                  height: 4.0.h,
                                  width: 4.0.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(1.5.h),
                                        bottomRight: Radius.circular(1.5.h)),
                                  ),
                                  child: ListView.builder(
                                    itemBuilder: (c, i) {
                                      return CircularProfileAvatar(
                                        widget.rooyaPostModel!.postusertags![i]
                                                        .userPicture !=
                                                    null &&
                                                widget
                                                        .rooyaPostModel!
                                                        .postusertags![i]
                                                        .userPicture !=
                                                    ''
                                            ? '$baseImageUrl${widget.rooyaPostModel!.postusertags![i].userPicture}'
                                            : 'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm',
                                        radius: 15,
                                      );
                                    },
                                    itemCount: widget
                                        .rooyaPostModel!.postusertags!.length,
                                    scrollDirection: Axis.horizontal,
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
          ),
          SizedBox(
            height: 0.50.w,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 2.0.w),
            child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    if (!isLikeLoading) {
                      isLikeLoading = true;
                      if (widget.rooyaPostModel!.islike!) {
                        await rooyaPostUnLike();
                      } else {
                        await rooyaPostLike();
                      }
                      isLikeLoading = false;
                    }
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3, right: 5),
                        child: Text(
                          '${widget.rooyaPostModel!.likecount}',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontFamily: AppFonts.segoeui),
                        ),
                      ),
                      Image.asset(
                        'assets/icons/like.png',
                        height: 2.h,
                        color: widget.rooyaPostModel!.islike!
                            ? primaryColor
                            : Colors.black54,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 3.0.w,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 3, right: 5),
                      child: Text(
                        '${widget.rooyaPostModel!.comments}',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontFamily: AppFonts.segoeui),
                      ),
                    ),
                    Image.asset(
                      'assets/icons/comment.png',
                      height: 2.h,
                      color: Colors.black54,
                    ),
                  ],
                ),
                SizedBox(
                  width: 3.0.w,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 3, right: 5),
                      child: Text(
                        '${widget.rooyaPostModel!.userPosted}',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontFamily: AppFonts.segoeui),
                      ),
                    ),
                    Image.asset(
                      'assets/icons/repeat.png',
                      height: 2.0.h,
                      width: 3.0.h,
                      color: Colors.black54,
                    ),
                  ],
                ),
                SizedBox(
                  width: 3.0.w,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 3, right: 5),
                      child: Text(
                        '',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontFamily: AppFonts.segoeui),
                      ),
                    ),
                    Image.asset(
                      'assets/icons/share.png',
                      height: 2.h,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 0.50.w,
          ),
          Container(
            height: height * 0.055,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: mCommentController,
                    cursorColor: Colors.black,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      isDense: true,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15, right: 15),
                      hintText: 'Type your comment here...',
                      hintStyle: TextStyle(
                        fontFamily: AppFonts.segoeui,
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
                    size: 20,
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
                          CircularProfileAvatar(
                            widget.rooyaPostModel!.commentsText![index]
                                            .profileImg !=
                                        null &&
                                    widget.rooyaPostModel!.commentsText![index]
                                            .profileImg !=
                                        ''
                                ? '$baseImageUrl${widget.rooyaPostModel!.commentsText![index].profileImg}'
                                : 'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm',
                            radius: 18,
                          ),
                          SizedBox(
                            width: 2.0.w,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  '${widget.rooyaPostModel!.commentsText![index].userfullname}',
                                  style: TextStyle(
                                      fontFamily: AppFonts.segoeui,
                                      fontSize: 9.0.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  '${timeago.format(DateTime.parse(widget.rooyaPostModel!.commentsText![index].time!), locale: 'en_short')} ago',
                                  style: TextStyle(
                                    fontFamily: AppFonts.segoeui,
                                    fontSize: 8.0.sp,
                                    color: const Color(0xff000000),
                                  )),
                              SizedBox(
                                height: 0.5.h,
                              ),
                              Text(
                                  '${widget.rooyaPostModel!.commentsText![index].text}',
                                  style: TextStyle(
                                    fontFamily: AppFonts.segoeui,
                                    fontSize: 10.0.sp,
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
                                        fontFamily: AppFonts.segoeui,
                                        fontSize: 12.0.sp,
                                        color: const Color(0xff5a5a5a),
                                      )),
                                  SizedBox(
                                    width: 1.0.w,
                                  ),
                                  Image.asset(
                                    'assets/icons/like.png',
                                    height: 2.0.h,
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
                                        fontFamily: AppFonts.segoeui,
                                        fontSize: 12.0.sp,
                                        color: const Color(0xff5a5a5a),
                                      )),
                                  SizedBox(
                                    width: 1.0.w,
                                  ),
                                  Image.asset(
                                    'assets/icons/comment.png',
                                    height: 2.0.h,
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
        ],
      ),
    );
  }

  Future<void> rooyaPostLike() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    print('userid=$userId');
    final response = await http.post(Uri.parse('${baseUrl}postLike$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode(
            {"post_id": widget.rooyaPostModel!.postId, "user_id": userId}));
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        widget.onPostLike!.call();
      } else {
        setState(() {});
      }
    }
  }

  Future<void> rooyaPostUnLike() async {
    print('Unlike call now');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    final response = await http.post(Uri.parse('${baseUrl}postUnLike$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode(
            {"post_id": widget.rooyaPostModel!.postId, "user_id": userId}));
    log('${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        widget.onPostUnLike!.call();
      }
    }
  }

  Future<void> rooyaPostComment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    final response = await http.post(Uri.parse('${baseUrl}postComments$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "post_id": widget.rooyaPostModel!.postId,
          "post_type": "post",
          "user_id": userId,
          "user_type": "user",
          "text": mCommentController.text
        }));
    // print(response.request);
    // print(response.statusCode);
    widget.comment!.call();
    print('data iss = ${response.body}');

    // if (response.statusCode == 200) {
    //   final data = jsonDecode(response.body);
    //   if (data['result'] == 'success') {
    //     setState(() {
    //       mCommentController.text = '';
    //     });
    //   } else {
    //     setState(() {});
    //   }
    // }
  }
}
