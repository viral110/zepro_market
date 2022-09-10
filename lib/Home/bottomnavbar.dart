import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Home/homepage.dart';
import 'package:jalaram/Menu_Drawer/profile.dart';
import 'package:jalaram/WishList/wishlist.dart';
import 'package:jalaram/add_to_cart_part/add_to_cart_page.dart';
import 'package:jalaram/product_catalogue/products.dart';

// class BottomNavBar extends StatefulWidget {
//   @override
//   _BottomNavBarState createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar>
//     with SingleTickerProviderStateMixin {
//   GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
//   AnimationController _animationController;
//   Animation<double> animation;
//   CurvedAnimation curve;
//
//   final tabsView = <Widget>[
//     HomePage(),
//     WishList(),
//     Products(),
//     AddToCartPage(),
//     Profile(),
//   ];
//
//   int _currentIndex = 0;
//   GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
//
//   void _updateIndex(int value) {
//     value == 4
//         ? drawerKey.currentState.openEndDrawer()
//         : setState(() {
//             _currentIndex = value;
//             ApiServices().microProducts(context);
//
//           });
//   }
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   final systemTheme = SystemUiOverlayStyle.light.copyWith(
//   //     systemNavigationBarColor: Colors.grey,
//   //     systemNavigationBarIconBrightness: Brightness.light,
//   //   );
//   //   SystemChrome.setSystemUIOverlayStyle(systemTheme);
//   //
//   //   _animationController = AnimationController(
//   //     duration: Duration(seconds: 1),
//   //     vsync: this,
//   //   );
//   //   curve = CurvedAnimation(
//   //     parent: _animationController,
//   //     curve: Interval(
//   //       0.5,
//   //       1.0,
//   //       curve: Curves.fastOutSlowIn,
//   //     ),
//   //   );
//   //   animation = Tween<double>(
//   //     begin: 0,
//   //     end: 1,
//   //   ).animate(curve);
//   //
//   //   Future.delayed(
//   //     Duration(seconds: 1),
//   //         () => _animationController.forward(),
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: drawerKey,
//       endDrawer: Profile(),
//       body: tabsView[_currentIndex],
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           border: Border(top: BorderSide(color: Colors.grey[300])),
//         ),
//         height: MediaQuery.of(context).size.height / 10,
//         child: BottomNavigationBar(
//           elevation: 20,
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: Color.fromRGBO(255, 78, 91, 1),
//           selectedFontSize: 12,
//           selectedLabelStyle: GoogleFonts.aBeeZee(
//             letterSpacing: 1,
//           ),
//           backgroundColor: Colors.white,
//           unselectedItemColor: Colors.black,
//           currentIndex: _currentIndex,
//           onTap: _updateIndex,
//           items: [
//             BottomNavigationBarItem(
//               icon: _currentIndex == 0
//                   ? Padding(
//                       padding: const EdgeInsets.only(bottom: 7),
//                       child: Image.asset(
//                         'assets/new/home.png',
//                         height: 23,
//                         width: 23,
//                       ),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.only(bottom: 7),
//                       child: Image.asset(
//                         "assets/new/home3.png",
//                         height: 23,
//                         width: 23,
//                         color: Colors.black,
//                       ),
//                     ),
//               label: "Home",
//             ),
//             BottomNavigationBarItem(
//               icon: _currentIndex == 1
//                   ? Padding(
//                       padding: const EdgeInsets.only(bottom: 7),
//                       child: Image.asset(
//                         "assets/new/Wishlist.png",
//                         height: 23,
//                         width: 23,
//                       ),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.only(bottom: 7),
//                       child: Image.asset(
//                         "assets/new/Wishlist2.png",
//                         height: 23,
//                         width: 23,
//                         color: Colors.black,
//                       ),
//                     ),
//               label: "Wishlist",
//             ),
//             BottomNavigationBarItem(
//                 icon: _currentIndex == 2
//                     ? Image.asset(
//                         "assets/new/Product2.png",
//                         height: 35,
//                         width: 35,
//                         fit: BoxFit.fill,
//                       )
//                     : Image.asset(
//                         "assets/new/Product.png",
//                         height: 32,
//                         width: 32,
//                         fit: BoxFit.fill,
//                         color: Colors.black,
//                       ),
//                 label: "Products"),
//             BottomNavigationBarItem(
//                 icon: _currentIndex == 3
//                     ? Padding(
//                         padding: const EdgeInsets.only(bottom: 7),
//                         child: Image.asset(
//                           "assets/new/cart4.png",
//                           height: 27,
//                           width: 27,
//                         ),
//                       )
//                     : Image.asset(
//                         "assets/new/cart5.png",
//                         height: 23,
//                         width: 23,
//                         color: Colors.black,
//                       ),
//                 label: "Cart"),
//             BottomNavigationBarItem(
//                 icon: _currentIndex == 4
//                     ? Image.asset(
//                         "assets/new/menu.png",
//                         height: 27,
//                         width: 27,
//                         color: Color.fromRGBO(255, 78, 91, 1),
//                         fit: BoxFit.fill,
//                       )
//                     : Image.asset(
//                         "assets/new/menu.png",
//                         height: 27,
//                         width: 27,
//                         color: Colors.black,
//                         fit: BoxFit.fitHeight,
//                       ),
//                 label: "More"),
//           ],
//         ),
//       ),
//
//     );
//   }
// }

class BottomNavBar extends StatefulWidget {
  int index;
  BottomNavBar({Key key,this.index}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final tabsView = <Widget>[
    HomePage(),
    WishList(),
    Products(),
    AddToCartPage(),
    Profile(),
  ];

  int _currentIndex = 0;

  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  void _updateIndex(int value) {

    setState(() {
      _currentIndex = value;
      // _currentIndex = widget.index;
      ApiServices().microProducts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex == 0) {
          showDilogE(context: context);
        } else if (_currentIndex == 1 || _currentIndex == 2 || _currentIndex == 3 || _currentIndex == 4) {
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(),
            ),
          );
        }
        return true;
      },
      child: Scaffold(
          key: drawerKey,
          body: tabsView[_currentIndex],
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Card(
              elevation: 4,
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  // border: Border.all(width: 1.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BottomNavigationBar(
                      elevation: 20,
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: Color.fromRGBO(255, 78, 91, 1),
                      selectedFontSize: 12,
                      selectedLabelStyle: GoogleFonts.aBeeZee(
                        letterSpacing: 1,
                      ),
                      backgroundColor: Colors.white,
                      unselectedItemColor: Colors.black,
                      currentIndex: _currentIndex,
                      onTap: _updateIndex,
                      items: [
                        BottomNavigationBarItem(
                          icon: _currentIndex == 0
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 7),
                                  child: Image.asset(
                                    'assets/new/home.png',
                                    height: 23,
                                    width: 23,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 7),
                                  child: Image.asset(
                                    "assets/new/home3.png",
                                    height: 23,
                                    width: 23,
                                    color: Colors.black,
                                  ),
                                ),
                          label: "Home",
                        ),
                        BottomNavigationBarItem(
                          icon: _currentIndex == 1
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 7),
                                  child: Image.asset(
                                    "assets/new/Wishlist.png",
                                    height: 23,
                                    width: 23,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 7),
                                  child: Image.asset(
                                    "assets/new/Wishlist2.png",
                                    height: 23,
                                    width: 23,
                                    color: Colors.black,
                                  ),
                                ),
                          label: "Wishlist",
                        ),
                        BottomNavigationBarItem(
                            icon: _currentIndex == 2
                                ? Image.asset(
                                    "assets/new/Product2.png",
                                    height: 35,
                                    width: 35,
                                    fit: BoxFit.fill,
                                  )
                                : Image.asset(
                                    "assets/new/Product.png",
                                    height: 32,
                                    width: 32,
                                    fit: BoxFit.fill,
                                    color: Colors.black,
                                  ),
                            label: "Products"),
                        BottomNavigationBarItem(
                            icon: _currentIndex == 3
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 7),
                                    child: Image.asset(
                                      "assets/new/cart4.png",
                                      height: 27,
                                      width: 27,
                                    ),
                                  )
                                : Image.asset(
                                    "assets/new/cart5.png",
                                    height: 23,
                                    width: 23,
                                    color: Colors.black,
                                  ),
                            label: "Cart"),
                        BottomNavigationBarItem(
                            icon: _currentIndex == 4
                                ? Image.asset(
                                    "assets/new/menu.png",
                                    height: 27,
                                    width: 27,
                                    color: Color.fromRGBO(255, 78, 91, 1),
                                    fit: BoxFit.fill,
                                  )
                                : Image.asset(
                                    "assets/new/menu.png",
                                    height: 27,
                                    width: 27,
                                    color: Colors.black,
                                    fit: BoxFit.fitHeight,
                                  ),
                            label: "More"),
                      ]),
                ),
              ),
            ),
          )),
    );
  }

  showDilogE({BuildContext context}) {
    return showDialog(
      context: context,
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: AlertDialog(
          insetPadding: EdgeInsets.all(10),
          contentPadding: EdgeInsets.zero,
          title: Text(
            "Are you Sure?",
            style: GoogleFonts.dmSans(fontSize: 18),
          ),
          content: Padding(
            padding: const EdgeInsets.only(
              left: 24,
              top: 8,
              bottom: 8,
            ),
            child: Text(
              "Do you want to exit an App",
              style: GoogleFonts.dmSans(fontSize: 16),
            ),
          ),
          actions: [
            Container(
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
                child: Text(
                  "No",
                  style:
                      GoogleFonts.aBeeZee(color: Color.fromRGBO(4, 75, 90, 1)),
                ),
              ),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Color.fromRGBO(4, 75, 90, 1), width: 1.5),
                borderRadius: BorderRadius.circular(5),
              ),
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
              ),
              child: RaisedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  "Yes",
                  style: GoogleFonts.aBeeZee(color: Colors.white),
                ),
                color: Color.fromRGBO(4, 75, 90, 1),
              ),
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
