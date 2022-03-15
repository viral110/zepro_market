import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
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
    "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80",
    "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80",
    "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80"
  ];

  int activePage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
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
        showIndicator: false,
        indicatorBgPadding: 7.0,
        images: [
          NetworkImage(
              'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fjooinn.com%2Fimages%2Fdramatic-landscape-7.jpg&f=1&nofb=1'),
          NetworkImage(
              'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fjooinn.com%2Fimages%2Fsunset-532.png&f=1&nofb=1'),
          NetworkImage(
              "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fthewowstyle.com%2Fwp-content%2Fuploads%2F2015%2F01%2Fnature-image.jpg&f=1&nofb=1"),
        ],
      ),
    );
  }
}
