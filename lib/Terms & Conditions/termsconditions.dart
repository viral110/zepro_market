import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({Key key}) : super(key: key);

  @override
  _TermsConditionsState createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
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
                      color: Color.fromRGBO(255, 78, 91, 1.0),
                    )),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Terms & Conditions",
                  style: GoogleFonts.aBeeZee(
                      color: Color.fromRGBO(255, 78, 91, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 2),
                ),
              ],
            ),
          ),
          Divider(
            height: 15,
            thickness: 1.1,
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '''
★	We reserve the right to modify or terminate the services for any reason,without notice at any time.Not all Services and features are Available Is every jurisdiction and we are under no obligation to make any services or features available in any jurisdiction. 

★	We reserve the right to refuse service to anyone for any reason at any time.

★	Information for out of surat customers : Whenever you receive a parcel,when opening the parcel,the parcel made videos with 360 videos,If the Video is not made,the missing item claim will not be accepted.

★	all video's are just for reference only.

★	no any color choice available in any products.

★	you will get product color as per available stock.

★	there is no any Guaranty/Warranty available in any products.

★	we have no any branded products.

★	we are not responsible for any damage because of transport after delivered.

★	Minimum order amount for Customers from Surat is rs.50

★	Verbal or written abuse of any kind(including threats of abuse or retribution) of any Quick mart custmore,Quick mart employee,member or officer will result in immediate service closed.

★	Pay attention "Local seller", check the goods thoroughly,later the goods we are not accepting return or replacment of any products.

★	Customers have the option of self pick-up of the orders from the Quick mart app.quick mart does not provide delivery services in surat.

★	minimum order  amount for out of surat customers is rs.2000
              ''',
                style: GoogleFonts.aBeeZee(fontSize: 13.5, letterSpacing: 1),
                textAlign: TextAlign.left,
              ),
            ),
          )
        ],
      ),
    );
  }
}
