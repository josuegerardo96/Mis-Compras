import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class colorss {
  static Color green = Color(0xff03AC53);
  static Color white = Color(0xffFFFFFF);
  static Color black = Color(0xff3C3B4D);
  static Color grey  = Color(0xffA9AECD);
  static Color red   = Color(0xffFF1700);
}



Container login_image(){

  return Container(

    child: Column(
      children: <Widget>[


        Image.asset(
          "assets/logo.png",
          width: 200,
          height: 200,
        ),
        SizedBox(height: 20,),

        Text(
          'Market',
          style: GoogleFonts.amaranth(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: colorss.black
          ),
        )

      ],
    ),


  );

}

Text popup_text(String texto){

  return Text(
    texto,
    style: GoogleFonts.roboto(
      color: colorss.black,
    )
  );
}



Container counter({required String done, required String total }){

  return Container(
    width: 200,
    height: 40,
    decoration: BoxDecoration(
      border: Border.all(
        color: colorss.grey,
      ),
      borderRadius: BorderRadius.circular(20),
    ),

    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: <Widget>[
          Spacer(),

          Text(
            done,
            style: GoogleFonts.roboto(
              color: colorss.grey,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Spacer(),

          Text(
            '/',
            style: GoogleFonts.roboto(
              color: colorss.grey,
              fontSize: 18,
            ),
          ),

          Spacer(),

          Text(
            total,
            style: GoogleFonts.roboto(
              color: colorss.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Spacer(),




        ],
      ),
    ),




  );

}