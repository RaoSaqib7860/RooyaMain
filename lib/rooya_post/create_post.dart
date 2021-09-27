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
import 'package:rooya_app/rooya_post/add_hastags.dart';
import 'package:rooya_app/rooya_post/add_usertags.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/baseUrl.dart';
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
  List<HashTagModel> selectedHashTags=[];
  List<UserTagModel> selectedUserTags=[];
  List hashTags=[];
  List usersTags=[];
  List usersTagsPic=[];
  bool isLoading = false;
  String? uploadedUrl;
  List<FileUploadModel> mPic = [];
  int selectedImageIndex=0;
  double uploadPercent = 0;
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child:Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal:2.5.w,vertical: 2.5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                       image = await _picker.pickImage(source: ImageSource.camera);
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
                        border: Border.all(color: Colors.grey[400]!)
                      ),
                      child: Icon(Icons.camera_alt_outlined,size: 4.5.h,color: Colors.black54,),
                    ),
                  ),
                  SizedBox(width: 2.5.w,),
                  InkWell(
                    onTap: () async {
                        image = await _picker.pickImage(source: ImageSource.gallery);
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
                          border: Border.all(color: Colors.grey[400]!)
                      ),
                      child: Icon(Icons.photo_outlined,size: 4.5.h,color: Colors.black54,),
                    ),
                  )
                ],
              ),
              SizedBox(height: 2.5.w,),
              Expanded(
                child: Container(
                  width: 100.0.w,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(1.5.h)),
                  child: Stack(
                    children: [
                      //Expanded(child: Container()),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            // CachedNetworkImage(
                            //   imageUrl: 'https://cdn-prod.medicalnewstoday.com/content/images/articles/325/325466/man-walking-dog.jpg',
                            //   imageBuilder: (context, imageProvider) => Container(
                            //     height: 30.0.h,
                            //     width: 100.0.w,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.only(
                            //             topLeft: Radius.circular(1.5.h),
                            //             topRight: Radius.circular(1.5.h)),
                            //         image: DecorationImage(
                            //             fit: BoxFit.fitWidth,
                            //             image: imageProvider)),
                            //   ),
                            //   placeholder: (context, url) => Container(
                            //       height: 30.0.h,
                            //       width: 100.0.w,
                            //       child: Center(child: CircularProgressIndicator())),
                            //   errorWidget: (context, url, error) => Icon(Icons.error),
                            // ),
                            TextFormField(
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
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),

                              ),
                            ),
                           //  FlutterTagging<Language>(
                           //      initialItems: _selectedLanguages,
                           //      textFieldConfiguration: TextFieldConfiguration(
                           //        decoration: InputDecoration(
                           //          border: InputBorder.none,
                           //          filled: true,
                           //          fillColor: Colors.green.withAlpha(30),
                           //          hintText: 'Search Tags',
                           //          labelText: 'Select Tags',
                           //        ),
                           //      ),
                           //      findSuggestions: LanguageService.getLanguages,
                           //      additionCallback: (value) {
                           //        return Language(
                           //          name: value,
                           //          position: 0,
                           //        );
                           //      },
                           //      onAdded: (language){
                           //        // api calls here, triggered when add to tag button is pressed
                           //        return language;
                           //      },
                           //      configureSuggestion: (lang) {
                           //        return SuggestionConfiguration(
                           //          title: Text(lang.name),
                           //          subtitle: Text(lang.position.toString()),
                           //          additionWidget: Chip(
                           //            avatar: Icon(
                           //              Icons.add_circle,
                           //              color: Colors.white,
                           //            ),
                           //            label: Text('Add New Tag'),
                           //            labelStyle: TextStyle(
                           //              color: Colors.white,
                           //              fontSize: 14.0,
                           //              fontWeight: FontWeight.w300,
                           //            ),
                           //            backgroundColor: Colors.green,
                           //          ),
                           //        );
                           //      },
                           //      configureChip: (lang) {
                           //        return ChipConfiguration(
                           //          label: Text(lang.name),
                           //          backgroundColor: Colors.green,
                           //          labelStyle: TextStyle(color: Colors.white),
                           //          deleteIconColor: Colors.white,
                           //        );
                           //      },
                           //      onChanged: () {
                           //        setState(() {
                           //          _selectedValuesJson = _selectedLanguages
                           //              .map<String>((lang) => '\n${lang.toJson()}')
                           //              .toList()
                           //              .toString();
                           //          _selectedValuesJson =
                           //              _selectedValuesJson.replaceFirst('}]', '}\n]');
                           //        });
                           //      }
                           //  ),

                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: (){
                                Get.to(()=>AddHashTags(
                                  selectedHashTags: selectedHashTags,
                                  onAddHashTag: (List<HashTagModel> selectedHashTagList){
                                    setState(() {
                                      selectedHashTags=selectedHashTagList;
                                      hashTags=[];
                                      selectedHashTags.forEach((element) {
                                        hashTags.add(element.hashtag);
                                      });
                                    });
                                  },
                                ));
                              },
                              child: Container(
                                width: 100.0.w,
                                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                color: Colors.grey[300],
                                child: Text(
                                    hashTags.length==0?'#Add Hashtags':'${hashTags.toString().replaceAll('[', '').replaceAll(']', '')}'
                                ),
                              ),
                            ),
                            SizedBox(height: 2.0.w,),
                            InkWell(
                              onTap: (){
                                Get.to(()=>AddUserTags(
                                  selectedUserTags: selectedUserTags,
                                  onAddUserTag: (List<UserTagModel> selectedUserTagList){
                                    setState(() {
                                      selectedUserTags=selectedUserTagList;
                                      usersTags=[];
                                      usersTagsPic=[];
                                      selectedUserTags.forEach((element) {
                                        usersTags.add(element.userId);
                                        usersTagsPic.add(element.userPicture);
                                      });
                                    });
                                  },
                                ));
                              },
                              child: Container(
                                width: 95.0.w,
                                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))
                                ),
                                child: usersTags.length==0?Padding(
                                  padding:  EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text(
                                      '@Tag People'
                                  ),
                                ):Wrap(children: usersTagsPic.map((item) => Container(
                                  height: 4.0.h,
                                  width: 4.0.h,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage('$baseImageUrl$item')
                                      )
                                  ),
                                )).toList().cast<Widget>(),),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.5.w,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Text('Preview'),
                  ),
                  SizedBox(width: 2.5.w,),
                  InkWell(
                    onTap: (){

                        if(
                        descriptionController.text.isNotEmpty||mPic.length>0
                        ){
                          createPost();
                        }else{
                          Get.snackbar('Error', 'Please enter description or select image!!');
                        }

                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(25)
                      ),
                      child: Text('POST',style: TextStyle(
                        color: Colors.white
                      ),),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
  void upload(File file) async {
    setState(() {
      isLoading = true;
      // showPercentIndicator = true;
    });

    String fileName = file.path.split('/').last;

    dioo.FormData data = dioo.FormData.fromMap({
      "files[]": await dioo.MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType:  MediaType("image", "jpeg"),
      ),
    });

    dioo.Dio dio = new dioo.Dio();

    // baseUrl + "/api/Job/GetAllByService/$mainServiceId",
    // headers: {
    // "Content-Type": "application/json",
    // "Authorization": 'Bearer ${LatestJobs.token}'
    // },

     dio.options.headers['Content-Type'] = 'multipart/form-data';
   // dio.options.headers["Authorization"] = 'Bearer ${Step1_ProfilePhoto.token}';
    dio.post('${baseUrl}uploadfiles${code}', data: data,
        onSendProgress: (int sent, int total) {
          setState(() {
            uploadPercent = (((sent / total) * 100) / 100).toDouble();

            // double p = uploadPercent * 100;
            // showVal = int.parse(p.toString()) * 100;

            print("$sent $total");
            print(uploadPercent);
          });
        }).then((response) async {
      print(response.data);

      print(' Data : ${response.data['file_url']}');

      uploadedUrl = response.data['file_url'];

      setState(() {
        isLoading = false;
       // showPercentIndicator = false;
      });
      if(uploadedUrl!=null){
        // createPost();
      }
      // UploadPic();
    }).catchError((error) {
      print(error);
      setState(() {
        isLoading = false;
        //showPercentIndicator = false;
      });
    });
  }

  Future<void> createPost() async {
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
    int? userId=  prefs.getInt('user_id');
    String? token= await prefs.getString('token');
    print(jsonEncode({
      "post_type":"photos",
      "user_type":"user",
      "user_id":userId,
      "privacy":"public",
      "post_description":descriptionController.text,
      "hashtag":hashTags,
      "tagusers":usersTags,
      "files":files
    }));
    final response =
    await http.post(Uri.parse('${baseUrl}addpostNew${code}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token!
        },
        body: jsonEncode({
          "post_type":"photos",
          "user_type":"user",
          "user_id":userId,
          "privacy":"public",
          "post_description":descriptionController.text,
          "hashtag":hashTags,
          "tagusers":usersTags,
          "files":files
        }));

    setState(() {
      isLoading = false;
    });

    print(response.request);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 'success') {
        setState(() {
         Get.back();
        });
      } else {
        setState(() {
          // isError = true;
          // errorMsg = data['message'] ?? '';
        });
      }
    }
  }
}
