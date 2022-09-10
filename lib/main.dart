import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jalaram/Data_Provider/data_provider.dart';
import 'package:jalaram/Data_Provider/favourite_provider.dart';

import 'package:jalaram/Home/bottomnavbar.dart';
import 'package:jalaram/Home/homepage.dart';
import 'package:jalaram/Home/imageslider.dart';
import 'package:jalaram/Home/notification_page.dart';
import 'package:jalaram/Register_Form/register.dart';
import 'package:jalaram/Splash_Screen/splashscreen.dart';

import 'package:jalaram/login_details/loginwithmobile.dart';
import 'package:http/http.dart' as http;

import 'dart:async';

import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'Connect_API/api.dart';
import 'Data_Provider/store_list_bool.dart';
import 'Helper/string_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  getNotificationApi();
  await Workmanager().initialize(
    getNotificationApi,
    isInDebugMode: false,
  );
  await Workmanager().registerPeriodicTask(
    "1",
    'simplePeriodicTask',
    // existingWorkPolicy: ExistingWorkPolicy.append,
    frequency: Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
  // await Firebase.initializeApp();
  runApp(MyApp());
}

String message = "";
String productId = "";
bool isLoaded = false;

int lengthOfNotify = 0;

List<String> messageOfNotify = [];

Future getNotificationApi() async {
  try {
    final result = await InternetAddress.lookup("google.com");
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      var url = Uri.parse(StringHelper.BASE_URL + "api/notification");
      final response = await http.get(url, headers: {
        "Accept": "Application/json",
      });
      var decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(decoded["response"][0]["message"]);


        lengthOfNotify = decoded["response"].length;
        message = decoded["response"][lengthOfNotify-1]["message"];
        for(int i=0;i<=lengthOfNotify;i++){
          messageOfNotify.add(decoded['response'][i]['message']);
        }

        print("length of Notify : $messageOfNotify");
        isLoaded = true;
        callbackDispatcher();

        return response;
      } else {
        Fluttertoast.showToast(msg: "${decoded['message']}");
      }
    } else {
      Fluttertoast.showToast(msg: "No Internet!!!");
    }
  } catch (e) {
    // Fluttertoast.showToast(msg: "${e.toString()}");
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flip =
        new FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = new IOSInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android: android, iOS: IOS);
    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip);

    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(flip) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      '1', 'notification',
      channelDescription: 'Hello World',
      playSound: false,
      importance: Importance.max,
      priority: Priority.high);

  var iOSPlatformChannelSpecifics =
      new IOSNotificationDetails(presentSound: false);
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flip.show(
    0,
    "Deluxe Ecommerce",
    "$message",
    platformChannelSpecifics,
    payload: 'No_Sound',
  );
  print("Hello Gujarat");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<DataProvider>(create: (_) => DataProvider()),
        // ListenableProvider<FavouriteListProvider>(create: (_) => FavouriteListProvider()),
        ListenableProvider<StoreListBoolProvider>(create: (_) => StoreListBoolProvider(),),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: SplashScreen(),
      ),
    );
  }
}
