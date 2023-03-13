import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Model/notification_model.dart';
import 'package:jalaram/main.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 12, bottom: 10),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color.fromRGBO(255, 78, 91, 1),
                      )),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "Notifications",
                    style: GoogleFonts.aBeeZee(
                        color: Color.fromRGBO(255, 78, 91, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 2),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height/2.5,
            ),

            Align(
              alignment: Alignment.center,
              child: Text(
                "No any notification found",
                style: GoogleFonts.aBeeZee(
                    color: Colors.black, fontSize: 13, letterSpacing: 0.5),
              ),
            ),

            // Expanded(
            //   child: ListView.builder(
            //     itemCount: lengthOfNotify,
            //     itemBuilder: (context, index) {
            //       return Column(
            //         children: [
            //           ListTile(
            //             leading: Image.asset(
            //               "assets/bell.jpeg",
            //               height: 35,
            //               width: 35,
            //             ),
            //             title: Text(messageOfNotify[index]),
            //           ),
            //           Divider(),
            //         ],
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
