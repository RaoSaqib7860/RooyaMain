import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/utils/ProgressHUD.dart';
import 'package:rooya_app/utils/colors.dart';
import 'package:video_trimmer/video_trimmer.dart';

class TrimmerViewGlobal extends StatefulWidget {
  final File? file;

  TrimmerViewGlobal({this.file});

  @override
  _TrimmerViewGlobalState createState() => _TrimmerViewGlobalState();
}

class _TrimmerViewGlobalState extends State<TrimmerViewGlobal> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? _value;

    await _trimmer
        .saveTrimmedVideo(startValue: _startValue, endValue: _endValue)
        .then((value) {
      setState(() {
        _progressVisibility = false;
        _value = value;
      });
    });

    return _value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file!);
  }

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  TextEditingController controller = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isLoading,
      opacity: 0.5,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _saveVideo().then((outputPath) async {
              Navigator.of(context).pop('$outputPath');
            });
          },
          backgroundColor: greenColor,
          child: Center(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Builder(
          builder: (context) => Center(
            child: Container(
              width: Get.width,
              height: Get.height,
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.030),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: _progressVisibility,
                      child: LinearProgressIndicator(
                        backgroundColor: primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.010,
                    ),
                    Container(
                      height: Get.height * 0.630,
                      width: Get.width,
                      child: VideoViewer(trimmer: _trimmer),
                    ),
                    SizedBox(
                      height: Get.height * 0.010,
                    ),
                    Center(
                      child: TrimEditor(
                        trimmer: _trimmer,
                        viewerHeight: 50.0,
                        circlePaintColor: greenColor,
                        scrubberPaintColor: greenColor,
                        borderPaintColor: greenColor,
                        showDuration: true,
                        durationTextStyle:
                            TextStyle(color: primaryColor, fontSize: 12),
                        viewerWidth: MediaQuery.of(context).size.width -
                            Get.width * 0.040,
                        maxVideoLength: Duration(seconds: 10),
                        onChangeStart: (value) {
                          _startValue = value;
                        },
                        onChangeEnd: (value) {
                          _endValue = value;
                        },
                        onChangePlaybackState: (value) {
                          setState(() {
                            _isPlaying = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.030,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: greenColor, shape: BoxShape.circle),
                      child: TextButton(
                        child: _isPlaying
                            ? Icon(
                                Icons.pause,
                                size: 40.0,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.play_arrow,
                                size: 40.0,
                                color: Colors.white,
                              ),
                        onPressed: () async {
                          bool playbackState =
                              await _trimmer.videPlaybackControl(
                            startValue: _startValue,
                            endValue: _endValue,
                          );
                          setState(() {
                            _isPlaying = playbackState;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.050,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
