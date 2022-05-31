import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jalaram/Model/micro_product_details.dart';
import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';
import 'package:video_player/video_player.dart';

class ImageZoom extends StatefulWidget {
  String linkImage;
  String linkVideo;
  List<BannersMicroDetails> url;
  String mediaTypeZoom;

  ImageZoom(
      {Key key, this.linkImage, this.url, this.linkVideo, this.mediaTypeZoom})
      : super(key: key);

  @override
  State<ImageZoom> createState() => _ImageZoomState();
}

class _ImageZoomState extends State<ImageZoom> {
  PageController controller = PageController();

  int currentPageValue = 0;

  Future<void> _initializedVideoPlayer;

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
            "${widget.linkVideo}/${widget.url[i].media}");
        _initializedVideoPlayer = _videoPlayerController.initialize();
        _videoPlayerController.addListener(() {
          setState(() {});
        });

        _videoPlayerController.setLooping(true);
        _videoPlayerController.setVolume(1.0);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    forVideoInitialize();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  void incrementCounter() {
    setState(() {
      _videoPlayerController.value.isPlaying
          ? _videoPlayerController.pause()
          : _videoPlayerController.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          InkWell(onTap: () async {
            await imagevideoShare();
          },child: Icon(Icons.share, color: Colors.white)),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
          child: PageView.builder(
            controller: controller,
            onPageChanged: (value) {
              getChangedPageAndMoveBar(value);
            },
            itemCount: widget.url.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                child: widget.url[index].mediaType == "image"
                    ? Image.network(
                        "${widget.linkImage}/${widget.url[index].media}")
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          FutureBuilder(
                              future: _initializedVideoPlayer,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return AspectRatio(
                                    aspectRatio: _videoPlayerController
                                        .value.aspectRatio,
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
              );
            },
          ),
        ),
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
