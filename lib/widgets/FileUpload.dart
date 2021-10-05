import 'dart:ffi';
import 'dart:io';

import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rooya_app/models/FileUploadModel.dart';
import 'package:rooya_app/ApiUtils/baseUrl.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FileUpload extends StatefulWidget {
  FileUploadModel? fileUploadModel;
  Function? onRemove;
  Function? onComplete;
  double? height;
  double? width;
  double? progressRadius;
  double? progressLineWidth;
  static String? token;
  FileUpload({Key? key,this.height,this.width,this.progressRadius,this.progressLineWidth, this.fileUploadModel, this.onRemove, this.onComplete})
      : super(key: key);

  @override
  _FileUploadState createState() => _FileUploadState();
  static Future<bool> gettoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    token = (await prefs.get( 'token')) as String?;
    return true;
  }
}

class _FileUploadState extends State<FileUpload> {
  double uploadPercent = 0;

  @override
  void initState() {
    // TODO: implement initState


    FileUpload.gettoken().then((value) => uploadPicture());

    super.initState();
  }

  Future <void> uploadPicture() async {
    if (!widget.fileUploadModel!.isUploaded &&
        !widget.fileUploadModel!.isUploadError) {
      final mimeTypeData =
      lookupMimeType(widget.fileUploadModel!.file.path, headerBytes: [0xFF, 0xD8])!.split('/');
      Response response;
      Dio dio = new Dio();
      dio.options.headers["Authorization"] = FileUpload.token;



      print(lookupMimeType(widget.fileUploadModel!.file.path, headerBytes: [0xFF, 0xD8]));
      FormData formData = FormData.fromMap({
        "files[]": await MultipartFile.fromFile(widget.fileUploadModel!.file.path,filename: widget.fileUploadModel!.file.path,
           contentType: MediaType(mimeTypeData[0],mimeTypeData[1])
        ),
      });
      print('file_object: ${widget.fileUploadModel!.file.path}');
        await dio.post('${baseUrl}uploadfiles${code}', data: formData,
        onSendProgress: (int sent, int total) {
          setState(() {
            uploadPercent = (((sent / total)*100)/100).toDouble();
            print("$sent $total");
            print(uploadPercent);
          });

        },

      ).catchError((onError){
        setState(() {
          widget.fileUploadModel!.isUploadError = true;
        });
      }).then((response) {
          print(response.statusCode);
          print(response.data);
          if (response.statusCode==200){

            final data = response.data;
            print(data['file_url']);
            // if(data['status']=='Success'){
            setState(() {
              widget.fileUploadModel!.isUploaded = true;
              widget.fileUploadModel!.isUploadError = false;
            });
             widget.onComplete!(data['file_url']);
            // }
          }else{
            setState(() {
              widget.fileUploadModel!.isUploadError = true;
            });
          }
      });


      // var request = MultipartRequest();
      //
      // request.setUrl(baseUrl + "/api/Attachments/SingleFileReceived");
      // // request.setUrl("/api/Attachments/SingleFileReceived");
      // request.addHeader('Authorization', FileUpload.token);
      // request.addFile("file", widget.fileUploadModel.file.path);
      //
      // Response response = request.send();
      //
      // response.onError = () {
      //   print("Error");
      //   setState(() {
      //     widget.fileUploadModel.isUploadError = true;
      //   });
      // };
      //
      // response.onComplete = (response) {
      //   setState(() {
      //     widget.fileUploadModel.isUploaded = true;
      //   });
      //   widget.onComplete(response);
      //   print(response);
      // };
      //
      // response.progress.listen((int progress) {
      //   setState(() {
      //     uploadPercent = (progress / 100).toDouble();
      //   });
      //   print("progress from response object " + uploadPercent.toString());
      // });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height:widget.height?? MediaQuery.of(context).size.width / 2 - 5,
      width:widget.width?? MediaQuery.of(context).size.width / 2 - 5,
      child: Stack(
        children: <Widget>[
          Container(
            //height: (MediaQuery.of(context).size.width-80)/2,
            height:widget.height?? MediaQuery.of(context).size.width / 2 - 5,
            width:widget.width?? MediaQuery.of(context).size.width / 2 - 5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: FileImage(File(widget.fileUploadModel!.file.path)),
                    fit: BoxFit.cover)),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.onRemove!(widget.fileUploadModel);
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.8),
                      borderRadius:
                      BorderRadius.only(topRight: Radius.circular(15))),
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                  )),
            ),
          ),
          !widget.fileUploadModel!.isUploaded &&
              !widget.fileUploadModel!.isUploadError
              ? Center(
            child: CircularPercentIndicator(
              radius: widget.progressRadius??60.0,
              lineWidth: widget.progressLineWidth??8.0,
              percent: uploadPercent,
              // center: new Text("100%"),
              progressColor: primaryColor,
            ),
          )
              : Container(),
          widget.fileUploadModel!.isUploadError
              ? Center(
            child: InkWell(
              onTap: () async {
                setState(() {
                  widget.fileUploadModel!.isUploadError = false;
                });

                uploadPicture();
                // Response response;
                // Dio dio = new Dio();
                // dio.options.headers["Authorization"] = FileUpload.token;
                // FormData formData = FormData.fromMap({
                //   "file": await MultipartFile.fromFile(widget.fileUploadModel.file.path,filename: widget.fileUploadModel.file.path),
                // });
                //
                // response = await dio.post(baseUrl + "/api/Attachments/SingleFileReceived", data: formData,
                //   onSendProgress: (int sent, int total) {
                //     setState(() {
                //       // uploadPercent = (total / 100).toDouble();
                //     });
                //     print("progress from response object " +
                //         total.toString());
                //     print("progress from response object " +
                //         uploadPercent.toString());
                //   },
                //
                // ).catchError((onError){
                //   setState(() {
                //     widget.fileUploadModel.isUploadError = true;
                //   });
                // });


              },
              child: Container(
                padding:
                EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: primaryColor),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.file_upload,
                      color: Colors.white,
                    ),
                    Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          )
              : Container()
        ],
      ),
    );
  }
}