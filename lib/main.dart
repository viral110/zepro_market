import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jalaram/Data_Provider/data_provider.dart';
import 'package:jalaram/Home/bottomnavbar.dart';
import 'package:jalaram/Home/homepage.dart';
import 'package:jalaram/Home/imageslider.dart';
import 'package:jalaram/Register_Form/register.dart';
import 'package:jalaram/Splash_Screen/splashscreen.dart';

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
        ListenableProvider<DataProvider>(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: LoginWithMobile(),
      ),
    );
  }
}
