import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jalaram/Home/bottomnavbar.dart';
import 'package:jalaram/Splash_Screen/splashscreen.dart';

class InternetConnectionPage extends StatefulWidget {
  bool isSplash;
  InternetConnectionPage({Key key,this.isSplash}) : super(key: key);

  @override
  _InternetConnectionPageState createState() => _InternetConnectionPageState();
}

class _InternetConnectionPageState extends State<InternetConnectionPage> {
  StreamSubscription internetConnection;
  bool isOffline = false;

  @override
  void initState() {
    if(widget.isSplash){
      checkInternetFunc();
    }else{
      checkInternetFuncForBottomBar();
    }
    // TODO: implement initState
    super.initState();
  }

  checkInternetFunc() {
    internetConnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isOffline = true;
        });
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          isOffline = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen(),));
      }
    });
  }

  checkInternetFuncForBottomBar() {
    internetConnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isOffline = true;
        });
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          isOffline = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavBar(index: 0),));
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    internetConnection.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(4, 75, 90, 1).withOpacity(0.3),
                    ),
                    // padding: EdgeInsets.only(left: 35, right: 35),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Internet Connection",
                          style: GoogleFonts.dmSans(
                              color: Color.fromRGBO(22, 2, 105, 1),
                              fontSize: 20),
                        ),
                        SizedBox(
                          width: 215,
                          child: Text(
                            "It Seems like you do not have working internet connection, Please enable Wi-Fi/Mobile data",
                            style: GoogleFonts.dmSans(fontSize: 15.5),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  SystemNavigator.pop();
                                },
                                child: Text(
                                  "ok",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 18,
                                    color: Color.fromRGBO(4, 75, 90, 1),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  checkInternetFunc();
                                },
                                child: Text(
                                  "try again!",
                                  style: GoogleFonts.dmSans(
                                      color: Color.fromRGBO(4, 75, 90, 1),
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
