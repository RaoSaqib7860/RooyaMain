import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rooya_app/ApiUtils/AuthUtils.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/dashboard/Home/Models/AllStoriesModel.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:story_view/story_view.dart';
import '../../profile.dart';

class MoreStories extends StatefulWidget {
  final List<Storyobjects>? storyobjects;

  const MoreStories({Key? key, required this.storyobjects}) : super(key: key);

  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();
  DateFormat sdf2 = DateFormat("hh.mm aa");
  List<Storyobjects>? storyobjects;
  bool storyIni = false;

  @override
  void initState() {
    storyobjects = widget.storyobjects;
    Future.delayed(Duration(seconds: 1), () {
      storyIni = true;
    });
    super.initState();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  GetStorage storage = GetStorage();
  int? currentindex = 0;
  final controller = Get.put(StoryControllerforTime());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: height,
              width: width,
              child: StoryView(
                storyItems: storyobjects!.map((e) {
                  if (e.type == 'photo') {
                    // controller.currentIndex.value = storyobjects!.indexOf(e);
                    return StoryItem.pageImage(
                        url: "$baseImageUrl${e.src}",
                        caption: "${e.linkText}",
                        controller: storyController,
                        duration: Duration(seconds: 5));
                  } else {
                    controller.currentIndex.value = storyobjects!.indexOf(e);
                    return StoryItem.pageVideo("$baseImageUrl${e.src}",
                        caption: "${e.linkText}",
                        controller: storyController,
                        duration: Duration(seconds: 5));
                  }
                }).toList(),
                onStoryShow: (s) {
                  // if (storyIni ) {
                  //   controller.currentIndex.value =
                  //       controller.currentIndex.value + 1;
                  // }
                },
                currentindex: (v) {
                  print('current index is = $v');
                  Future.delayed(Duration(milliseconds: 300), () {
                    controller.currentIndex.value = v;
                  });
                },
                onComplete: () {
                  Navigator.pop(context);
                },
                progressPosition: ProgressPosition.top,
                repeat: false,
                controller: storyController,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      CircularProfileAvatar(
                        storyobjects![0].userPicture == null
                            ? 'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm'
                            : '$baseImageUrl${storyobjects![0].userPicture}',
                        radius: 15,
                        borderColor: primaryColor,
                        borderWidth: 1,
                        onTap: () {
                          storyController.pause();
                          Get.to(Profile(
                            userID: '${storyobjects![0].userId}',
                          ))!
                              .then((value) {
                            storyController.play();
                          });
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          storyController.pause();
                          Get.to(Profile(
                            userID: '${storyobjects![0].userId}',
                          ))!
                              .then((value) {
                            storyController.play();
                          });
                        },
                        child: Text(
                          '${storyobjects![0].userName}',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppFonts.segoeui,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Obx(
                        () => Text(
                          '${DateFormat('hh:mm a').format(DateTime.parse('${storyobjects![controller.currentIndex.value].time}'))}',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppFonts.segoeui,
                              fontSize: 8),
                        ),
                      ),
                    ],
                  ),
                  storage.read('userID') == '${storyobjects![0].userId}'
                      ? PopupMenuButton(
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onCanceled: () {
                            print('lkcccskc');
                            storyController.play();
                          },
                          onSelected: (v) {
                            if (storyobjects!.length > 1) {
                              print(
                                  'currentindex = ${controller.currentIndex.value}');
                              AuthUtils.getremoveStory(
                                  StoryID: storyobjects![
                                          controller.currentIndex.value]
                                      .storyid
                                      .toString(),
                                  element_id: storyobjects![
                                          controller.currentIndex.value]
                                      .story_element_id
                                      .toString());
                              storyobjects!
                                  .removeAt(controller.currentIndex.value);
                              setState(() {});
                            } else {
                              print(
                                  'currentindex = ${controller.currentIndex.value}');
                              AuthUtils.getremoveStory(
                                  StoryID: storyobjects![
                                          controller.currentIndex.value]
                                      .storyid
                                      .toString(),
                                  element_id: storyobjects![
                                          controller.currentIndex.value]
                                      .story_element_id
                                      .toString());
                              storyobjects!
                                  .removeAt(controller.currentIndex.value);
                              Navigator.of(context).pop(true);
                            }
                          },
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Text("Delete".tr),
                                  value: 2,
                                )
                              ])
                      : SizedBox()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StoryControllerforTime extends GetxController {
  var currentIndex = 0.obs;
}
