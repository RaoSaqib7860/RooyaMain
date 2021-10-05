import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rooya_app/models/FileUploadModel.dart';
import 'package:rooya_app/models/HashTagModel.dart';
import 'package:rooya_app/models/RooyaCategoryModel.dart';
import 'package:rooya_app/rooya_post/add_hastags.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/colors.dart';
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
  int selectedImageIndex=0;
  List<HashTagModel> selectedHashTags = [];
  List hashTags = [];
List<RooyaCategoryModel> mRooyaCatList=[];
  RooyaCategoryModel? selectedCat;
  List<FileUploadModel> mPic = [];
  var postAttachments = [];
  bool isError = false;
  String errorMsg = '';
  bool isUploading= false;

  TextEditingController mTitleController = TextEditingController();
  TextEditingController mDescriptionController = TextEditingController();
  TextEditingController mPriceController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getRooyaCat();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child:Scaffold(
          // appBar: AppBar(
          //   elevation: 0,
          //   automaticallyImplyLeading: true,
          //   backgroundColor: Colors.white,
          //   iconTheme: IconThemeData(
          //       color: Colors.black
          //   ),
          // ),
      body: SafeArea(
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 2.5.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){
                      Get.back();
                    }, icon: Icon(Icons.arrow_back)),

                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        image = await _picker.pickImage(
                            source: ImageSource.camera);
                        setState(() {
                          mPic.add(FileUploadModel(
                              File(image!.path),'', false, false));
                        });
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
                        setState(() {
                          mPic.add(FileUploadModel(
                              File(image!.path), '',false, false));
                        });
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
                mPic.length>0? Container(
                  height: 27.0.h,
                  width: 100.0.h,
                  margin: EdgeInsets.symmetric(horizontal: 1.0.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(mPic[selectedImageIndex].file))),
                ):Container(
                  height: 27.0.h,
                  width: 100.0.h,
                  margin: EdgeInsets.symmetric(horizontal: 1.0.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[200]!)
                      ),
                  child: Center(
                    child: Icon(Icons.photo_outlined,color: Colors.grey[300],size: 5.0.h,),
                  ),
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                mPic.length>0?  Container(
                  height: 10.0.h,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: mPic.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            setState(() {
                              selectedImageIndex=index;
                            });
                          },
                          child: Container(
                            margin:  EdgeInsets.only(right: 2.0.w),
                            child: FileUpload(
                              height: 10.0.h,
                              width: 10.0.h,
                              progressRadius: 4.0.h,
                              progressLineWidth: 1.0.w,
                              fileUploadModel: mPic[index],
                              onRemove:
                                  (FileUploadModel fileUploadModel) {
                                setState(() {
                                  mPic.remove(fileUploadModel);
                                  // if(postAttachments.length>0)
                                  // {
                                  //   postAttachments.removeWhere((element) => element['fileName']==basename(fileUploadModel.file.path));
                                  //
                                  //
                                  // }
                                });
                              },
                              onComplete: (String response) {
                              print(response);
                             setState(() {
                               mPic[index].fileUrl=response;
                             });
                              },
                            ),
                          ),
                        );
                      }),
                ):Container(),
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
                      contentPadding: EdgeInsets.only(
                          left: 15,
                          bottom: 11,
                          top: 11,
                          right: 15),
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
                      contentPadding: EdgeInsets.only(
                          left: 15,
                          bottom: 11,
                          top: 11,
                          right: 15),
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
                          child: new Text(value.categoryName!,overflow: TextOverflow.ellipsis,),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        setState(() {
                          selectedCat=value;
                        });
                      },
                      style: TextStyle(fontSize: 12.0.sp,color: Colors.black),
                      value:selectedCat ,
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
                        vertical: 15, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.grey[200],

                      ),
                    child: Text(hashTags.length == 0
                        ? '#Add Hashtags'
                        : '${hashTags.toString().replaceAll('[', '').replaceAll(']', '')}'),
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
                      contentPadding: EdgeInsets.only(
                          left: 15,
                          bottom: 11,
                          top: 11,
                          right: 15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.5.h,
                ),
                Container(
                  width: 100.0.h,
                  // height: 7.0.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.0.w,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.grey[200],
                  ),
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Condition',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 12.0.sp,
                            color: const Color(0xff5a5a5a),
                          )),
                      Expanded(
                        flex: 1,
                        child: RadioListTile(
                          value: 0,
                          groupValue: _groupValue,
                          activeColor: primaryColor,
                          onChanged: (newValue) => setState(() => {_groupValue=0}),
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
                          onChanged: (newValue) => setState(() => {_groupValue=1}),
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
                SizedBox(height: 3.0.h,),
                InkWell(
                  onTap: (){
                    if(
                    mPic.length>0
                    ){
                      if(mTitleController.text.isNotEmpty){
                        if(mDescriptionController.text.isNotEmpty){
                          if(mPriceController.text.isNotEmpty){
                            createRooyaSouq();
                          }else{
                            Get.snackbar('Required', 'Please enter product price');
                          }
                        }else{
                          Get.snackbar('Required', 'Please enter product description');
                        }
                      }else{
                        Get.snackbar('Required', 'Please enter product title');
                      }
                    }else{
                      Get.snackbar('Required', 'Please select atleast one image');
                    }

                  },
                  child: Container(
                    width: 60.0.w,
                    height: 8.0.h,
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 7),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Center(
                      child: Text('POST',
                          style: TextStyle(
                            fontFamily:
                            'Segoe UI',
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                SizedBox(height: 5.0.h,),
              ],
            ),
          ),
        ),
      ),
    ));
  }
  Future<void> getRooyaCat() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token= await prefs.getString('token');
    final response =
    await http.post(Uri.parse('${baseUrl}getSouqCat${code}'), headers: {
      "Content-Type": "application/json",
      "Authorization":token!
    },body: jsonEncode({
      "page_size":100,
      "page_number":0
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
        setState(() {
          mRooyaCatList = List<RooyaCategoryModel>.from(
              data['data'].map((model) => RooyaCategoryModel.fromJson(model)));
          selectedCat=mRooyaCatList[0];
        });
      } else {
        setState(() {

        });
      }
    }
  }
  Future<void> createRooyaSouq() async {
    setState(() {
      isLoading = true;
    });
    var files=[];
    mPic.forEach((element) {
      if(element.fileUrl!=null){
        files.add(element.fileUrl);
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token= await prefs.getString('token');
    int? userId= await prefs.getInt('user_id');
    final response =
    await http.post(Uri.parse('${baseUrl}postSouqProduct${code}'), headers: {
      "Content-Type": "application/json",
      "Authorization":token!
    },body: jsonEncode({
      "post_type":"product",
      "user_type":"user",
      "user_id":userId,
      "privacy":"public",
      "product_name":'${mTitleController.text}',
      "post_description":'${mDescriptionController.text}',
      "price":mPriceController.text,
      "category_id":selectedCat!.categoryId,
      "status":_groupValue==0?"new":"used",
      "location":"Dubai",
      "featured":1,
      "files" : files

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
        Get.back();
       Get.snackbar('Saved', 'Product saved');

      } else {
        setState(() {

        });
      }
    }
  }
}
