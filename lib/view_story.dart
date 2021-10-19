import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/Screens/VideoPlayerService/VideoPlayer.dart';
import 'package:rooya_app/utils/ShimmerEffect.dart';
import 'package:rooya_app/utils/SizedConfig.dart';

class ViewStory extends StatefulWidget {
  final String? picUrl;
  final String? src;

  ViewStory({Key? key, @required this.picUrl, this.src}) : super(key: key);

  @override
  _ViewStoryState createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              Center(
                child: widget.src == 'photo'
                    ? CachedNetworkImage(
                        imageUrl: '${widget.picUrl}',
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
                        url: "${widget.picUrl}",
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  // IconButton(
                  //     onPressed: () {
                  //       Get.back();
                  //     },
                  //     icon: Icon(
                  //       Icons.more_vert,
                  //       color: Colors.white,
                  //     )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
