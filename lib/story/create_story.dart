import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dioo;
import 'dart:convert';
import 'package:rooya_app/utils/baseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';


class CreateStory extends StatefulWidget {
  @override
  _CreateStoryState createState() => _CreateStoryState();
}

class _CreateStoryState extends State<CreateStory> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  bool isLoading = false;
  String? uploadedUrl;
  double uploadPercent = 0;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.7,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.arrow_back)),
                    InkWell(
                      onTap: () {
                        if(image!=null){
                          upload(File(image!.path));
                        }else{
                          Get.snackbar('Error', 'Please Select Image!!');
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        margin: EdgeInsets.symmetric(horizontal: 5.0.w),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          'POST',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                    child: image != null
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(1.5.h),
                                    topRight: Radius.circular(1.5.h)),
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: FileImage(File(image!.path)))),
                          )
                        : Container(
                            margin: EdgeInsets.all(5.0.w),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[200]!)),
                          )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.filter_alt_sharp,
                      size: 5.0.h,
                    ),
                    InkWell(
                        onTap: () async {
                          image = await _picker.pickImage(
                              source: ImageSource.camera);

                          setState(() {});
                        },
                        child: Icon(
                          Icons.camera,
                          size: 10.0.h,
                        )),
                    InkWell(
                        onTap: () async {
                          image = await _picker.pickImage(
                              source: ImageSource.gallery);

                          setState(() {});
                        },
                        child: Icon(
                          Icons.photo_outlined,
                          size: 5.0.h,
                        )),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Future<void> createStory() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    int? userId = prefs.getInt('user_id');

    final response = await http.post(Uri.parse('${baseUrl}addStory${code}'),
        headers: {"Content-Type": "application/json", "Authorization": token!},
        body: jsonEncode({
          "user_id":userId,
          "text":"",
          "files" : [
            uploadedUrl
          ]

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
          Get.back(result: true);
        });
      } else {
        setState(() {
          // isError = true;
          // errorMsg = data['message'] ?? '';
        });
      }
    }
  }

  void upload(File file) async {
    setState(() {
      isLoading = true;
      // showPercentIndicator = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');
    String fileName = file.path.split('/').last;

    dioo.FormData data = dioo.FormData.fromMap({
      "files[]": await dioo.MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType("image", "jpeg"),
      ),
    });

    dioo.Dio dio = new dioo.Dio();

    // baseUrl + "/api/Job/GetAllByService/$mainServiceId",
    // headers: {
    // "Content-Type": "application/json",
    // "Authorization": 'Bearer ${LatestJobs.token}'
    // },

    dio.options.headers['Content-Type'] = 'multipart/form-data';
     dio.options.headers["Authorization"] = '$token';
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
      if (uploadedUrl != null) {
        createStory();
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
}
