import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jalaram/Home/homepage.dart';
import 'package:jalaram/Home/imageslider.dart';
import 'package:jalaram/Register_Form/register.dart';
import 'package:jalaram/Splash_Screen/splashscreen.dart';
import 'package:jalaram/bloc_pattern/blocpattern.dart';
import 'package:jalaram/login_details/loginwithmobile.dart';
import 'dart:async';

import 'package:provider/provider.dart';



void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginWithAuth>(create: (context) => LoginWithAuth()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',

        home: LoginWithMobile(),
      ),
    );
  }
}

