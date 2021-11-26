import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

//import 'package:rooya_app/ApiUtils/AuthUtils.dart';
import 'package:rooya_app/story/CreateStoryController.dart';
import 'package:rooya_app/story/uploadStroy.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:rooya_app/widgets/GlobalSpinKit.dart';

// import 'package:sizer/sizer.dart';
// import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart' as dio;
// import 'dart:convert';
// import 'package:rooya_app/ApiUtils/baseUrl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http_parser/http_parser.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreateStory extends StatefulWidget {
  final String? from;

  const CreateStory({Key? key, this.from}) : super(key: key);

  @override
  _CreateStoryState createState() => _CreateStoryState();
}

class _CreateStoryState extends State<CreateStory> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  bool isLoading = false;
  String? uploadedUrl;
  double uploadPercent = 0;
  final controller = Get.put(CreateStoryController());

  @override
  void initState() {
    if (widget.from == 'image') {
      controller.getImagePath();
    } else {
      controller.getVideoPath();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.5,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Create Story',
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
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.030),
              child: Stack(
                children: [
                  Container(
                    height: height,
                    width: width,
                    child: Column(
                      children: [
                        widget.from == 'video'
                            ? Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.selectLocation(
                                          context, widget.from!);
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
                                                if (!controller
                                                        .listOfSelectedVideos
                                                        .contains(controller
                                                                .listOfVidoeFilea[
                                                            i]) &&
                                                    controller
                                                            .listOfSelectedVideos
                                                            .length <
                                                        8) {
                                                  controller
                                                      .listOfSelectedVideos
                                                      .add(controller
                                                          .listOfVidoeFilea[i]);
                                                }
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                                              .listOfVidoeFilea[i],
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Icon(
                                                          Icons
                                                              .play_circle_fill,
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
                                              (BuildContext context,
                                                  int index) {
                                            return SizedBox(
                                              width: 10,
                                            );
                                          },
                                          itemCount: controller
                                              .listOfVidoeFilea.length,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.end,
                              )
                            : Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.selectLocation(
                                          context, widget.from!);
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
                                                if (!controller
                                                        .listOfSelectedImages
                                                        .contains(controller
                                                                .listOfImageFilea[
                                                            i]) &&
                                                    controller
                                                            .listOfSelectedImages
                                                            .length <
                                                        8) {
                                                  controller
                                                      .listOfSelectedImages
                                                      .add(controller
                                                          .listOfImageFilea[i]);
                                                }
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Container(
                                                  height: height * 0.060,
                                                  width: width * 0.120,
                                                  child: Image.file(
                                                    File(controller
                                                        .listOfImageFilea[i]),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          scrollDirection: Axis.horizontal,
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return SizedBox(
                                              width: 10,
                                            );
                                          },
                                          itemCount: controller
                                              .listOfImageFilea.length,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.end,
                              ),
                        SizedBox(
                          height: height * 0.020,
                        ),
                        widget.from == 'image'
                            ? Expanded(
                                child: Obx(
                                  () => Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            color: Colors.black45, width: 1)),
                                    child: CustomScrollView(
                                      slivers: [
                                        controller.listOfSelectedImages.isEmpty
                                            ? SliverToBoxAdapter()
                                            : SliverToBoxAdapter(
                                                child: ClipRRect(
                                                  child: Container(
                                                    height: height * 0.250,
                                                    width: width,
                                                    child: Image.file(
                                                      File(controller
                                                          .listOfSelectedImages[0]),
                                                      fit: BoxFit.cover,
                                                    ),
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
                                            delegate:
                                                SliverChildBuilderDelegate(
                                                    (BuildContext context,
                                                        int index) {
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Image.file(
                                                  File(controller
                                                          .listOfSelectedImages[
                                                      index]),
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            },
                                                    childCount: controller
                                                        .listOfSelectedImages
                                                        .length)),
                                        SliverToBoxAdapter(
                                          child: TextFormField(
                                            controller:
                                                controller.storyController,
                                            cursorColor: Colors.black,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            maxLines: 10,
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
                                              hintText: 'Type your Vision...',
                                              //  hintText: '+923331234567',
                                              hintStyle: TextStyle(
                                                fontFamily: AppFonts.segoeui,
                                                fontSize: 13,
                                                color: const Color(0xff1e1e1e),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Obx(
                                  () => Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            color: Colors.black45, width: 1)),
                                    child: CustomScrollView(
                                      slivers: [
                                        controller.listOfSelectedVideos.isEmpty
                                            ? SliverToBoxAdapter()
                                            : SliverToBoxAdapter(
                                                child: ClipRRect(
                                                  child: Container(
                                                      height: height * 0.250,
                                                      width: width,
                                                      child: Thumbnails(
                                                        thumb: controller
                                                            .listOfSelectedVideos[0],
                                                      )),
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
                                            delegate:
                                                SliverChildBuilderDelegate(
                                                    (BuildContext context,
                                                        int index) {
                                              return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: Thumbnails(
                                                    thumb: controller
                                                            .listOfSelectedVideos[
                                                        index],
                                                  ));
                                            },
                                                    childCount: controller
                                                        .listOfSelectedVideos
                                                        .length)),
                                        SliverToBoxAdapter(
                                          child: TextFormField(
                                            controller:
                                                controller.storyController,
                                            cursorColor: Colors.black,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            maxLines: 10,
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
                                              hintText: 'Type your Vision...',
                                              //  hintText: '+923331234567',
                                              hintStyle: TextStyle(
                                                fontFamily: AppFonts.segoeui,
                                                fontSize: 13,
                                                color: const Color(0xff1e1e1e),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: height * 0.010,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () async {
                              // setState(() {
                              //   isLoading = true;
                              // });
                              // List listofurl = [];
                              // if (widget.from == 'image') {
                              //   for (var i in controller.listOfSelectedImages) {
                              //     String value = await createStory(i);
                              //     listofurl.add(value);
                              //   }
                              // } else {
                              //   for (var i in controller.listOfSelectedVideos) {
                              //     String value = await createStory(i);
                              //     listofurl.add(value);
                              //   }
                              // }
                              // print('listofurl= $listofurl');
                              // await uploadStoryData(
                              //     controller: controller, listOfUrl: listofurl);
                              // setState(() {
                              //   isLoading = true;
                              // });
                              // Get.back();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 7),
                              child: Text(
                                'Post',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: AppFonts.segoeui,
                                    fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.010,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

// void upload(File file) async {
//   setState(() {
//     isLoading = true;
//     // showPercentIndicator = true;
//   });
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? token = await prefs.getString('token');
//   String fileName = file.path.split('/').last;
//
//   dioo.FormData data = dioo.FormData.fromMap({
//     "files[]": await dioo.MultipartFile.fromFile(
//       file.path,
//       filename: fileName,
//       contentType: MediaType("image", "jpeg"),
//     ),
//   });
//
//   dioo.Dio dio = new dioo.Dio();
//
//   // baseUrl + "/api/Job/GetAllByService/$mainServiceId",
//   // headers: {
//   // "Content-Type": "application/json",
//   // "Authorization": 'Bearer ${LatestJobs.token}'
//   // },
//
//   dio.options.headers['Content-Type'] = 'multipart/form-data';
//   dio.options.headers["Authorization"] = '$token';
//   dio.post('${baseUrl}uploadfiles${code}', data: data,
//       onSendProgress: (int sent, int total) {
//     setState(() {
//       uploadPercent = (((sent / total) * 100) / 100).toDouble();
//
//       // double p = uploadPercent * 100;
//       // showVal = int.parse(p.toString()) * 100;
//
//       print("$sent $total");
//       print(uploadPercent);
//     });
//   }).then((response) async {
//     print(response.data);
//
//     print(' Data : ${response.data['file_url']}');
//
//     uploadedUrl = response.data['file_url'];
//
//     setState(() {
//       isLoading = false;
//       // showPercentIndicator = false;
//     });
//     if (uploadedUrl != null) {
//       createStory();
//     }
//     // UploadPic();
//   }).catchError((error) {
//     print(error);
//     setState(() {
//       isLoading = false;
//       //showPercentIndicator = false;
//     });
//   });
// }
}

class Thumbnails extends StatefulWidget {
  final String? thumb;

  const Thumbnails({Key? key, this.thumb}) : super(key: key);

  @override
  _ThumbnailsState createState() => _ThumbnailsState();
}

class _ThumbnailsState extends State<Thumbnails> {
  @override
  void initState() {
    getThubnail();
    super.initState();
  }

  Uint8List? uint8list;
  bool isload = false;

  getThubnail() async {
    uint8list = await VideoThumbnail.thumbnailData(
      video: '${widget.thumb}',
      imageFormat: ImageFormat.PNG,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 50,
    );
    setState(() {
      isload = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isload
        ? Image.memory(
            uint8list!,
            fit: BoxFit.cover,
          )
        : Container(
            child: spinKitGlobal(size: 15),
            decoration: BoxDecoration(color: Colors.black),
          );
  }
}
