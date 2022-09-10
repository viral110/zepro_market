import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:jalaram/Connect_API/api.dart';
import 'package:jalaram/Model/get_feed_back_user.dart';

class Suggestion extends StatefulWidget {
  const Suggestion({Key key}) : super(key: key);

  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  List<File> files = [];

  List<String> multipleFiles = [];

  List<String> serverImages = [];

  GetFeedBack gfb;

  bool isGetFeedback = false;

  TextEditingController txtController = TextEditingController();

  List<String> storeResponse = [];

  GlobalKey<FormState> key = GlobalKey<FormState>();

  getFeedImages() async {
    // await Future.delayed(Duration(milliseconds: 300), () async {
    Response response = await ApiServices().getFeedBackUser(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      gfb = GetFeedBack.fromJson(decoded);
      print(gfb.feebback);
      if(gfb.feebback != null && gfb.feebback.isNotEmpty){
        if (gfb.feebback.last.feedback != null) {
          txtController.text = gfb.feebback.last.feedback;
        }
      }
      // if(gfb.feebback.isNotEmpty){
      //   if(gfb.feebback.last.feedbackImages != null){
      //     for(int i=0;i<gfb.feebback.last.feedbackImages.length;i++){
      //       counter++;
      //     }
      //   }
      // }

      Fluttertoast.showToast(msg: "get profile products");
      setState(() {
        isGetFeedback = true;
      });
    }
    // });
  }

  int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    getFeedImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isGetFeedback == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: key,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 10, right: 10, bottom: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Color.fromRGBO(255, 78, 91, 1),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Suggestion",
                          style: GoogleFonts.aBeeZee(
                              color: Color.fromRGBO(255, 78, 91, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 15,
                    thickness: 1.1,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                      child: Text(
                    "We would like to hear you",
                    style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 22,
                        letterSpacing: 1),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      "your suggestion is important for us to provide value for money product to our customers",
                      style: GoogleFonts.dmSans(
                        color: Colors.grey,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                    child: Text(
                      "Your Suggestion",
                      style: GoogleFonts.dmSans(
                          color: Colors.grey, fontSize: 15, letterSpacing: 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                    child: TextFormField(
                      maxLines: 6,
                      controller: txtController,
                      validator: (String val) {
                        String value = "";
                        if (val == null || val.isEmpty) {
                          value = "Enter Something";
                          return value;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15, top: 15),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.3)),
                        ),
                        // errorBorder: InputBorder.none,
                        // disabledBorder: InputBorder.none,
                        fillColor: Colors.grey.withOpacity(0.3),

                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
                    child: Text(
                      "Attachment",
                      style: GoogleFonts.dmSans(
                          color: Colors.grey, fontSize: 15, letterSpacing: 1),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 0, top: 10),
                          child: Container(
                            height: 50,
                            width: 80,
                            child: GestureDetector(
                                onTap: () {
                                  pickFiles();
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Color.fromRGBO(255, 78, 91, 1),
                                )),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 78, 91, 0.4),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      gfb.feebback.isEmpty
                      ? Container()
                      : Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 0, top: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: ListView.builder(
                              itemCount: multipleFiles.isEmpty
                                  ? gfb.feebback.last.feedbackImages == null ? 0 : gfb.feebback.last.feedbackImages.length
                                  : multipleFiles.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Positioned(
                                          child: Container(
                                            height: 50,
                                            width: 80,

                                            // child: Image.file(
                                            //
                                            //   fit: BoxFit.cover,
                                            // ),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: multipleFiles.isNotEmpty
                                                    ? FileImage(
                                                        File(multipleFiles[
                                                            index]),
                                                      )
                                                    : NetworkImage(
                                                        "${gfb.url}/${gfb.feebback.last.feedbackImages[index]}"),
                                                fit: BoxFit.contain,
                                              ),
                                              color: Color.fromRGBO(
                                                  255, 78, 91, 0.4),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                        multipleFiles.length == 0
                                            ? Container()
                                            : Positioned(
                                                child: GestureDetector(
                                                  child: CircleAvatar(
                                                    child: Icon(Icons.close,
                                                        size: 15),
                                                    radius: 10,
                                                  ),
                                                  onTap: () {
                                                    multipleFiles
                                                        .removeAt(index);
                                                    setState(() {});
                                                  },
                                                ),
                                                // left: 0,
                                                right: 0,
                                                top: 0,
                                              ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      if (key.currentState.validate()) {
                        setState(() {
                          isSentImages = true;
                        });
                        await ApiServices()
                            .postFeedBack(context, txtController.text);
                        for (int i = 0; i < multipleFiles.length; i++) {
                          await ApiServices().postFeedbackImages(
                              context, feedbackId, File(multipleFiles[i]));
                        }
                        setState(() {
                          isSentImages = false;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      height: 50,
                      
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(255, 78, 91, 1).withOpacity(0.8),
                      ),
                      child: isSentImages == true ? CircularProgressIndicator() : Text("Submit",style: TextStyle(color: Colors.white, fontSize: 18,letterSpacing: 1),),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  bool isSentImages = false;

  void pickFiles() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc'],
        allowMultiple: true);

    if (result != null) {
      files = result.paths.map((path) {
        multipleFiles.add(path);
        setState(() {});
        return File(path);
      }).toList();

      print("Files : $multipleFiles");
    } else {
      // User canceled the picker
    }
  }
}
