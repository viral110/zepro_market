import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import '../Connect_API/api.dart';
import '../Model/home_cart_category_model.dart';
import '../product_catalogue/products.dart';

class CategoriesPopular extends StatefulWidget {
  const CategoriesPopular({Key key}) : super(key: key);

  @override
  _CategoriesPopularState createState() => _CategoriesPopularState();
}

class _CategoriesPopularState extends State<CategoriesPopular> {
  HomeCartCategory hcc;

  bool isLoadingCategory = false;

  fetchCategory() async {
    // await Future.delayed(Duration(milliseconds: 100), () async {
    Response response = await ApiServices().getHomeCategory(context);
    var decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      hcc = HomeCartCategory.fromJson(decoded);

      setState(() {
        isLoadingCategory = true;
      });
    }
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoadingCategory == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 12, bottom: 20),
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
                          "All Categories",
                          style: GoogleFonts.aBeeZee(
                              color: Color.fromRGBO(255, 78, 91, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GridView.builder(
                      itemCount: hcc.catList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Products(
                                          categoryHome: hcc.catList[index].name,number: 1),
                                    ));
                              },
                              child: Material(
                                elevation: 6,
                                borderRadius: BorderRadius.circular(40),
                                child: FittedBox(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(hcc.catList[index].image),
                                    radius: 41,
                                    // child: Image.network(
                                    //     hcc.catList[index].image,
                                    //     fit: BoxFit.fill),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              " ${hcc.catList[index].name}",
                              style: GoogleFonts.dmSans(
                                  fontSize: 13.4, color: Colors.black),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
          ),
    );
  }
}
