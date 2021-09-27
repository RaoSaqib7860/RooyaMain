import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewStory extends StatefulWidget {
  String? picUrl;

  ViewStory({Key? key, @required this.picUrl}) : super(key: key);

  @override
  _ViewStoryState createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Image.network(
              widget.picUrl!,
              //fit: BoxFit.cover,
              // height: double.infinity,
              // width: double.infinity,
              alignment: Alignment.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back)),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.more_vert)),
            ],
          ),
        ],
      ),
    );
  }
}
