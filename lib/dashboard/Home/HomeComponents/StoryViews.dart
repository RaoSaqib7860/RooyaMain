import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/dashboard/Home/Models/AllStoriesModel.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:story_view/story_view.dart';

class MoreStories extends StatefulWidget {
  final List<Storyobjects>? storyobjects;

  const MoreStories({Key? key, this.storyobjects}) : super(key: key);

  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

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
                storyItems: widget.storyobjects!.map((e) {
                  if (e.type == 'photo') {
                    return StoryItem.pageImage(
                      url: "$baseImageUrl${e.src}",
                      caption: "${e.linkText}",
                      controller: storyController,
                    );
                  } else {
                    return StoryItem.pageVideo(
                      "$baseImageUrl${e.src}",
                      caption: "${e.linkText}",
                      controller: storyController,
                    );
                  }
                }).toList(),
                onStoryShow: (s) {
                  print("Showing a story");
                },
                onComplete: () {
                  print("Completed a cycle");
                },
                progressPosition: ProgressPosition.top,
                repeat: false,
                controller: storyController,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
