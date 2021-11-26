import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/colors.dart';

class CreateEventController extends GetxController {
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
    print('${value}');
    List list = jsonDecode(value);
    list.forEach((element) {
      List list2 = element['files'];
      list2.forEach((element) {
        listOfVidoeFilea.add({'video': '${element['path']}'});
      });
    });
  }

  getImagePath() async {
    String value = await imagesPath;
    print('${value}');
    List list = jsonDecode(value);
    list.forEach((element) {
      List list2 = element['files'];
      list2.forEach((element) {
        if (!listOfImageFilea.contains(element)) {
          listOfImageFilea.add({'image': '${element}'});
        }
      });
    });
  }

  final ImagePicker _picker = ImagePicker();

  onImageButtonPressed(ImageSource source, String tag) async {
    try {
      PickedFile? pickedFile;
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
      if (!listOfSelectedfiles.contains(pickedFile.path) &&
          listOfSelectedfiles.length < 8) {
        if (pickedFile.path.contains('.mp4')) {
          listOfSelectedfiles.add({'video': '${pickedFile.path}'});
        } else {
          listOfSelectedfiles.add({'image': '${pickedFile.path}'});
        }
      }
    } catch (e) {}
  }

  gallarypress() async {
    try {
      final FilePickerResult? pickedFile;
      pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4'],
      );
      print('pickedFile = ${pickedFile!.paths}');
      pickedFile.paths.forEach((element) {
        if (!listOfSelectedfiles.contains(element) &&
            listOfSelectedfiles.length < 8) {
          if (element!.contains('.mp4')) {
            listOfSelectedfiles.add({'video': '$element'});
          } else {
            listOfSelectedfiles.add({'image': '$element'});
          }
        }
      });
    } catch (e) {}
  }

  selectLocation(BuildContext context) {
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
                      onImageButtonPressed(ImageSource.camera, 'image');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.all(7),
                      child: Text(
                        'Image',
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
                      onImageButtonPressed(ImageSource.camera, 'video');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.all(7),
                      child: Text(
                        'Video',
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

  var listOfSelectedfiles = [].obs;
  var listOfVidoeFilea = [].obs;
  var listOfImageFilea = [].obs;

}
