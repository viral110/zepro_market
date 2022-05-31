import 'dart:async';
import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jalaram/Model/multiple_banner_home.dart';

import '../Connect_API/api.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider>
    with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
    fetchMultipleBannerHome();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(controller.hasClients){
        controller.animateToPage(
          currentPageValue,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeIn,
        );
      }
    });
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if(isLoading == true){
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

  // autoScrollBanner(){
  //   if(isLoading == true){
  //
  //   }
  //
  // }

  MultipleBannerHome mbh;

  bool isLoading = false;
  bool end = false;

  int currentPageValue = 0;

  fetchMultipleBannerHome() async {
    await Future.delayed(Duration(milliseconds: 100), () async {
      Response response = await ApiServices().multipleBanner(context);
      var decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        mbh = MultipleBannerHome.fromJson(decoded);

        setState(() {
          isLoading = true;
        });
      }
    });
  }



  List<Widget> _imageWithWidget = [
    FittedBox(
      child: Container(
        height: 200,
        width: 400,
        margin: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80"),
              fit: BoxFit.fill,
            )),
      ),
    ),
    FittedBox(
      child: Container(
        height: 200,
        width: 400,
        margin: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80"),
              fit: BoxFit.fill,
            )),
      ),
    ),
    FittedBox(
      child: Container(
        height: 200,
        width: 400,
        margin: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(
                "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    ),
  ];

  List<String> _imageUrls = [
    'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fjooinn.com%2Fimages%2Fdramatic-landscape-7.jpg&f=1&nofb=1',
    'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fjooinn.com%2Fimages%2Fsunset-532.png&f=1&nofb=1',
    "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fthewowstyle.com%2Fwp-content%2Fuploads%2F2015%2F01%2Fnature-image.jpg&f=1&nofb=1",
  ];

  PageController controller = PageController();

  int activePage = 0;

  void getChangedPageAndMoveBar(int page) {
    activePage = page;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: isLoading == true
       ? PageView.builder(
          itemCount: mbh.banners.length,
          physics: ClampingScrollPhysics(),
          onPageChanged: (value) {
            getChangedPageAndMoveBar(value);
          },
          controller: controller,
          itemBuilder: (context, index) {
            return Container(
              child: Image.network(mbh.url+'/'+mbh.banners[index].banner),
            );
          },
        ): Container(
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
        ));
  }
}

//

