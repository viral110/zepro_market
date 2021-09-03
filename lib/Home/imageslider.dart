

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();

  }

  final _imageUrls = [
    "https://spectrumproperties.co.ug/wp-content/uploads/2018/08/IMG_7973.jpg",
    "https://spectrumproperties.co.ug/wp-content/uploads/2018/08/IMG_8427.jpg",
    "https://spectrumproperties.co.ug/wp-content/uploads/2018/08/IMG_8296.jpg",
    "https://spectrumproperties.co.ug/wp-content/uploads/2018/08/IMG_8691.jpg"
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: SizedBox(
          // height: 150.0,
          // width: 300.0,
          child: Carousel(
            boxFit: BoxFit.cover,
            autoplay: true,

            animationDuration: Duration(milliseconds: 800),
            dotSize: 4.0,
            dotColor: Colors.grey,
            dotIncreasedColor: Colors.blue[900],
            dotBgColor: Colors.transparent,
            dotPosition: DotPosition.bottomCenter,
            dotVerticalPadding: 10.0,
            showIndicator: true,
            indicatorBgPadding: 7.0,
            images: [
              NetworkImage('https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fjooinn.com%2Fimages%2Fdramatic-landscape-7.jpg&f=1&nofb=1'),
              NetworkImage('https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fjooinn.com%2Fimages%2Fsunset-532.png&f=1&nofb=1'),
              NetworkImage("https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fthewowstyle.com%2Fwp-content%2Fuploads%2F2015%2F01%2Fnature-image.jpg&f=1&nofb=1"),
            ],
          ),
        ),
        ),



    );
  }
}
