import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya_app/GlobalClass/SpiKitGlobal.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../main.dart';
import 'VideoPlayerController.dart';

class VideoForURL extends StatefulWidget {
  final double? spinSize;
  final String? url;

  const VideoForURL({Key? key, this.spinSize = 40.0, this.url})
      : super(key: key);

  @override
  _VideoForURLState createState() => _VideoForURLState();
}

class _VideoForURLState extends State<VideoForURL> {
  VideoPlayerController? _controller;
  bool? initialize = false;
  final controller = Get.put(VideoPlayerGetController());

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('${widget.url}')
      ..setLooping(true)
      ..initialize().then((_) {
        _controller!.play();
        initialize = true;
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('my-widget-key'),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        debugPrint(
            'onVisibilityChanged ${visibilityInfo.key} is ${visiblePercentage}% visible');
        if (visiblePercentage == 0.0) {
          setState(() {
            _controller!.pause();
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: _controller!.value.isInitialized
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _controller!.value.isPlaying
                              ? _controller!.pause()
                              : _controller!.play();
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    )
                  : Container(
                      child: spinKitGlobal(size: 50),
                      decoration: BoxDecoration(color: Colors.black),
                    ),
            ),
            _controller!.value.isPlaying
                ? SizedBox()
                : !initialize!
                    ? SizedBox()
                    : InkWell(
                        onTap: () {
                          setState(() {
                            _controller!.play();
                          });
                        },
                        child: Center(
                          child: Icon(
                            Icons.play_arrow,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      )
          ],
        ),
      ),
    );
  }
}

class VideoApp extends StatefulWidget {
  final double? spinSize;
  final String? assetsPath;

  const VideoApp({Key? key, this.spinSize = 40.0, this.assetsPath})
      : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController? _controller;
  bool? initialize = false;
  final controller = Get.put(VideoPlayerGetController());

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('${widget.assetsPath}')
      ..setLooping(true)
      ..initialize().then((_) {
        _controller!.play();
        setState(() {
          initialize = true;
        });
      });
    streamController.stream.listen((event) {
      if (event == 10.0) {
        _controller!.pause();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    print('Widget is deactive');
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('my-widget-key'),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        debugPrint(
            'onVisibilityChanged ${visibilityInfo.key} is ${visiblePercentage}% visible');
        if (visiblePercentage == 0.0) {
          setState(() {
            _controller!.pause();
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: _controller!.value.isInitialized
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _controller!.value.isPlaying
                              ? _controller!.pause()
                              : _controller!.play();
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    )
                  : Container(
                      child: spinKitGlobal(size: widget.spinSize),
                      decoration: BoxDecoration(color: Colors.black),
                    ),
            ),
            _controller!.value.isPlaying
                ? SizedBox()
                : !initialize!
                    ? SizedBox()
                    : InkWell(
                        onTap: () {
                          setState(() {
                            _controller!.play();
                          });
                        },
                        child: Center(
                          child: Icon(
                            Icons.play_arrow,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      )
          ],
        ),
      ),
    );
  }
}

class FileVideoApp extends StatefulWidget {
  final String? path;
  final double? spinSize;

  const FileVideoApp({Key? key, this.path, this.spinSize}) : super(key: key);

  @override
  _FileVideoAppState createState() => _FileVideoAppState();
}

class _FileVideoAppState extends State<FileVideoApp> {
  VideoPlayerController? _controller;
  bool? initialize = false;
  final controller = Get.put(VideoPlayerGetController());

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File('${widget.path}'))
      ..setLooping(true)
      ..initialize().then((_) {
        _controller!.play();
        setState(() {
          initialize = true;
        });
      });
    streamController.stream.listen((event) {
      if (event == 10.0) {
        _controller!.pause();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    print('Widget is deactive');
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('my-widget-key'),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        debugPrint(
            'onVisibilityChanged ${visibilityInfo.key} is ${visiblePercentage}% visible');
        if (visiblePercentage == 0.0) {
          setState(() {
            _controller!.pause();
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: _controller!.value.isInitialized
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _controller!.value.isPlaying
                              ? _controller!.pause()
                              : _controller!.play();
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    )
                  : Container(
                      child: spinKitGlobal(size: widget.spinSize),
                      decoration: BoxDecoration(color: Colors.black),
                    ),
            ),
            _controller!.value.isPlaying
                ? SizedBox()
                : !initialize!
                    ? SizedBox()
                    : InkWell(
                        onTap: () {
                          setState(() {
                            _controller!.play();
                          });
                        },
                        child: Center(
                          child: Icon(
                            Icons.play_arrow,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      )
          ],
        ),
      ),
    );
  }
}
