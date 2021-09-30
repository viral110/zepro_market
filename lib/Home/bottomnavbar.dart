import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jalaram/Home/homepage.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  final tabsView = <Widget>[
    HomePage(),
    Container(
      color: Colors.lightBlue,
    ),
    Container(
      color: Colors.lightGreen,
    ),
    Container(
      color: Colors.redAccent,
    ),
    Container(
      color: Colors.yellowAccent,
    ),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   final systemTheme = SystemUiOverlayStyle.light.copyWith(
  //     systemNavigationBarColor: Colors.grey,
  //     systemNavigationBarIconBrightness: Brightness.light,
  //   );
  //   SystemChrome.setSystemUIOverlayStyle(systemTheme);
  //
  //   _animationController = AnimationController(
  //     duration: Duration(seconds: 1),
  //     vsync: this,
  //   );
  //   curve = CurvedAnimation(
  //     parent: _animationController,
  //     curve: Interval(
  //       0.5,
  //       1.0,
  //       curve: Curves.fastOutSlowIn,
  //     ),
  //   );
  //   animation = Tween<double>(
  //     begin: 0,
  //     end: 1,
  //   ).animate(curve);
  //
  //   Future.delayed(
  //     Duration(seconds: 1),
  //         () => _animationController.forward(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabsView[_page],
      bottomNavigationBar: CurvedNavigationBar(

        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Image.asset(
            "assets/wholesaler.png",
            height: 37,
            width: 37,
            color: Colors.deepPurple,
          ),
          Image.asset(
            "assets/cubes.png",
            height: 30,
            width: 30,
          ),
          Image.asset(
            "assets/shopping-cart.png",
            height: 30,
            width: 30,
          ),
          Icon(Icons.perm_identity, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      // floatingActionButton: ScaleTransition(
      //   scale: animation,
      //   child: FloatingActionButton(
      //       elevation: 8,
      //       backgroundColor: Colors.yellow,
      //       child: Icon(
      //         Icons.brightness_3,
      //         color: Colors.green,
      //
      //       ),
      //       onPressed: () {
      //         _animationController.reset();
      //         _animationController.forward();
      //       },
      //     ),
      //   ),
      //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //   bottomNavigationBar: AnimatedBottomNavigationBar.builder(
      //     itemCount: tabsView.length,
      //     tabBuilder: (int index, bool isActive) {
      //       final color = isActive ? Colors.grey : Colors.white;
      //       return Column(
      //         mainAxisSize: MainAxisSize.min,
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //
      //
      //         ],
      //       );
      //     },
      //     backgroundColor: Colors.yellow,
      //
      //     notchAndCornersAnimation: animation,
      //     splashSpeedInMilliseconds: 300,
      //     notchSmoothness: NotchSmoothness.defaultEdge,
      //     gapLocation: GapLocation.end,
      //     leftCornerRadius: 32,
      //     rightCornerRadius: 32,
      //     onTap: (index) => setState(() => _page = index), activeIndex: _page,
      //   ),
    );
  }
}
