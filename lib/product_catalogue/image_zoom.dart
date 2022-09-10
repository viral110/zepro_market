import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jalaram/Model/micro_product_details.dart';
import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';

import 'package:video_player/video_player.dart';

class ImageZoom extends StatefulWidget {
  String linkImage;
  String linkVideo;
  List<BannersMicroDetails> url;
  String mediaTypeZoom;
  int index;

  ImageZoom(
      {Key key,
      this.linkImage,
      this.url,
      this.linkVideo,
      this.mediaTypeZoom,
      this.index})
      : super(key: key);

  @override
  State<ImageZoom> createState() => _ImageZoomState();
}

class _ImageZoomState extends State<ImageZoom> {
  PageController controller;

  int currentPageValue = 0;

  Future<void> _initializedVideoPlayer;

  Timer timer;

  int _start = 0;

  void startTimer(int start) {
    if (timer != null) {
      timer.cancel();
    }
    setState(() {
      _start = start;
    });
    const oneSec = const Duration(seconds: 1);

    timer = Timer.periodic(oneSec, (timer) {
      if (_start >= _videoPlayerController.value.duration.inSeconds) {
        timer.cancel();
      }
      // else if(_start == _videoPlayerController.value.duration.inSeconds){
      //   setState(() {
      //     _start = 0;
      //     _start++;
      //   });
      // }
      else {
        setState(() {
          _start++;
        });
      }
    });
  }

  VideoPlayerController _videoPlayerController;

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  forVideoInitialize() {
    for (int i = 0; i < widget.url.length; i++) {
      if (widget.url[i].mediaType == "video") {
        debugPrint("${widget.linkVideo}/${widget.url[i].media}");
        _videoPlayerController = VideoPlayerController.network(
          "${widget.linkVideo}/${widget.url[i].media}",
        );
        _initializedVideoPlayer = _videoPlayerController.initialize();
        _videoPlayerController.addListener(() {
          setState(() {});
        });

        _videoPlayerController.setLooping(false);
        _videoPlayerController.setVolume(1.0);
      }
    }
  }



  @override
  void initState() {
    super.initState();
    currentPageValue = widget.index;
    controller = PageController(initialPage: widget.index);
    print("value1 : $currentPageValue");
    forVideoInitialize();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
    _videoPlayerController.dispose();
  }

  void pauseTimer() {
    if (timer != null) {
      timer.cancel();
    }
  }

  void incrementCounter() {
    bool stopTimer;
    startTimer(_start);
    if (_start == _videoPlayerController.value.duration.inSeconds) {
      _start = 0;
    }

    setState(() {
      _videoPlayerController.value.isPlaying
          ? _videoPlayerController.pause()
          : _videoPlayerController.play();
    });
    if (_videoPlayerController.value.isPlaying == true) {
      stopTimer = false;
      unpauseTimer();
    } else {
      stopTimer = true;
      pauseTimer();
    }
    print("timer variable : $stopTimer");
  }

  void unpauseTimer() => startTimer(_start);

  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            isActive == true
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14, top: 8),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                          ),
                  ),
                      ),
                      InkWell(
                        onTap: () async {
                          await imagevideoShare();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14, top: 8),
                          child: Icon(Icons.share, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
            // verticalPart(),
            // horizontalPart(),
            Expanded(
              child: OrientationBuilder(
                builder: (context, orientation) =>
                    orientation == Orientation.portrait
                        ? verticalPart()
                        : horizontalPart(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget horizontalPart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      child: Stack(
        children: [
          Center(
            child: FutureBuilder(
                future: _initializedVideoPlayer,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        height: _videoPlayerController.value.size.height,
                        width: _videoPlayerController.value.size.width,
                        child: AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
          Positioned(
            top: 0,
            child: InkWell(
              onTap: () {

                return setPortrait();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 14, top: 8),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: 0,
            // height: 20,
            // width: 20,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.transparent,
              child: GestureDetector(
                onTap: incrementCounter,
                child: Icon(
                  _videoPlayerController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  size: 55,
                  color: Colors.blue.shade50,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 30,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "00:${_start <= 9 ? '0$_start' : _start}/00:${_videoPlayerController.value.duration.inSeconds}",
                style: GoogleFonts.dmSans(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  final isPortrait = MediaQuery.of(context).orientation ==
                      Orientation.portrait;

                  if (isPortrait) {
                    setLandScape();
                    setState(() {
                      isActive = true;
                    });
                  } else {
                    setPortrait();
                    setState(() {
                      isActive = false;
                    });
                  }
                },
                child: Icon(
                  Icons.rotate_left,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 15),
              child: VideoProgressIndicator(
                _videoPlayerController,
                allowScrubbing: true,
                padding: EdgeInsets.only(top: 6, bottom: 6, left: 5, right: 5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future setLandScape() async => await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

  Future setPortrait() async {

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return verticalPart();
  }

  Widget showImage(int index) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          fit: BoxFit.contain,
          image: NetworkImage(
            "${widget.linkImage}/${widget.url[currentPageValue].media}",
          ),
        ),
      ),
    );
  }



  Widget verticalPart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      child: PageView.builder(
        controller: controller,
        onPageChanged: (value) {
          currentPageValue = value;
          print("value : $value");
          setState(() {});
          // getChangedPageAndMoveBar(value);
        },

        itemCount: widget.url.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {

          print("Hello World : ${widget.linkImage}/${widget.url[index].media}");
          return widget.url[currentPageValue]
                      .mediaType ==
                  "video"
              ? Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3.7,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        FutureBuilder(
                            future: _initializedVideoPlayer,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return AspectRatio(
                                  aspectRatio:
                                      _videoPlayerController.value.aspectRatio,
                                  child: VideoPlayer(_videoPlayerController),
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                        GestureDetector(
                          onTap: incrementCounter,
                          child: CircleAvatar(
                            radius: 27,
                            backgroundColor: Colors.black.withOpacity(0.6),
                            child: Icon(_videoPlayerController.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "00:${_start <= 9 ? '0$_start' : _start}/00:${_videoPlayerController.value.duration.inSeconds}",
                            style: GoogleFonts.dmSans(color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              final isPortrait =
                                  MediaQuery.of(context).orientation ==
                                      Orientation.portrait;

                              if (isPortrait) {
                                setLandScape();
                                setState(() {
                                  isActive = true;
                                });
                              } else {
                                setPortrait();
                                setState(() {
                                  isActive = false;
                                });
                              }
                            },
                            child: Icon(
                              Icons.rotate_left,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: VideoProgressIndicator(
                        _videoPlayerController,
                        allowScrubbing: true,
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 5, right: 5),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                )
              : InteractiveViewer(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: showImage(index),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  imagevideoShare() async {
    var request;
    Map<String, List<int>> imgMap = {};
    Uint8List bytes;
    for (int i = 0; i < widget.url.length; i++) {
      if (widget.url[i].mediaType == "video") {
        request = await HttpClient()
            .getUrl(Uri.parse("${widget.linkVideo}/${widget.url[i].media}"));

        var response = await request.close();
        print(response);
        bytes = await consolidateHttpClientResponseBytes(response);

        imgMap[i.toString() + ".mp4"] = bytes;
      }

      if (widget.url[i].mediaType == "image") {
        request = await HttpClient()
            .getUrl(Uri.parse("${widget.linkImage}/${widget.url[i].media}"));

        var response = await request.close();
        print(response);
        bytes = await consolidateHttpClientResponseBytes(response);

        imgMap[i.toString() + ".jpg"] = bytes;
      }
    }
    // if (imgMap[".mp4"].isEmpty) return false;
    await Share.files(
      "image/video",
      imgMap,
      "image/jpg/video/mp4",
    );
  }
}
