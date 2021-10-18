import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/colors.dart';

class CreateStoryController extends GetxController {
  static const MethodChannel _channel = const MethodChannel('storage_path');

  static Future<String> get videoPath async {
    print('channel calling ....');
    final String data = await _channel.invokeMethod('getVideosPath');
    return data;
  }

  static Future<String> get imagesPath async {
    final String data = await _channel.invokeMethod('getImagesPath');
    return data;
  }

  getVideoPath() async {
    String value = await videoPath;
    print('$value');
    List list = jsonDecode(value);
    list.forEach((element) {
      List list2 = element['files'];
      list2.forEach((element) {
        listOfVidoeFilea.add('${element['path']}');
      });
    });
  }

  getImagePath() async {
    String value = await imagesPath;
    log('$value');
    List list = jsonDecode(value);
    list.forEach((element) {
      List list2 = element['files'];
      list2.forEach((element) {
        if (!listOfImageFilea.contains(element)) {
          listOfImageFilea.add('$element');
        }
      });
    });
  }

  final ImagePicker _picker = ImagePicker();

  onImageButtonPressed(ImageSource source, String tag) async {
    try {
      final pickedFile;
      if (tag == 'image') {
        pickedFile = await _picker.getImage(
          source: source,
        );
      } else {
        pickedFile = await _picker.getVideo(
          source: source,
        );
      }
      print('pickedFile = ${pickedFile!.path}');
      if (tag == 'image') {
        if (!listOfSelectedImages.contains(pickedFile.path) &&
            listOfSelectedImages.length < 8) {
          listOfSelectedImages.add('${pickedFile.path}');
        }
      } else {
        if (!listOfSelectedVideos.contains(pickedFile.path) &&
            listOfSelectedVideos.length < 8) {
          listOfSelectedVideos.add('${pickedFile.path}');
        }
      }
    } catch (e) {}
  }

  selectLocation(BuildContext context, String tag) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.black.withOpacity(0.5),
            insetPadding: EdgeInsets.symmetric(horizontal: width / 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            //this right here
            child: Container(
              height: height / 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      onImageButtonPressed(ImageSource.gallery, tag);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.all(7),
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppFonts.segoeui,
                            fontSize: 13),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      onImageButtonPressed(ImageSource.camera, tag);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.all(7),
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppFonts.segoeui,
                            fontSize: 13),
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8)),
            ),
          );
        });
  }

  var listOfVidoeFilea = [].obs;
  var listOfImageFilea = [].obs;
  var listOfSelectedImages = [].obs;
  var listOfSelectedVideos = [].obs;
  TextEditingController storyController = TextEditingController();
}
