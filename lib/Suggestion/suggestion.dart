import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Suggestion extends StatefulWidget {
  const Suggestion({Key key}) : super(key: key);

  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
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
            style: GoogleFonts.aBeeZee(
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
              style: GoogleFonts.aBeeZee(
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
              style: GoogleFonts.aBeeZee(
                  color: Colors.grey, fontSize: 15, letterSpacing: 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
            child: TextFormField(
              maxLines: 6,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15, top: 15),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
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
              style: GoogleFonts.aBeeZee(
                  color: Colors.grey, fontSize: 15, letterSpacing: 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 300, top: 10),
            child: Container(
              height: 50,
              child: GestureDetector(
                  onTap: () {
                    pickFiles();
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
        ],
      ),
    );
  }

  void pickFiles() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc'],
        allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();
    } else {
      // User canceled the picker
    }
  }
}
