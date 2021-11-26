import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';
import 'package:rooya_app/CreateSouq/RooyaSouqController.dart';
import 'package:rooya_app/dashboard/BottomSheet/BottomSheet.dart';
import 'package:rooya_app/models/FileUploadModel.dart';
import 'package:rooya_app/models/HashTagModel.dart';
import 'package:rooya_app/models/RooyaCategoryModel.dart';
import 'package:rooya_app/rooya_post/CreatePost/add_hastags.dart';
import 'package:rooya_app/story/uploadStroy.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/widgets/EditImageGlobal.dart';
import 'package:rooya_app/widgets/FileUpload.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class CreateSouq extends StatefulWidget {
  @override
  _CreateSouqState createState() => _CreateSouqState();
}

class _CreateSouqState extends State<CreateSouq> {
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  int _groupValue = 0;
  int selectedImageIndex = 0;
  List<HashTagModel> selectedHashTags = [];
  List hashTags = [];
  List<RooyaCategoryModel> mRooyaCatList = [];
  RooyaCategoryModel? selectedCat;
  List<FileUploadModel> mPic = [];
  var postAttachments = [];
  bool isError = false;
  String errorMsg = '';
  bool isUploading = false;

  TextEditingController mTitleController = TextEditingController();
  TextEditingController mDescriptionController = TextEditingController();
  TextEditingController mPriceController = TextEditingController();
  final controller = Get.put(RooyaSouqController());

  @override
  void initState() {
    // TODO: implement initState
    controller.getImagePath();
    getRooyaCat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        var map = controller.listOfSelectedImages.removeAt(oldIndex);
        controller.listOfSelectedImages.insert(newIndex, map);
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
                'Create Souq',
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
                    //  controller.selectLocation(context);
                    controller.onImageButtonPressed(
                        ImageSource.camera, 'image');
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
                              width: width,
                              child: ReorderableRow(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                    controller.listOfSelectedImages.length,
                                    (index) {
                                  return Container(
                                    height: 10.0.h,
                                    width: 10.0.h,
                                    key: UniqueKey(),
                                    margin: EdgeInsets.only(right: 10),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 10.0.h,
                                          width: 10.0.h,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              File(
                                                  '${controller.listOfSelectedImages[index]}'),
                                              fit: BoxFit.cover,
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
                                              controller.listOfSelectedImages
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
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (c) =>
                                                          EditImageGlobal(
                                                            path: controller
                                                                    .listOfSelectedImages[
                                                                index],
                                                          ))).then((value) {
                                                if (value.toString().length >
                                                    5) {
                                                  controller
                                                          .listOfSelectedImages[
                                                      index] = '$value';
                                                  setState(() {});
                                                }
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                                onReorder: _onReorder,
                              ),
                            )
                          : Container(),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextFormField(
                        controller: mTitleController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Title',
                          hintStyle: TextStyle(
                              fontFamily: AppFonts.segoeui, fontSize: 14),
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextFormField(
                        controller: mDescriptionController,
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
                              fontFamily: AppFonts.segoeui, fontSize: 14),
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Container(
                      // width: 30.0.w,
                      //  height: 5.0.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey[200],
                      ),
                      child: Center(
                        child: DropdownButtonFormField<RooyaCategoryModel>(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 2.0.w),
                            enabledBorder: InputBorder.none,
                          ),
                          isExpanded: true,
                          iconEnabledColor: primaryColor,
                          iconSize: 3.0.h,
                          itemHeight: kMinInteractiveDimension,
                          items: mRooyaCatList.map((RooyaCategoryModel value) {
                            return new DropdownMenuItem(
                              value: value,
                              child: new Text(
                                value.categoryName!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: AppFonts.segoeui, fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            setState(() {
                              selectedCat = value;
                            });
                          },
                          style:
                              TextStyle(fontSize: 12.0.sp, color: Colors.black),
                          value: selectedCat,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => AddHashTags(
                              selectedHashTags: selectedHashTags,
                              onAddHashTag:
                                  (List<HashTagModel> selectedHashTagList) {
                                setState(() {
                                  selectedHashTags = selectedHashTagList;
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
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.grey[200],
                        ),
                        child: Text(
                          hashTags.length == 0
                              ? '#Add Hashtags'
                              : '${hashTags.toString().replaceAll('[', '').replaceAll(']', '')}',
                          style: TextStyle(
                              fontFamily: AppFonts.segoeui, fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextFormField(
                        controller: mPriceController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Price',
                          hintStyle: TextStyle(
                              fontFamily: AppFonts.segoeui, fontSize: 14),
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Container(
                      width: 100.0.h,
                      // height: 7.0.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.0.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey[200],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Condition',
                              style: TextStyle(
                                fontFamily: AppFonts.segoeui,
                                fontSize: 12.0.sp,
                                color: const Color(0xff5a5a5a),
                              )),
                          Expanded(
                            flex: 1,
                            child: RadioListTile(
                              value: 0,
                              groupValue: _groupValue,
                              activeColor: primaryColor,
                              onChanged: (newValue) =>
                                  setState(() => {_groupValue = 0}),
                              title: Text(
                                'New',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 10,
                                  color: const Color(0xff222222),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: RadioListTile(
                              value: 1,
                              groupValue: _groupValue,
                              activeColor: primaryColor,
                              onChanged: (newValue) =>
                                  setState(() => {_groupValue = 1}),
                              title: Text(
                                'Used',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 10,
                                  color: const Color(0xff222222),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3.0.h,
                    ),
                    InkWell(
                      onTap: () async {
                        if (controller.listOfSelectedImages.isNotEmpty) {
                          if (mTitleController.text.isNotEmpty) {
                            if (mDescriptionController.text.isNotEmpty) {
                              if (mPriceController.text.isNotEmpty) {
                                setState(() {
                                  isLoading = true;
                                });
                                List listofurl = [];
                                for (var i in controller.listOfSelectedImages) {
                                  String value = await createStory(i);
                                  listofurl.add(value);
                                }
                                print('listofurl= $listofurl');
                                await createRooyaSouq(listofurl);
                                setState(() {
                                  isLoading = false;
                                });
                                Get.snackbar('Saved', 'Product saved');
                                Future.delayed(Duration(seconds: 2), () {
                                  Get.offAll(() => BottomSheetCustom());
                                });
                              } else {
                                Get.snackbar(
                                    'Required', 'Please enter product price');
                              }
                            } else {
                              Get.snackbar('Required',
                                  'Please enter product description');
                            }
                          } else {
                            Get.snackbar(
                                'Required', 'Please enter product title');
                          }
                        } else {
                          Get.snackbar(
                              'Required', 'Please select atleast one image');
                        }
                      },
                      child: Container(
                        width: 50.0.w,
                        height: 6.0.h,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text('POST',
                              style: TextStyle(
                                fontFamily: AppFonts.segoeui,
                                fontSize: 13.0.sp,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> getRooyaCat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}getSouqCat${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({"page_size": 100, "page_number": 0}));

    print(response.request);
    print(response.statusCode);
    // print(response.body);
    log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
          mRooyaCatList = List<RooyaCategoryModel>.from(
              data['data'].map((model) => RooyaCategoryModel.fromJson(model)));
          selectedCat = mRooyaCatList[0];
        });
      } else {
        setState(() {});
      }
    }
  }

  Future<void> createRooyaSouq(List listofURL) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String? userId = await prefs.getString('user_id');
    final response = await http.post(
        Uri.parse('${baseUrl}postSouqProduct${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "post_type": "product",
          "user_type": "user",
          "user_id": userId,
          "privacy": "public",
          "product_name": '${mTitleController.text}',
          "post_description": '${mDescriptionController.text}',
          "price": mPriceController.text,
          "category_id": selectedCat!.categoryId,
          "status": _groupValue == 0 ? "new" : "used",
          "location": "Dubai",
          "featured": 1,
          "files": listofURL
        }));

    setState(() {
      isLoading = false;
    });

    print(response.request);
    print(response.statusCode);
    // print(response.body);
    log(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
      } else {
        setState(() {});
      }
    }
  }
}
