import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jalaram/login_details/loginwithmobile.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final picker = ImagePicker();

  int val = 1;
  bool _value = false;

  String _streetNumber = '';
  String _street = '';
  String _city = '';
  String _zipCode = '';
  File _image;
  String stateValue = "";
  String cityValue = "";
  String countryValue = "";

  TextEditingController _cityAndStateController = TextEditingController();

  @override
  void dispose() {
    _cityAndStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Color.fromRGBO(49, 60, 51, 1)),
                    SizedBox(
                      width: 60,
                    ),
                    Align(
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.nunito(
                            fontSize: 32,
                            color: Color.fromRGBO(49, 60, 51, 1),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2),
                      ),
                      alignment: Alignment.topRight,
                    ),
                  ],
                ),
                SizedBox(
                  height: 27,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CircleAvatar(
                        radius: 64,
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(58),
                                child: Image.file(
                                  _image,
                                  height: 130,
                                  width: 130,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(61),
                                ),
                                width: 124,
                                height: 124,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          splashColor: Colors.white,
                          onPressed: () {
                            _showPicker(context);
                          },
                          icon: Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Note: Your own Profile picture is mandatory",
                    style: GoogleFonts.aBeeZee(),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Name",
                  style: GoogleFonts.aBeeZee(),
                ),
                SizedBox(
                  height: 7,
                ),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      contentPadding: EdgeInsets.all(12)),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Email",
                  style: GoogleFonts.aBeeZee(),
                ),
                SizedBox(
                  height: 7,
                ),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      contentPadding: EdgeInsets.all(10)),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Company Name",
                  style: GoogleFonts.aBeeZee(),
                ),
                SizedBox(
                  height: 7,
                ),
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: Image.asset(
                        "assets/company.png",
                        height: 10,
                        width: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      contentPadding: EdgeInsets.all(10)),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Where are you from?",
                  style: GoogleFonts.aBeeZee(),
                ),
                Row(

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Radio(
                            value: 1,
                            groupValue: val,
                            onChanged: (value) {
                             setState(() {
                               val = value;
                             });
                            }),
                        Text("Surat",style: GoogleFonts.aBeeZee(),)
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                            value: 2,
                            groupValue: val,
                            onChanged: (value) {
                             setState(() {
                               val = value;
                             });
                            }),
                        Text("Other City",style: GoogleFonts.aBeeZee(),)
                      ],
                    ),
                  ],
                ),
                val == 1 ? fromSurat() : fromOtherCity(),
                SizedBox(
                  height: 18,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    padding: EdgeInsets.only(top: 11, bottom: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Color.fromRGBO(255, 99, 71, 0.9),
                    onPressed: () {},
                    child: Text(
                      "SUBMIT",
                      style: GoogleFonts.nunito(
                          color: Colors.white, letterSpacing: 2, fontSize: 19),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Selected");
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Selected");
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Container(
            child: Wrap(
              children: [
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () {
                      getImageFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    getImageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ));
        });
  }

  Widget fromSurat () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "City",
        //   style: GoogleFonts.aBeeZee(),
        // ),
        // SizedBox(
        //   height: 7,
        // ),
        // TextField(
        //   decoration: InputDecoration(
        //       prefixIcon: Icon(Icons.location_on),
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(5),
        //       ),
        //       contentPadding: EdgeInsets.all(12)),
        // ),
      ],
    );
  }

  Widget fromOtherCity () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Address",
          style: GoogleFonts.aBeeZee(),
        ),
        SizedBox(
          height: 7,
        ),
        TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.location_searching),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              contentPadding: EdgeInsets.all(12)),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Landmark",
          style: GoogleFonts.aBeeZee(),
        ),
        SizedBox(
          height: 7,
        ),
        TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.flag),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              contentPadding: EdgeInsets.all(12)),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Pincode",
          style: GoogleFonts.aBeeZee(),
        ),
        SizedBox(
          height: 7,
        ),
        TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              contentPadding: EdgeInsets.all(12)),
        ),
      ],
    );
  }
}
