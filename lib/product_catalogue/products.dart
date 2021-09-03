import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  // SearchBar searchBar;
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //
  // AppBar buildAppBar(BuildContext context) {
  //   return new AppBar(
  //       backgroundColor: Colors.white,
  //       iconTheme: IconThemeData(
  //         color: Colors.blue[900],
  //       ),
  //       title: new Text(
  //         'All Products',
  //         style: GoogleFonts.aBeeZee(color: Colors.blue[900]),
  //       ),
  //       actions: [
  //         searchBar.getSearchAction(context),
  //         PopupMenuButton(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(7),
  //           ),
  //           itemBuilder: (context) => [
  //             PopupMenuItem(
  //               child: Text("Apply Filter"),
  //               value: 1,
  //             ),
  //           ],
  //         )
  //       ]);
  // }
  //
  // void onSubmitted(String value) {
  //   setState(() => _scaffoldKey.currentState
  //       .showSnackBar(new SnackBar(content: new Text('You wrote $value!'))));
  // }
  //
  // _ProductsState() {
  //   searchBar = new SearchBar(
  //       inBar: false,
  //       buildDefaultAppBar: buildAppBar,
  //       setState: setState,
  //       onSubmitted: onSubmitted,
  //       onCleared: () {
  //         print("cleared");
  //       },
  //       onClosed: () {
  //         Navigator.pop(context);
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: new Text(
          'All Products',
          style: GoogleFonts.aBeeZee(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context) => [
            PopupMenuItem(child: Text("Apply Filter"))
          ],)
        ],
        bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.white,
                ),
                child: TextFormField(
                  style: GoogleFonts.aBeeZee(),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.blue[900]),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Search for something',


                    prefixIcon: Icon(Icons.search,color: Colors.blue[900],),
                  ),
                ),
              ),
            ),
            preferredSize: Size(MediaQuery.of(context).size.width, 60)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  contentPadding:
                      EdgeInsets.only(top: 0, left: 5, right: 5, bottom: 0),
                  leading: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                          "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.afcindustries.com%2Fpages%2Fbig3%2F772117-adjustable-rolling-laptop-table.jpg&f=1&nofb=1",
                          fit: BoxFit.fill),
                    ),
                    backgroundColor: Colors.transparent,
                    radius: 36,
                  ),
                  title: Text("Laptop Table"),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mobile accessories"),
                      Text("50/stock | 1 in stock"),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "\$380",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: "  39% OFF",
                            style: TextStyle(color: Colors.teal)),
                      ])),
                    ],
                  ),
                  isThreeLine: true,
                ),
                Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                  indent: 10,
                  endIndent: 5,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
