import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rooya_app/Screens/VideoPlayerService/VideoPlayer.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';
import 'ApiUtils/AuthUtils.dart';
import 'ApiUtils/baseUrl.dart';
import 'dashboard/profile.dart';
import 'models/UserStoryModel.dart';

class ViewStory extends StatefulWidget {
  final UserStoryModel? model;
  final int? index;

  ViewStory({Key? key, this.model, this.index}) : super(key: key);

  @override
  _ViewStoryState createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  GetStorage storage = GetStorage();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: loading,
      opacity: 0.7,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            height: height,
            width: width,
            child: Stack(
              children: [
                Center(
                  child: widget.model!.items![widget.index!].type == 'photo'
                      ? CachedNetworkImage(
                          imageUrl:
                              '$baseImageUrl${widget.model!.items![widget.index!].src}',
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => ShimerEffect(
                            child: Image.asset(
                              'assets/images/home_banner.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/home_banner.png',
                            fit: BoxFit.cover,
                          ),
                        )
                      : VideoForURL(
                          url: '${widget.model!.items![widget.index!].src}',
                        ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
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
                            widget.model!.userPicture == null
                                ? 'https://www.gravatar.com/avatar/test@test.com.jpg?s=200&d=mm'
                                : '$baseImageUrl${widget.model!.userPicture}',
                            radius: 15,
                            borderColor: primaryColor,
                            borderWidth: 1,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${widget.model!.userFirstname}' +
                                ' ${widget.model!.userLastname}',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppFonts.segoeui,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${DateFormat('hh:mm a').format(DateTime.parse('${widget.model!.items![widget.index!].time}'))}',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppFonts.segoeui,
                                fontSize: 8),
                          ),
                        ],
                      ),
                      storage.read('userID') == '${widget.model!.userId}'
                          ? PopupMenuButton(
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                              onSelected: (v) async {
                                setState(() {
                                  loading = true;
                                });
                                await AuthUtils.getremoveStory(
                                    StoryID: widget.model!.id!.toString(),
                                    element_id: widget
                                        .model!.items![widget.index!].id
                                        .toString());
                                setState(() {
                                  loading = true;
                                });
                                Navigator.of(context).pop(widget.index);
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
        ),
      ),
    );
  }
}
