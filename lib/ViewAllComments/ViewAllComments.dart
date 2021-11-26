import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/dashboard/Home/HomeComponents/user_post.dart';
import 'package:rooya_app/dashboard/Home/Models/RooyaPostModel.dart';
import 'package:rooya_app/dashboard/profile.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'CommitModel.dart';

class ViewAllComments extends StatefulWidget {
  List<CommentsText>? comments;
  String? postID;

  ViewAllComments({Key? key, this.comments, this.postID}) : super(key: key);

  @override
  _ViewAllCommentsState createState() => _ViewAllCommentsState();
}

class _ViewAllCommentsState extends State<ViewAllComments> {
  List<CommentModel> listofComments = [];
  bool loadComment = false;
  TextEditingController textController = TextEditingController();
  bool istag = false;

  @override
  void initState() {
    print('post is = ${widget.postID}');
    getCommentsById();
    super.initState();
  }

  GetStorage storage = GetStorage();

  String tag = '';
  String comment_id = '';
  String user_id = '';
  bool isEdit = false;
  bool reEdit = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Comments',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontFamily: AppFonts.segoeui),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height - height * 0.2,
              child: !loadComment
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : listofComments.isEmpty
                      ? Center(
                          child: Text('Empty'),
                        )
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: listofComments.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 1.0.h, horizontal: 3.0.w),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        child:
                                            listofComments[index].userPicture !=
                                                        null &&
                                                    listofComments[index]
                                                            .userPicture !=
                                                        ''
                                                ? CircularProfileAvatar(
                                                    '$baseImageUrl${listofComments[index].userPicture}',
                                                    radius: 18,
                                                  )
                                                : CircularProfileAvatar(
                                                    '',
                                                    child: Image.asset(
                                                        'assets/images/logo.png'),
                                                    radius: 18,
                                                  ),
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (c) => Profile(
                                                        userID:
                                                            '${listofComments[index].userId}',
                                                      )));
                                        },
                                      ),
                                      SizedBox(
                                        width: 2.0.w,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (c) => Profile(
                                                            userID:
                                                                '${listofComments[index].userId}',
                                                          )));
                                            },
                                            child: Text(
                                                '${listofComments[index].userName}',
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.segoeui,
                                                    fontSize: 9.0.sp,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          InkWell(
                                            child: Text(
                                                '${timeago.format(DateTime.parse(listofComments[index].commentTime!), locale: 'en_short')} ago',
                                                style: TextStyle(
                                                  fontFamily: AppFonts.segoeui,
                                                  fontSize: 8.0.sp,
                                                  color:
                                                      const Color(0xff000000),
                                                )),
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (c) => Profile(
                                                            userID:
                                                                '${listofComments[index].userId}',
                                                          )));
                                            },
                                          ),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                          Text('${listofComments[index].text}',
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
                                                  '${listofComments[index].reactionLikeCount}',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.segoeui,
                                                    fontSize: 12.0.sp,
                                                    color:
                                                        const Color(0xff5a5a5a),
                                                  )),
                                              SizedBox(
                                                width: 1.0.w,
                                              ),
                                              InkWell(
                                                child: Image.asset(
                                                  'assets/icons/like.png',
                                                  height: 2.0.h,
                                                  color: listofComments[index]
                                                          .isLike!
                                                      ? primaryColor
                                                      : Colors.black54,
                                                ),
                                                onTap: () async {
                                                  if (listofComments[index]
                                                      .isLike!) {
                                                    await postCommentsUnLike(
                                                        comment_id:
                                                            listofComments[
                                                                    index]
                                                                .commentId
                                                                .toString());
                                                    getCommentsById();
                                                  } else {
                                                    await postCommentsLike(
                                                        comment_id:
                                                            listofComments[
                                                                    index]
                                                                .commentId
                                                                .toString());
                                                    getCommentsById();
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                width: 2.0.w,
                                              ),
                                              Text(
                                                  '${listofComments[index].recomments!.length}',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.segoeui,
                                                    fontSize: 12.0.sp,
                                                    color:
                                                        const Color(0xff5a5a5a),
                                                  )),
                                              SizedBox(
                                                width: 1.0.w,
                                              ),
                                              InkWell(
                                                child: Image.asset(
                                                  'assets/icons/comment.png',
                                                  height: 2.0.h,
                                                  color: Colors.black54,
                                                ),
                                                onTap: () {
                                                  istag = true;
                                                  setState(() {});
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 50),
                                                      () {
                                                    tag =
                                                        '@${listofComments[index].userName}';
                                                    istag = false;
                                                    setState(() {});
                                                    comment_id =
                                                        listofComments[index]
                                                            .commentId
                                                            .toString();
                                                    user_id =
                                                        listofComments[index]
                                                            .userId
                                                            .toString();
                                                  });
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                      listofComments[index].userId.toString() !=
                                              storage.read('userID')
                                          ? PopupMenuButton(
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  child: Text("Report"),
                                                  value: 1,
                                                ),
                                              ],
                                              icon: Icon(
                                                Icons.more_vert,
                                                size: 15,
                                              ),
                                              onSelected: (i) async {},
                                            )
                                          : PopupMenuButton(
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  child: Text("Edit"),
                                                  value: 1,
                                                ),
                                                PopupMenuItem(
                                                  child: Text("Delete"),
                                                  value: 2,
                                                )
                                              ],
                                              icon: Icon(
                                                Icons.more_vert,
                                                size: 15,
                                              ),
                                              onSelected: (i) async {
                                                print('index is =$i');
                                                if (i == 2) {
                                                  await postCommentsRemove(
                                                      comment_id:
                                                          listofComments[index]
                                                              .commentId
                                                              .toString());
                                                  getCommentsById();
                                                } else {
                                                  istag = true;
                                                  isEdit = true;
                                                  setState(() {});
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 50),
                                                      () {
                                                    tag =
                                                        '${listofComments[index].text}';
                                                    istag = false;
                                                    setState(() {});
                                                    comment_id =
                                                        listofComments[index]
                                                            .commentId
                                                            .toString();
                                                    user_id =
                                                        listofComments[index]
                                                            .userId
                                                            .toString();
                                                  });
                                                }
                                              },
                                            )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: width * 0.120),
                                  child: Column(
                                    children: listofComments[index]
                                        .recomments!
                                        .map((e) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            right: width * 0.060,
                                            left: width * 0.030),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              child: e.reuserPicture != null &&
                                                      e.reuserPicture != ''
                                                  ? CircularProfileAvatar(
                                                      '$baseImageUrl${e.reuserPicture}',
                                                      radius: 14,
                                                    )
                                                  : CircularProfileAvatar(
                                                      '',
                                                      child: Image.asset(
                                                          'assets/images/logo.png'),
                                                      radius: 14,
                                                    ),
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (c) => Profile(
                                                              userID:
                                                                  '${e.reuserId}',
                                                            )));
                                              },
                                            ),
                                            SizedBox(
                                              width: 2.0.w,
                                            ),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (c) =>
                                                                Profile(
                                                                  userID:
                                                                      '${e.reuserId}',
                                                                )));
                                                  },
                                                  child: Text('${e.reuserName}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              AppFonts.segoeui,
                                                          fontSize: 9.0.sp,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                InkWell(
                                                  child: Text(
                                                      '${timeago.format(DateTime.parse(e.recommentTime!), locale: 'en_short')} ago',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            AppFonts.segoeui,
                                                        fontSize: 8.0.sp,
                                                        color: const Color(
                                                            0xff000000),
                                                      )),
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (c) =>
                                                                Profile(
                                                                  userID:
                                                                      '${e.reuserId}',
                                                                )));
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 0.5.h,
                                                ),
                                                Text('${e.retext}',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.segoeui,
                                                      fontSize: 10.0.sp,
                                                      color: const Color(
                                                          0xff000000),
                                                    )),
                                                SizedBox(
                                                  height: 1.0.h,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        '${e.reactionLikeCount}',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              AppFonts.segoeui,
                                                          fontSize: 10.0.sp,
                                                          color: const Color(
                                                              0xff5a5a5a),
                                                        )),
                                                    SizedBox(
                                                      width: 1.0.w,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        if (listofComments[
                                                                index]
                                                            .isLike!) {
                                                          await postReCommentsUnLike(
                                                              comment_id: e
                                                                  .commentId
                                                                  .toString());
                                                          getCommentsById();
                                                        } else {
                                                          await postReCommentsLike(
                                                              comment_id: e
                                                                  .commentId
                                                                  .toString());
                                                          getCommentsById();
                                                        }
                                                      },
                                                      child: Image.asset(
                                                        'assets/icons/like.png',
                                                        height: 1.50.h,
                                                        color: e.reIsLike!
                                                            ? primaryColor
                                                            : Colors.black54,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 2.0.w,
                                                    ),
                                                    // Text(
                                                    //     '${listofComments[index].recomments!.length}',
                                                    //     style: TextStyle(
                                                    //       fontFamily:
                                                    //           AppFonts.segoeui,
                                                    //       fontSize: 12.0.sp,
                                                    //       color:
                                                    //           const Color(0xff5a5a5a),
                                                    //     )),
                                                    // SizedBox(
                                                    //   width: 1.0.w,
                                                    // ),
                                                    Image.asset(
                                                      'assets/icons/comment.png',
                                                      height: 1.50.h,
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                            e.reuserId.toString() !=
                                                    storage.read('userID')
                                                ? PopupMenuButton(
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        child: Text("Report"),
                                                        value: 1,
                                                      ),
                                                    ],
                                                    icon: Icon(
                                                      Icons.more_vert,
                                                      size: 15,
                                                    ),
                                                    onSelected: (i) async {},
                                                  )
                                                : PopupMenuButton(
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        child: Text("Edit"),
                                                        value: 1,
                                                      ),
                                                      PopupMenuItem(
                                                        child: Text("Delete"),
                                                        value: 2,
                                                      )
                                                    ],
                                                    icon: Icon(
                                                      Icons.more_vert,
                                                      size: 15,
                                                    ),
                                                    onSelected: (index) async {
                                                      if (index == 2) {
                                                        await postCommentsRemove(
                                                            comment_id: e
                                                                .commentId
                                                                .toString());
                                                        getCommentsById();
                                                      } else {
                                                        istag = true;
                                                        reEdit = true;
                                                        isEdit = true;
                                                        setState(() {});
                                                        Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    50), () {
                                                          tag = '${e.retext}';
                                                          istag = false;
                                                          setState(() {});
                                                          comment_id = e
                                                              .commentId
                                                              .toString();
                                                          user_id = e.reuserId
                                                              .toString();
                                                        });
                                                      }
                                                    },
                                                  )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
            ),
            istag
                ? SizedBox()
                : Container(
                    height: height * 0.055,
                    width: width,
                    margin: EdgeInsets.symmetric(
                        horizontal: width * 0.030, vertical: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(25)),
                    child: CommentPostFields(
                      initialText: tag,
                      sendCommit: (text) async {
                        if (!text.contains('@') || isEdit) {
                          if (isEdit) {
                            print('postCommentsEdit');
                            if (reEdit) {
                              print('postReCommentsEdit');
                              await postReCommentsEdit(text: text);
                            } else {
                              await postCommentsEdit(text: text);
                            }
                            getCommentsById();
                            isEdit = false;
                            reEdit = false;
                          } else {
                            await rooyaPostComment(text: text);
                            getCommentsById();
                          }
                        } else {
                          await postReComments(text: text);
                          getCommentsById();
                        }
                      },
                    ),
                  ),
          ],
        ),
      ),
    ));
  }

  Future<void> postCommentsRemove({String? comment_id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}postCommentsRemove$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "post_id": userId,
          "comment_id": comment_id,
        }));
    print('data iss = ${response.body}');
  }

  Future<void> postCommentsLike({String? comment_id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}postCommentsLike$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": userId,
          "comment_id": comment_id,
        }));
    print('data iss = ${response.body}');
  }

  Future<void> postCommentsUnLike({String? comment_id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}postCommentsUnLike$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": userId,
          "comment_id": comment_id,
        }));
    print('data iss = ${response.body}');
  }

  Future<void> getCommentsById() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}getCommentsById$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"post_id": widget.postID, "user_id": userId}));
    print('data iss = ${response.body}');
    var data = jsonDecode(response.body);
    if (data['result'] == 'success') {
      if (data['data'] is List) {
        setState(() {
          loadComment = true;
        });
      }
      listofComments = List<CommentModel>.from(
          data['data']['comment'].map((model) => CommentModel.fromJson(model)));
    }
    setState(() {
      loadComment = true;
    });
  }

  Future<void> postReCommentsLike({String? comment_id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}postReCommentsLike$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": userId,
          "comment_id": comment_id,
        }));
    print('data iss = ${response.body}');
  }

  Future<void> postReCommentsUnLike({String? comment_id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}postReCommentsUnLike$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id": userId,
          "comment_id": comment_id,
        }));
    print('data iss = ${response.body}');
  }

  Future<void> rooyaPostComment({String? text}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    final response = await http.post(Uri.parse('${baseUrl}postComments$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "post_id": widget.postID,
          "post_type": "post",
          "user_id": userId,
          "user_type": "user",
          "text": text
        }));
    print('data iss = ${response.body}');
  }

  Future<void> postReComments({String? text}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    final response = await http.post(Uri.parse('${baseUrl}postReComments$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "post_id": comment_id,
          "post_type": "comment",
          "user_id": userId,
          "user_type": "user",
          "text": text
        }));
    print('data iss = ${response.body}');
  }

  Future<void> postCommentsEdit({String? text}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}postCommentsEdit$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode(
            {"comment_id": comment_id, "user_id": userId, "text": text}));
    print('data iss = ${response.body}');
  }

  Future<void> postReCommentsEdit({String? text}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}postReCommentsEdit$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode(
            {"comment_id": comment_id, "user_id": userId, "text": text}));
    print('data iss = ${response.body}');
  }
}
