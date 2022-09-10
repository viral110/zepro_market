import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Home/bottomnavbar.dart';
import 'package:jalaram/login_details/loginwithmobile.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 7),
      () {
        print("Hello");
        if (storeKeyByGet.read('access_token') != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavBar(),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginWithMobile(),
              ));
        }

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => LoginWithMobile(),
        //   ),
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Deluxe_logo.gif"),
              ),
            ),
            // child: Image.asset("assets/deluxelogo.jpg",height: 300,width: 300,),
          ),
        ),
      ),
    );
  }
}
