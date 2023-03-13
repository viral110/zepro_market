import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:jalaram/Model/multiple_banner_home.dart';

import '../Connect_API/api.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider>
    with SingleTickerProviderStateMixin {
  MultipleBannerHome mbh;

  bool isLoading = false;

  fetchMultipleBannerHome() async {
    await Future.delayed(Duration(milliseconds: 100), () async {
      final response = await ApiServices().multipleBanner(context);
      var decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        mbh = MultipleBannerHome.fromJson(decoded);

        setState(() {
          isLoading = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMultipleBannerHome();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (controller.hasClients) {
    //     controller.animateToPage(
    //       currentPageValue,
    //       duration: Duration(milliseconds: 1000),
    //       curve: Curves.easeIn,
    //     );
    //   }
    // });
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (isLoading == true) {
        if (currentPageValue == mbh.banners.length) {
          end = true;
        } else if (currentPageValue == 0) {
          end = false;
        }
      }

      if (end == false) {
        currentPageValue++;
      } else {
        currentPageValue--;
      }

      controller.animateToPage(
        currentPageValue,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeIn,
      );
    });


    // autoScrollBanner();
  }

  bool end = false;

  int currentPageValue = 0;

  PageController controller = PageController();

  int activePage = 0;

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: isLoading == true
          ? mbh.banners == null || mbh.banners.length == 0
              ? Container()
              : PageView.builder(

                  itemCount: mbh.banners.length,
                  physics: ClampingScrollPhysics(),
                  onPageChanged: (value) {
                    setState(() {
                      currentPageValue = value;
                    });
                  },
                  controller: controller,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Image.network(
                          mbh.url + '/' + mbh.banners[index].banner),
                    );
                  },
                )
          : Container(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            ),
    );
  }
}

//
