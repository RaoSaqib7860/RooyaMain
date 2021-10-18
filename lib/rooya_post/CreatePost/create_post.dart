import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as dioo;
import 'package:flutter/material.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rooya_app/models/FileUploadModel.dart';
import 'package:rooya_app/models/HashTagModel.dart';
import 'package:rooya_app/models/UserTagModel.dart';
import 'package:rooya_app/rooya_post/CreatePost/add_hastags.dart';
import 'package:rooya_app/rooya_post/CreatePost/add_usertags.dart';
import 'package:rooya_app/rooya_post/CreateRooyaPostController.dart';
import 'package:rooya_app/story/create_story.dart';
import 'package:rooya_app/story/uploadStroy.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/widgets/FileUpload.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  List<HashTagModel> selectedHashTags = [];
  List<UserTagModel> selectedUserTags = [];
  List hashTags = [];
  List usersTags = [];
  List usersTagsPic = [];
  bool isLoading = false;
  String? uploadedUrl;
  List<FileUploadModel> mPic = [];
  int selectedImageIndex = 0;
  double uploadPercent = 0;
  TextEditingController descriptionController = TextEditingController();
  var controller = Get.put(CreateRooyaPostController());

  @override
  void initState() {
    controller.getImagePath();
    controller.getVideoPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ProgressHUD(
          inAsyncCall: isLoading,
          opacity: 0.7,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Create Post',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: AppFonts.segoeui),
              ),
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black)),
              actions: [
                InkWell(
                  onTap: () {
                    controller.selectLocation(context, 'gallery');
                  },
                  child: Icon(
                    Icons.photo_outlined,
                    size: 30,
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  width: width * 0.010,
                ),
                InkWell(
                  onTap: () {
                    controller.selectLocation(context, 'camera');
                  },
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 30,
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  width: width * 0.030,
                ),
              ],
            ),
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 2.5.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => Container(
                              height: height * 0.060,
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.030),
                              child: ListView.separated(
                                itemBuilder: (c, i) {
                                  return InkWell(
                                    onTap: () {
                                      if (!controller.listOfSelectedfiles
                                              .contains(controller
                                                  .listOfVidoeFilea[i]) &&
                                          controller
                                                  .listOfSelectedfiles.length <
                                              8) {
                                        controller.listOfSelectedfiles.add(
                                            controller.listOfVidoeFilea[i]);
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        height: height * 0.060,
                                        width: width * 0.120,
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: height * 0.060,
                                              width: width * 0.120,
                                              child: Thumbnails(
                                                thumb: controller
                                                        .listOfVidoeFilea[i]
                                                    ['video'],
                                              ),
                                            ),
                                            Center(
                                              child: Icon(
                                                Icons.play_circle_fill,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    width: 10,
                                  );
                                },
                                itemCount: controller.listOfVidoeFilea.length,
                              ),
                            ),
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.end,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => Container(
                              height: height * 0.060,
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.030),
                              child: ListView.separated(
                                itemBuilder: (c, i) {
                                  return InkWell(
                                    onTap: () {
                                      if (!controller.listOfSelectedfiles
                                              .contains(controller
                                                  .listOfImageFilea[i]) &&
                                          controller
                                                  .listOfSelectedfiles.length <
                                              8) {
                                        controller.listOfSelectedfiles.add(
                                            controller.listOfImageFilea[i]);
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        height: height * 0.060,
                                        width: width * 0.120,
                                        child: Image.file(
                                          File(controller.listOfImageFilea[i]
                                              ['image']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    width: 10,
                                  );
                                },
                                itemCount: controller.listOfImageFilea.length,
                              ),
                            ),
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.end,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(1.5.h)),
                          child: Column(
                            children: [
                              Expanded(
                                child: CustomScrollView(
                                  slivers: [
                                    controller.listOfSelectedfiles.isEmpty
                                        ? SliverToBoxAdapter()
                                        : SliverToBoxAdapter(
                                            child: ClipRRect(
                                              child: Container(
                                                height: height * 0.250,
                                                width: width,
                                                child: returnCard(controller
                                                    .listOfSelectedfiles[0]),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                    SliverToBoxAdapter(
                                      child: SizedBox(
                                        height: height * 0.010,
                                      ),
                                    ),
                                    SliverGrid(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                mainAxisSpacing: 5,
                                                crossAxisSpacing: 5),
                                        delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index) {
                                          Map value = controller
                                              .listOfSelectedfiles[index];
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: value.containsKey('image')
                                                ? Image.file(
                                                    File(controller
                                                            .listOfSelectedfiles[
                                                        index]['image']),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Thumbnails(
                                                    thumb: controller
                                                            .listOfSelectedfiles[
                                                        index]['video'],
                                                  ),
                                          );
                                        },
                                            childCount: controller
                                                .listOfSelectedfiles.length)),
                                    SliverToBoxAdapter(
                                      child: TextFormField(
                                        controller: descriptionController,
                                        cursorColor: Colors.black,
                                        keyboardType: TextInputType.multiline,
                                        // expands: true,
                                        minLines: 10,
                                        maxLines: 10,
                                        style: TextStyle(fontSize: 14),
                                        decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 15,
                                              bottom: 11,
                                              top: 11,
                                              right: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => AddHashTags(
                                        selectedHashTags: selectedHashTags,
                                        onAddHashTag: (List<HashTagModel>
                                            selectedHashTagList) {
                                          setState(() {
                                            selectedHashTags =
                                                selectedHashTagList;
                                            hashTags = [];
                                            selectedHashTags.forEach((element) {
                                              hashTags.add(element.hashtag);
                                            });
                                          });
                                        },
                                      ));
                                },
                                child: Container(
                                  width: 100.0.w,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  color: Colors.grey[300],
                                  child: Text(
                                    hashTags.length == 0
                                        ? '#Add Hashtags'
                                        : '${hashTags.toString().replaceAll('[', '').replaceAll(']', '')}',
                                    style:
                                        TextStyle(fontFamily: AppFonts.segoeui),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.0.w,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => AddUserTags(
                                        selectedUserTags: selectedUserTags,
                                        onAddUserTag: (List<UserTagModel>
                                            selectedUserTagList) {
                                          setState(() {
                                            selectedUserTags =
                                                selectedUserTagList;
                                            usersTags = [];
                                            usersTagsPic = [];
                                            selectedUserTags.forEach((element) {
                                              usersTags.add(element.userId);
                                              usersTagsPic
                                                  .add(element.userPicture);
                                            });
                                          });
                                        },
                                      ));
                                },
                                child: Container(
                                  width: 95.0.w,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))),
                                  child: usersTags.length == 0
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            '@Tag People',
                                            style: TextStyle(
                                                fontFamily: AppFonts.segoeui),
                                          ),
                                        )
                                      : Wrap(
                                          children: usersTagsPic
                                              .map((item) => Container(
                                                    height: 4.0.h,
                                                    width: 4.0.h,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                '$baseImageUrl$item'))),
                                                  ))
                                              .toList()
                                              .cast<Widget>(),
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.5.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //       vertical: 10, horizontal: 15),
                        //   decoration: BoxDecoration(
                        //       color: Colors.grey[400],
                        //       borderRadius: BorderRadius.circular(25)),
                        //   child: Text('Preview'),
                        // ),
                        // SizedBox(
                        //   width: 2.5.w,
                        // ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            List listofurl = [];
                            for (var i in controller.listOfSelectedfiles) {
                              Map mapdata = i;
                              String value;
                              if (mapdata.containsKey('image')) {
                                value = await createStory(i['image']);
                              } else {
                                value = await createStory(i['video']);
                              }
                              listofurl.add(value);
                            }
                            print('listofurl= $listofurl');
                            await createPost(listofurl);
                            setState(() {
                              isLoading = false;
                            });
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 40),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(25)),
                            child: Text(
                              'POST',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppFonts.segoeui),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget returnCard(Map data) {
    if (data.containsKey('image')) {
      return Image.file(
        File(data['image']),
        fit: BoxFit.cover,
      );
    } else {
      return Thumbnails(
        thumb: data['video'],
      );
    }
  }

  Future<void> createPost(List files) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    print(jsonEncode({
      "post_type": "photos",
      "user_type": "user",
      "user_id": userId,
      "privacy": "public",
      "post_description": descriptionController.text,
      "hashtag": hashTags,
      "tagusers": usersTags,
      "files": files
    }));
    final response = await http.post(Uri.parse('${baseUrl}addpostNew$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "post_type": "photos",
          "user_type": "user",
          "user_id": userId,
          "privacy": "public",
          "post_description": descriptionController.text,
          "hashtag": hashTags,
          "tagusers": usersTags,
          "files": files
        }));
    print('response is = ${response.body}');
  }
}
