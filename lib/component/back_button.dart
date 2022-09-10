import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BackButtonCustom extends StatelessWidget {
  const BackButtonCustom({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios_new,
            size: 15,
            color: Color.fromRGBO(22, 2, 105, 1),
          ),
          // const SizedBox(
          //   width: 4,
          // ),
          Text(
            "Back",
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: Color.fromRGBO(22, 2, 105, 1),
            ),
          ),
        ],
      ),
    );
  }
}
