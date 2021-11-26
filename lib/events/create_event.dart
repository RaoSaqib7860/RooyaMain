import 'dart:convert';
import 'dart:io';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';
import 'package:rooya_app/Screens/Reel/ReelCamera/ReelCamera.dart';
import 'package:rooya_app/events/CreateEventController.dart';
import 'package:rooya_app/models/HashTagModel.dart';
import 'package:rooya_app/models/UserTagModel.dart';
import 'package:rooya_app/rooya_post/CreatePost/add_hastags.dart';
import 'package:rooya_app/rooya_post/CreatePost/add_usertags.dart';
import 'package:rooya_app/rooya_post/CreatePost/create_post.dart';
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

class CreateEvent extends StatefulWidget {
  final String? eventID;

  const CreateEvent({Key? key, this.eventID}) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  int selectedValue = 0;

  List<HashTagModel> selectedHashTags = [];
  List<UserTagModel> selectedUserTags = [];
  List hashTags = [];
  List usersTags = [];
  List usersTagsPic = [];
  final controller = Get.put(CreateEventController());
  TextEditingController descriptionController = TextEditingController();
  TextEditingController eventDisciptionCon = TextEditingController();
  TextEditingController eventTitleCon = TextEditingController();
  TextEditingController locationCon = TextEditingController();
  TextEditingController startDateCon = TextEditingController();
  TextEditingController endDateCon = TextEditingController();
  bool isPublic = true;

  @override
  void initState() {
    controller.getImagePath();
    controller.getVideoPath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Map map = controller.listOfSelectedfiles.removeAt(oldIndex);
        controller.listOfSelectedfiles.insert(newIndex, map);
      });
      setState(() {});
    }

    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Create Event',
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
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 2.5.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                                        setState(() {});
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
                                        // int index = controller
                                        //     .listOfSelectedfiles
                                        //     .indexOf(
                                        //         controller.listOfImageFilea[i]);
                                        // Map value = controller
                                        //     .listOfSelectedfiles[index];
                                        // controller.rows.add();
                                        setState(() {});
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
                    Obx(
                      () => controller.listOfSelectedfiles.isEmpty
                          ? Container(
                              height: 27.0.h,
                              width: 100.0.h,
                              child: Icon(
                                Icons.image,
                                color: Colors.black38,
                                size: 50,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 1.0.w),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black38),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                          : Container(
                              height: 27.0.h,
                              width: 100.0.h,
                              margin: EdgeInsets.symmetric(horizontal: 1.0.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey[200]!)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: returnCard(
                                    controller.listOfSelectedfiles[0]),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Container(
                      width: width,
                      child: ReorderableRow(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(controller
                            .listOfSelectedfiles.length, (index){
                          Map value = controller
                              .listOfSelectedfiles[index];
                          return Container(
                            key: UniqueKey(),
                            height: 10.0.h,
                            width: 10.0.h,
                            margin: EdgeInsets.only(right: 10),
                            child: Stack(
                              children: [
                                Container(
                                  height: 10.0.h,
                                  width: 10.0.h,
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child:
                                    value.containsKey('image')
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
                                  alignment: Alignment.topRight,
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
                                  alignment: Alignment.topLeft,
                                  child: InkWell(
                                    child: Container(
                                      child: Icon(
                                        Icons.edit,
                                        size: 15,
                                        color: primaryColor,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      padding: EdgeInsets.all(3),
                                      margin: EdgeInsets.all(3),
                                    ),
                                    onTap: () {
                                      if (value
                                          .containsKey('image')) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) =>
                                                    EditImageGlobal(
                                                      path: controller
                                                          .listOfSelectedfiles[index]
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
                                                  'image': '$value'
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
                                                      file: File(controller
                                                          .listOfSelectedfiles[index]
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
                                                  'video': '$value'
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
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = 0;
                                      });
                                    },
                                    child: Text(
                                      'LIVE',
                                      style: TextStyle(
                                        fontFamily: AppFonts.segoeui,
                                        fontSize: 9.0.sp,
                                        fontWeight: FontWeight.w600,
                                        color: selectedValue == 0
                                            ? primaryColor
                                            : Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: 1,
                                  height: 2.0.h,
                                  color: Colors.grey[500],
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = 1;
                                      });
                                    },
                                    child: Text(
                                      'BRIEF',
                                      style: TextStyle(
                                        fontFamily: AppFonts.segoeui,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9.0.sp,
                                        color: selectedValue == 1
                                            ? primaryColor
                                            : Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: 1,
                                  height: 2.0.h,
                                  color: Colors.grey[500],
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = 3;
                                      });
                                    },
                                    child: Text(
                                      'FACILITIES',
                                      style: TextStyle(
                                        fontFamily: AppFonts.segoeui,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9.0.sp,
                                        color: selectedValue == 2
                                            ? primaryColor
                                            : Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: 1,
                                  height: 2.0.h,
                                  color: Colors.grey[500],
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = 3;
                                      });
                                    },
                                    child: Text(
                                      'LOCATION AND TIME',
                                      style: TextStyle(
                                        fontFamily: AppFonts.segoeui,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9.0.sp,
                                        color: selectedValue == 3
                                            ? primaryColor
                                            : Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                Container(
                                  width: 1,
                                  height: 2.0.h,
                                  color: Colors.grey[500],
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedValue = 4;
                                      });
                                    },
                                    child: Text(
                                      'ATTEND',
                                      style: TextStyle(
                                        fontFamily: AppFonts.segoeui,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9.0.sp,
                                        color: selectedValue == 4
                                            ? primaryColor
                                            : Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    selectedValue == 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User will view live Event and Rooya Post with below information',
                                style: TextStyle(
                                  fontFamily: AppFonts.segoeui,
                                  fontSize: 9.0.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 4.0.w,
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
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.grey[300]!,
                                  )),
                                  child: Text(
                                    hashTags.length == 0
                                        ? '#Add Hashtags'
                                        : '${hashTags.toString().replaceAll('[', '').replaceAll(']', '')}',
                                    style: TextStyle(
                                      fontFamily: AppFonts.segoeui,
                                      fontSize: 12.0.sp,
                                      color: Colors.black,
                                    ),
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
                                  width: 100.0.w,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.grey[300]!,
                                  )),
                                  child: usersTags.length == 0
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            '@Tag People',
                                            style: TextStyle(
                                              fontFamily: AppFonts.segoeui,
                                              fontSize: 12.0.sp,
                                              color: Colors.black,
                                            ),
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
                          )
                        : selectedValue == 1
                            ? Container(
                                color: Colors.grey[200],
                                child: TextFormField(
                                  controller: descriptionController,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.multiline,
                                  // expands: true,
                                  minLines: 5,
                                  maxLines: 10,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: 'Description',
                                    hintStyle: TextStyle(
                                      fontFamily: AppFonts.segoeui,
                                      fontSize: 12.0.sp,
                                      color: Colors.black,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                  ),
                                ),
                              )
                            : selectedValue == 3
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/call.png',
                                            height: 2.0.h,
                                            width: 2.0.h,
                                          ),
                                          SizedBox(
                                            width: 3.0.w,
                                          ),
                                          Expanded(
                                            child: Container(
                                              color: Colors.grey[200],
                                              child: TextFormField(
                                                // controller: descriptionController,
                                                cursorColor: Colors.black,
                                                keyboardType:
                                                    TextInputType.phone,
                                                // expands: true,

                                                decoration: new InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  hintStyle: TextStyle(
                                                    fontFamily:
                                                        AppFonts.segoeui,
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  hintText: 'Phone Number',
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 15,
                                                          bottom: 11,
                                                          top: 11,
                                                          right: 15),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2.0.h,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/location.png',
                                            height: 2.0.h,
                                            width: 2.0.h,
                                          ),
                                          SizedBox(
                                            width: 3.0.w,
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                openGoogleDailog();
                                              },
                                              child: Container(
                                                color: Colors.grey[200],
                                                child: TextFormField(
                                                  controller: locationCon,
                                                  cursorColor: Colors.black,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  // expands: true,
                                                  enabled: false,
                                                  decoration:
                                                      new InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    hintStyle: TextStyle(
                                                      fontFamily:
                                                          AppFonts.segoeui,
                                                      fontSize: 12.0.sp,
                                                      color: Colors.black,
                                                    ),
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    hintText:
                                                        'Paste Google Map Location',
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 15,
                                                            bottom: 11,
                                                            top: 11,
                                                            right: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2.0.h,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/globe.png',
                                            height: 3.0.h,
                                            width: 3.0.h,
                                          ),
                                          SizedBox(
                                            width: 3.0.w,
                                          ),
                                          Expanded(
                                            child: Container(
                                              color: Colors.grey[200],
                                              child: TextFormField(
                                                // controller: descriptionController,
                                                cursorColor: Colors.black,
                                                keyboardType:
                                                    TextInputType.phone,
                                                // expands: true,

                                                decoration: new InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  hintStyle: TextStyle(
                                                    fontFamily:
                                                        AppFonts.segoeui,
                                                    fontSize: 12.0,
                                                    color: Colors.black,
                                                  ),
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  hintText: 'Your Website',
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 15,
                                                          bottom: 11,
                                                          top: 11,
                                                          right: 15),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2.0.h,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/icons/calender.png',
                                            height: 3.0.h,
                                            width: 3.0.h,
                                          ),
                                          SizedBox(
                                            width: 3.0.w,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                DatePicker.showDatePicker(
                                                    context,
                                                    showTitleActions: true,
                                                    minTime: DateTime.now(),
                                                    maxTime:
                                                        DateTime(2050, 6, 7),
                                                    theme: DatePickerTheme(
                                                        headerColor:
                                                            primaryColor,
                                                        backgroundColor:
                                                            Colors.white,
                                                        itemStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12),
                                                        doneStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12)),
                                                    onConfirm: (date) {
                                                  print(
                                                      'confirm ${DateTime.now()}');
                                                  startDateCon.text =
                                                      '${date.toString().split(' ')[0]}' +
                                                          ' ${DateTime.now().toString().split(' ')[1].split('.')[0]}:00';
                                                },
                                                    currentTime: DateTime.now(),
                                                    locale: LocaleType.en);
                                              },
                                              child: Container(
                                                color: Colors.grey[200],
                                                child: TextFormField(
                                                  controller: startDateCon,
                                                  cursorColor: Colors.black,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  readOnly: true,
                                                  enabled: false,
                                                  decoration:
                                                      new InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    hintStyle: TextStyle(
                                                      fontFamily:
                                                          AppFonts.segoeui,
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    hintText: 'Start Date',
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 15,
                                                            bottom: 11,
                                                            top: 11,
                                                            right: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2.5.w,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                DatePicker.showDatePicker(
                                                    context,
                                                    showTitleActions: true,
                                                    minTime: DateTime.now(),
                                                    maxTime:
                                                        DateTime(2050, 6, 7),
                                                    theme: DatePickerTheme(
                                                        headerColor:
                                                            primaryColor,
                                                        backgroundColor:
                                                            Colors.white,
                                                        itemStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12),
                                                        doneStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12)),
                                                    onConfirm: (date) {
                                                  print(
                                                      'confirm ${DateTime.now()}');
                                                  endDateCon.text =
                                                      '${date.toString().split(' ')[0]}' +
                                                          ' ${DateTime.now().toString().split(' ')[1].split('.')[0]}:00';
                                                },
                                                    currentTime: DateTime.now(),
                                                    locale: LocaleType.en);
                                              },
                                              child: Container(
                                                color: Colors.grey[200],
                                                child: TextFormField(
                                                  controller: endDateCon,
                                                  cursorColor: Colors.black,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  readOnly: true,
                                                  enabled: false,
                                                  decoration:
                                                      new InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    hintStyle: TextStyle(
                                                      fontFamily:
                                                          AppFonts.segoeui,
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    hintText: 'End Date',
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 15,
                                                            bottom: 11,
                                                            top: 11,
                                                            right: 15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : selectedValue == 4
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.privacy_tip_outlined,
                                                color: Colors.black,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 3.0.w,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isPublic = true;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: height * 0.055,
                                                    padding: EdgeInsets.only(
                                                        left: 15, right: 15),
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: TextFormField(
                                                      // controller: descriptionController,
                                                      cursorColor: Colors.black,
                                                      readOnly: true,
                                                      enabled: false,
                                                      decoration:
                                                          new InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        disabledBorder:
                                                            InputBorder.none,
                                                        hintText: 'Public',
                                                        isDense: true,
                                                        hintStyle: TextStyle(
                                                            fontFamily: AppFonts
                                                                .segoeui,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 3.0.w,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isPublic = true;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: isPublic
                                                              ? primaryColor
                                                              : Colors.black),
                                                      shape: BoxShape.circle),
                                                  child: Container(
                                                    height: 12,
                                                    width: 12,
                                                    decoration: BoxDecoration(
                                                      color: isPublic
                                                          ? primaryColor
                                                          : Colors.black,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.5.w,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isPublic = false;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 15, right: 15),
                                                    height: height * 0.055,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: TextFormField(
                                                      // controller: descriptionController,
                                                      cursorColor: Colors.black,
                                                      readOnly: true,
                                                      enabled: false,
                                                      decoration:
                                                          new InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        isDense: true,
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        disabledBorder:
                                                            InputBorder.none,
                                                        hintText: 'Private',
                                                        hintStyle: TextStyle(
                                                            fontFamily: AppFonts
                                                                .segoeui,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.5.w,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isPublic = false;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: !isPublic
                                                              ? primaryColor
                                                              : Colors.black),
                                                      shape: BoxShape.circle),
                                                  child: Container(
                                                    height: 12,
                                                    width: 12,
                                                    decoration: BoxDecoration(
                                                      color: !isPublic
                                                          ? primaryColor
                                                          : Colors.black,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2.0.h,
                                          ),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/icons/globe.png',
                                                height: 3.0.h,
                                                width: 3.0.h,
                                              ),
                                              SizedBox(
                                                width: 3.0.w,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  color: Colors.grey[200],
                                                  child: TextFormField(
                                                    // controller: descriptionController,
                                                    cursorColor: Colors.black,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    // expands: true,

                                                    decoration:
                                                        new InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      hintStyle: TextStyle(
                                                        fontFamily:
                                                            AppFonts.segoeui,
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                      ),
                                                      disabledBorder:
                                                          InputBorder.none,
                                                      hintText:
                                                          'Add Event Payment Link',
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 15,
                                                              bottom: 11,
                                                              top: 11,
                                                              right: 15),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.0.h,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              if (controller.listOfSelectedfiles
                                                  .isNotEmpty) {
                                                if (descriptionController.text
                                                    .trim()
                                                    .isNotEmpty) {
                                                  if (startDateCon.text
                                                      .trim()
                                                      .isNotEmpty) {
                                                    if (endDateCon.text
                                                        .trim()
                                                        .isNotEmpty) {
                                                      if (locationCon.text
                                                          .trim()
                                                          .isNotEmpty) {
                                                        print(
                                                            'listOfSelectedImages = ${controller.listOfSelectedfiles}');
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        List listofurl = [];
                                                        for (var i in controller
                                                            .listOfSelectedfiles) {
                                                          Map mapdata = i;
                                                          String value;
                                                          if (mapdata
                                                              .containsKey(
                                                                  'image')) {
                                                            value =
                                                                await createStory(
                                                                    i['image']);
                                                          } else {
                                                            value =
                                                                await createStory(
                                                                    i['video']);
                                                          }
                                                          listofurl.add(value);
                                                        }
                                                        print(
                                                            'listofurl= $listofurl');
                                                        await createEvent(
                                                            listofurl);
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                        snackBarSuccess(
                                                            'Create Event successfully');
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 2),
                                                            () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      } else {
                                                        snackBarFailer(
                                                            'Please Select location of event');
                                                      }
                                                    } else {
                                                      snackBarFailer(
                                                          'Select end Date first');
                                                    }
                                                  } else {
                                                    snackBarFailer(
                                                        'Select start Date first');
                                                  }
                                                } else {
                                                  snackBarFailer(
                                                      'Please enter Description');
                                                }
                                              } else {
                                                snackBarFailer(
                                                    'Please select image first');
                                              }
                                            },
                                            child: Container(
                                              width: 60.0.w,
                                              height: 5.0.h,
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Center(
                                                child: Text('Create Event',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.segoeui,
                                                      fontSize: 12.0.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0.h,
                                          ),
                                        ],
                                      )
                                    : Container()
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> createEvent(List files) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('user_id');
    String? token = await prefs.getString('token');
    print('$userId and $hashTags and $usersTags');

    final response = await http.post(
        Uri.parse('${baseUrl}addpostNewEvent$code'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "post_type": "photos",
          "event_id": int.parse(widget.eventID!),
          "user_type": "user",
          "user_id": int.parse(userId!),
          "privacy": "custom",
          "post_description": descriptionController.text,
          "hashtag": hashTags,
          "tagusers": usersTags,
          "files": files
        }));
    print('response is = ${response.body}');
  }

  openGoogleDailog() async {
    Position? position = await Geolocator.getLastKnownPosition();
    final kInitialPosition = LatLng(position!.latitude, position.longitude);
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return LayoutBuilder(builder: (c, size) {
            var height = size.maxHeight;
            var width = size.maxWidth;
            return SafeArea(
              child: Scaffold(
                appBar: PreferredSize(
                    child: Container(
                      height: height * 0.070,
                      width: width,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 20,
                                color: primaryColor,
                              )),
                          Padding(
                            padding: EdgeInsets.only(right: width * 0.080),
                            child: Text(
                              'Sender Location'.tr,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox()
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.blue.withOpacity(0.20),
                            offset: Offset(0, 3),
                            blurRadius: 5),
                      ], color: primaryColor),
                    ),
                    preferredSize: Size.fromHeight(height * 0.070)),
                body: Container(
                  width: Get.width,
                  height: Get.height,
                  color: Colors.white,
                  child: PlacePicker(
                    apiKey: 'AIzaSyBKWeZRXoG7tZskLBKYTbjWh0xac0mZZAk',
                    initialPosition: kInitialPosition,
                    useCurrentLocation: true,
                    autocompleteLanguage: 'en_US',
                    searchingText: 'Search place here'.tr,
                    onMapCreated: (GoogleMapController controller) {},
                    selectInitialPosition: true,
                    enableMapTypeButton: true,
                    hidePlaceDetailsWhenDraggingPin: false,
                    usePlaceDetailSearch: true,
                    automaticallyImplyAppBarLeading: false,
                    onPlacePicked: (result) async {
                      locationCon.text = result.formattedAddress!;
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  ),
                ),
              ),
            );
          });
        });
  }
}
