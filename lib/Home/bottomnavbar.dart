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
  const BottomNavBar({Key key}) : super(key: key);

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
      ApiServices().microProducts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: drawerKey,
        body: tabsView[_currentIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        ));
  }
}
