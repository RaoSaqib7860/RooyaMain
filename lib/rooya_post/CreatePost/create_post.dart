import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';
import 'package:rooya_app/Screens/Reel/ReelCamera/ReelCamera.dart';
import 'package:rooya_app/dashboard/BottomSheet/BottomSheet.dart';
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
import 'package:rooya_app/utils/SnackbarCustom.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/widgets/EditImageGlobal.dart';
import 'package:rooya_app/widgets/VideoTrimGlobal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

String newPathis = '';

class CreatePost extends StatefulWidget {
  final bool? fromEvent;
  final String? event_id;

  const CreatePost({this.fromEvent = false, this.event_id = '0'});

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

  String dropDownValue = 'Public';

  @override
  void initState() {
    controller.getImagePath();
    controller.getVideoPath();
    controller.getFilesPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Map map = controller.listOfSelectedfiles.removeAt(oldIndex);
        controller.listOfSelectedfiles.insert(newIndex, map);
      });
      setState(() {});
    }

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
                widget.fromEvent! ? 'Create Event' : 'Create Post',
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
                    controller.gallarypress();
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
                    // controller.selectLocation(context);
                    Get.to(CameraApp())!.then((value) {
                      print('path is = $newPathis');
                      if (newPathis.isNotEmpty) {
                        if (newPathis.contains('mp4')) {
                          if (!controller.listOfSelectedfiles
                              .contains('$newPathis')) {
                            controller.listOfSelectedfiles
                                .add({'video': '$newPathis'});
                          }
                        } else {
                          if (!controller.listOfSelectedfiles
                              .contains('$newPathis')) {
                            controller.listOfSelectedfiles
                                .add({'image': '$newPathis'});
                          }
                        }
                        newPathis = '';
                      }
                    });
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
                                    SliverToBoxAdapter(
                                      child: Container(
                                        width: width,
                                        child: ReorderableRow(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: List.generate(
                                              controller.listOfSelectedfiles
                                                  .length, (index) {
                                            Map value = controller
                                                .listOfSelectedfiles[index];
                                            return Container(
                                              key: UniqueKey(),
                                              height: 10.0.h,
                                              width: 10.0.h,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: 10.0.h,
                                                    width: 10.0.h,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: value.containsKey(
                                                              'image')
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
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: InkWell(
                                                      child: Icon(
                                                        Icons.cancel,
                                                        color: primaryColor,
                                                      ),
                                                      onTap: () {
                                                        controller
                                                            .listOfSelectedfiles
                                                            .removeAt(index);
                                                      },
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: InkWell(
                                                      child: Container(
                                                        child: Icon(
                                                          Icons.edit,
                                                          size: 15,
                                                          color: primaryColor,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                shape: BoxShape
                                                                    .circle),
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        margin:
                                                            EdgeInsets.all(3),
                                                      ),
                                                      onTap: () {
                                                        if (value.containsKey(
                                                            'image')) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (c) =>
                                                                      EditImageGlobal(
                                                                        path: controller.listOfSelectedfiles[index]
                                                                            [
                                                                            'image'],
                                                                      ))).then(
                                                              (value) {
                                                            if (value
                                                                    .toString()
                                                                    .length >
                                                                5) {
                                                              controller
                                                                      .listOfSelectedfiles[
                                                                  index] = {
                                                                'image':
                                                                    '$value'
                                                              };
                                                              setState(() {});
                                                            }
                                                          });
                                                        } else {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (c) =>
                                                                      TrimmerViewGlobal(
                                                                        file: File(controller.listOfSelectedfiles[index]
                                                                            [
                                                                            'video']),
                                                                      ))).then(
                                                              (value) {
                                                            if (value
                                                                    .toString()
                                                                    .length >
                                                                5) {
                                                              controller
                                                                      .listOfSelectedfiles[
                                                                  index] = {
                                                                'video':
                                                                    '$value'
                                                              };
                                                              setState(() {});
                                                            }
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          }),
                                          onReorder: _onReorder,
                                        ),
                                      ),
                                    ),
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
                        Expanded(
                          child: Container(
                            height: height * 0.050,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.050),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[300]),
                            child: DropdownButton<String>(
                              items: <String>[
                                'Public',
                                'My Followers',
                                'Only Me'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: AppFonts.segoeui),
                                  ),
                                );
                              }).toList(),
                              underline: SizedBox(),
                              isExpanded: true,
                              hint: Text(
                                '$dropDownValue',
                                style: TextStyle(
                                    fontSize: 12, fontFamily: AppFonts.segoeui),
                              ),
                              onChanged: (value) {
                                dropDownValue = value!;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.050,
                        ),
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
                            if (!widget.fromEvent!) {
                              snackBarSuccess('Create post successfully');
                            } else {
                              snackBarSuccess('Create Event successfully');
                            }
                            Future.delayed(Duration(seconds: 2), () {
                              Get.offAll(() => BottomSheetCustom());
                            });
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
    print('$userId and $hashTags and $usersTags');
    // print(jsonEncode({
    //   "post_type": "photos",
    //   "user_type": "user",
    //   "user_id": userId,
    //   "privacy": dropDownValue == 'Public' ? "public" :dropDownValue == 'My Followers'?'friends': "me",
    //   "post_description": descriptionController.text,
    //   "hashtag": hashTags,
    //   "tagusers": usersTags,
    //   "files": files
    // }));
    final response = await http.post(
        Uri.parse(
            '${baseUrl}${widget.fromEvent! ? 'addpostNewEvent' : 'addpostNew'}$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: widget.fromEvent!
            ? jsonEncode({
                "post_type": "photos",
                "user_type": "user",
                "event_id": widget.event_id,
                "in_event": "1",
                "user_id": int.parse(userId!),
                "privacy": dropDownValue == 'Public'
                    ? "public"
                    : dropDownValue == 'My Followers'
                        ? 'friends'
                        : "me",
                "post_description": descriptionController.text,
                "hashtag": hashTags,
                "tagusers": usersTags,
                "files": files
              })
            : jsonEncode({
                "post_type": "photos",
                "user_type": "user",
                "user_id": int.parse(userId!),
                "privacy": dropDownValue == 'Public'
                    ? "public"
                    : dropDownValue == 'My Followers'
                        ? 'friends'
                        : "me",
                "post_description": descriptionController.text,
                "hashtag": hashTags,
                "tagusers": usersTags,
                "files": files
              }));
    print('response is = ${response.body}');
  }
}
