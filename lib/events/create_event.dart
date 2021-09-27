import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rooya_app/models/HashTagModel.dart';
import 'package:rooya_app/models/UserTagModel.dart';
import 'package:rooya_app/rooya_post/add_hastags.dart';
import 'package:rooya_app/rooya_post/add_usertags.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/baseUrl.dart';
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

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 2.5.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: (){
                          Get.back();
                        }, icon: Icon(Icons.arrow_back)),
                       selectedValue!=4? InkWell(onTap: (){
                         setState(() {
                           ++selectedValue;
                         });
                       },

                         child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Text(
                              'NEXT',
                              style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 14.0.sp,
                                color:  Colors.white,
                              ),
                            ),
                          ),
                       ):Container()
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            image = await _picker.pickImage(
                                source: ImageSource.camera);
                            setState(() {});
                          },
                          child: Container(
                            height: 10.0.h,
                            width: 10.0.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey[400]!)),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 4.5.h,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.5.w,
                        ),
                        InkWell(
                          onTap: () async {
                            image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {});
                          },
                          child: Container(
                            height: 10.0.h,
                            width: 10.0.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey[400]!)),
                            child: Icon(
                              Icons.photo_outlined,
                              size: 4.5.h,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 2.5.w,
                    ),
                    Container(
                      height: 27.0.h,
                      width: 100.0.h,
                      margin: EdgeInsets.symmetric(horizontal: 1.0.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  'https://vanuatufm107.com/wp-content/uploads/2021/03/shutterstock_61104537504_8ef67d97-5056-a36a-0b9f5fc892eae781-1.jpg'))),
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    Container(
                      height: 10.0.h,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 10.0.h,
                              width: 10.0.h,
                              margin: EdgeInsets.symmetric(horizontal: 1.0.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          'https://vanuatufm107.com/wp-content/uploads/2021/03/shutterstock_61104537504_8ef67d97-5056-a36a-0b9f5fc892eae781-1.jpg'))),
                            );
                          }),
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
                                        fontFamily: 'Segoe UI',
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
                                        fontFamily: 'Segoe UI',
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
                                        fontFamily: 'Segoe UI',
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
                                        fontFamily: 'Segoe UI',
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
                                        fontFamily: 'Segoe UI',
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
                                  fontFamily: 'Segoe UI',
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
                                  child: Text(hashTags.length == 0
                                      ? '#Add Hashtags'
                                      : '${hashTags.toString().replaceAll('[', '').replaceAll(']', '')}'),
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
                                          child: Text('@Tag People'),
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
                                                 border: Border.all(color: Colors.black),
                                                 shape: BoxShape.circle
                                               ),
                                               child: Container(
                                                 height: 12,
                                                 width: 12,
                                                 decoration: BoxDecoration(
                                                   color: Colors.black,
                                                     border: Border.all(color: Colors.black),
                                                     shape: BoxShape.circle
                                                 ),
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
                                                    border: Border.all(color: primaryColor),
                                                    shape: BoxShape.circle
                                                ),
                                                child: Container(
                                                  height: 12,
                                                  width: 12,
                                                  decoration: BoxDecoration(
                                                      color: primaryColor,

                                                      shape: BoxShape.circle
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
                                                      hintText: 'Add Event Payment Link',
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

                                          SizedBox(height: 10.0.h,),
                                          Container(
                                            width: 60.0.w,
                                            height: 8.0.h,
                                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                                            decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: Center(
                                              child: Text('Create Event',
                                                  style: TextStyle(
                                                    fontFamily:
                                                    'Segoe UI',
                                                    fontSize: 16.0.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ),
                                          SizedBox(height: 5.0.h,),
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
