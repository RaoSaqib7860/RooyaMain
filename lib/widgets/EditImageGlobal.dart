import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/Screens/Reel/ReelCamera/ReelCamera.dart';
import 'package:rooya_app/utils/AppFonts.dart';
import 'package:rooya_app/utils/SizedConfig.dart';
import 'package:rooya_app/utils/colors.dart';

class EditImageGlobal extends StatefulWidget {
  final String? path;

  const EditImageGlobal({Key? key, this.path}) : super(key: key);

  @override
  _EditImageGlobalState createState() => _EditImageGlobalState();
}

class _EditImageGlobalState extends State<EditImageGlobal> {
  String path = '';

  @override
  void initState() {
    path = widget.path!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop('$path');
          },
          backgroundColor: primaryColor,
          child: Icon(
            CupertinoIcons.forward,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Edit Image',
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
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.030),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        String value = await cropImage(path);
                        if (value != '') {
                          setState(() {
                            path = value;
                          });
                        }
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Text(
                              'Cropping',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: AppFonts.segoeui),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.crop,
                              color: Colors.white,
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(3, 3),
                                  blurRadius: 5)
                            ],
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        String value = await filterImage(context, path);
                        print('filter path is = $value');
                        if (value != '') {
                          setState(() {
                            path = value;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(3, 3),
                                  blurRadius: 5)
                            ],
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            Text(
                              'Filters',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: AppFonts.segoeui),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.api,
                              color: Colors.white,
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(child: Image.file(File(path)))
          ],
        ),
      ),
    );
  }
}
