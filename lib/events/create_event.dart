import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rooya_app/events/CreateEventController.dart';
import 'package:rooya_app/models/HashTagModel.dart';
import 'package:rooya_app/models/UserTagModel.dart';
import 'package:rooya_app/rooya_post/CreatePost/add_hastags.dart';
import 'package:rooya_app/rooya_post/CreatePost/add_usertags.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:sizer/sizer.dart';

class CreateEvent extends StatefulWidget {
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

  @override
  void initState() {
    controller.getImagePath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 2.5.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            controller.selectLocation(context, 'image');
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: height * 0.060,
                              width: width * 0.120,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                                color: Colors.black38,
                              ),
                            ),
                          ),
                        ),
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
                                      if (!controller.listOfSelectedImages
                                              .contains(controller
                                                  .listOfImageFilea[i]) &&
                                          controller
                                                  .listOfSelectedImages.length <
                                              8) {
                                        controller.listOfSelectedImages.add(
                                            controller.listOfImageFilea[i]);
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        height: height * 0.060,
                                        width: width * 0.120,
                                        child: Image.file(
                                          File(controller.listOfImageFilea[i]),
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
                      height: 2.5.w,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     IconButton(
                    //         onPressed: () {
                    //           Get.back();
                    //         },
                    //         icon: Icon(Icons.arrow_back)),
                    //     selectedValue != 4
                    //         ? InkWell(
                    //             onTap: () {
                    //               setState(() {
                    //                 ++selectedValue;
                    //               });
                    //             },
                    //             child: Container(
                    //               padding: EdgeInsets.symmetric(
                    //                   horizontal: 10, vertical: 5),
                    //               decoration: BoxDecoration(
                    //                   color: primaryColor,
                    //                   borderRadius: BorderRadius.circular(20)),
                    //               child: Text(
                    //                 'NEXT',
                    //                 style: TextStyle(
                    //                   fontFamily: 'Segoe UI',
                    //                   fontSize: 14.0.sp,
                    //                   color: Colors.white,
                    //                 ),
                    //               ),
                    //             ),
                    //           )
                    //         : Container()
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     InkWell(
                    //       onTap: () async {
                    //         image = await _picker.pickImage(
                    //             source: ImageSource.camera);
                    //         setState(() {});
                    //       },
                    //       child: Container(
                    //         height: 10.0.h,
                    //         width: 10.0.h,
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(10),
                    //             border: Border.all(color: Colors.grey[400]!)),
                    //         child: Icon(
                    //           Icons.camera_alt_outlined,
                    //           size: 4.5.h,
                    //           color: Colors.black54,
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 2.5.w,
                    //     ),
                    //     InkWell(
                    //       onTap: () async {
                    //         image = await _picker.pickImage(
                    //             source: ImageSource.gallery);
                    //         setState(() {});
                    //       },
                    //       child: Container(
                    //         height: 10.0.h,
                    //         width: 10.0.h,
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(10),
                    //             border: Border.all(color: Colors.grey[400]!)),
                    //         child: Icon(
                    //           Icons.photo_outlined,
                    //           size: 4.5.h,
                    //           color: Colors.black54,
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 2.5.w,
                    // ),
                    Obx(
                      () => controller.listOfSelectedImages.isEmpty
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
                                child: Image.file(
                                  File(controller.listOfSelectedImages[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Obx(
                      () => controller.listOfSelectedImages.isNotEmpty
                          ? Container(
                              height: 10.0.h,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      controller.listOfSelectedImages.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: 10.0.h,
                                      width: 10.0.h,
                                      margin: EdgeInsets.only(right: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(
                                              '${controller.listOfSelectedImages[index]}'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          : Container(),
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
                                        selectedValue = 2;
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
                                  // controller: descriptionController,
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
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  hintText: 'Phone Number',
                                                  hintStyle: TextStyle(
                                                    fontFamily:
                                                        AppFonts.segoeui,
                                                  ),
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
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  hintText:
                                                      'Paste Google Map Location',
                                                  hintStyle: TextStyle(
                                                    fontFamily:
                                                        AppFonts.segoeui,
                                                  ),
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
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  hintText: 'Your Website',
                                                  hintStyle: TextStyle(
                                                    fontFamily:
                                                        AppFonts.segoeui,
                                                  ),
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
                                            child: Container(
                                              color: Colors.grey[200],
                                              child: TextFormField(
                                                // controller: descriptionController,
                                                cursorColor: Colors.black,
                                                keyboardType:
                                                    TextInputType.phone,
                                                readOnly: true,

                                                decoration: new InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  hintText: 'Start Date',
                                                  hintStyle: TextStyle(
                                                    fontFamily:
                                                        AppFonts.segoeui,
                                                  ),
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
                                          SizedBox(
                                            width: 2.5.w,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              color: Colors.grey[200],
                                              child: TextFormField(
                                                // controller: descriptionController,
                                                cursorColor: Colors.black,
                                                keyboardType:
                                                    TextInputType.phone,
                                                readOnly: true,

                                                decoration: new InputDecoration(
                                                  border: InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  hintText: 'End Date',
                                                  hintStyle: TextStyle(
                                                    fontFamily:
                                                        AppFonts.segoeui,
                                                  ),
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
                                    ],
                                  )
                                : selectedValue == 4
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    shape: BoxShape.circle),
                                                child: Container(
                                                  height: 12,
                                                  width: 12,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      shape: BoxShape.circle),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 3.0.w,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  color: Colors.grey[200],
                                                  child: TextFormField(
                                                    // controller: descriptionController,
                                                    cursorColor: Colors.black,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    readOnly: true,

                                                    decoration:
                                                        new InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                      hintText: 'Free',
                                                      hintStyle: TextStyle(
                                                        fontFamily:
                                                            AppFonts.segoeui,
                                                      ),
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
                                              SizedBox(
                                                width: 2.5.w,
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: primaryColor),
                                                    shape: BoxShape.circle),
                                                child: Container(
                                                  height: 12,
                                                  width: 12,
                                                  decoration: BoxDecoration(
                                                      color: primaryColor,
                                                      shape: BoxShape.circle),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.5.w,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  color: Colors.grey[200],
                                                  child: TextFormField(
                                                    // controller: descriptionController,
                                                    cursorColor: Colors.black,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    readOnly: true,

                                                    decoration:
                                                        new InputDecoration(
                                                      border: InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                      disabledBorder:
                                                          InputBorder.none,
                                                      hintText: 'Paid',
                                                      hintStyle: TextStyle(
                                                        fontFamily:
                                                            AppFonts.segoeui,
                                                      ),
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
                                                      disabledBorder:
                                                          InputBorder.none,
                                                      hintText:
                                                          'Add Event Payment Link',
                                                      hintStyle: TextStyle(
                                                        fontFamily:
                                                            AppFonts.segoeui,
                                                      ),
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
                                          Container(
                                            width: 60.0.w,
                                            height: 8.0.h,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 7),
                                            decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                              child: Text('Create Event',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.segoeui,
                                                    fontSize: 16.0.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  )),
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
}
