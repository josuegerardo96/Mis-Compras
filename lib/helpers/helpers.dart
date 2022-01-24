import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mis_compras/helpers/size.dart';

class colorss {
  static Color green = Color(0xff03AC53);
  static Color white = Color(0xffFFFFFF);
  static Color black = Color(0xff3C3B4D);
  static Color grey = Color(0xffA9AECD);
  static Color red = Color(0xffFF1700);
}

Container login_image(Size s) {
  return Container(
    child: Column(
      children: <Widget>[
        Image.asset(
          "assets/logo.png",
          width: s.h(25),
          height: s.h(25),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'Market',
          style: GoogleFonts.amaranth(
              fontSize: s.h(3.2),
              fontWeight: FontWeight.bold,
              color: colorss.black),
        )
      ],
    ),
  );
}

Text popup_text(String texto) {
  return Text(texto,
      style: GoogleFonts.roboto(
        color: colorss.black,
      ));
}

Container counter_circle(
    {required String done, required String total, required Size size}) {
  return Container(
    width: size.w(45),
    height: size.h(5),
    decoration: BoxDecoration(
      border: Border.all(
        color: colorss.grey,
      ),
      borderRadius: BorderRadius.circular(10),
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
              fontSize: size.h(1.8),
            ),
          ),
          Spacer(),
          Text(
            '/',
            style: GoogleFonts.roboto(
              color: colorss.grey,
              fontSize: size.h(1.8),
            ),
          ),
          Spacer(),
          Text(
            total,
            style: GoogleFonts.roboto(
              color: colorss.green,
              fontWeight: FontWeight.bold,
              fontSize: size.h(1.8),
            ),
          ),
          Spacer(),
        ],
      ),
    ),
  );
}

Container button_add(BuildContext context) {
  Size size = new Size(context: context);
  return Container(
    width: MediaQuery.of(context).size.width * .1,
    height: size.h(5.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
    ),
    child: Card(
      elevation: 3,
      color: colorss.green,
      child: Center(
        child: Text(
          'Agregar',
          style: GoogleFonts.roboto(
            color: colorss.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

Container float_button_refresh() {
  return Container(
    width: 130,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
    ),
    child: Card(
      elevation: 5,
      color: colorss.green,
      child: Center(
        child: Text(
          'Actualizar lista',
          style: GoogleFonts.roboto(
            color: colorss.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

Container button_ok(BuildContext context) {
  return Container(
    width: 60,
    height: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
    ),
    child: Card(
      elevation: 3,
      color: colorss.green,
      child: Center(
        child: Text(
          'ok',
          style: GoogleFonts.roboto(
            color: colorss.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

Container button_add_element(BuildContext context) {
  Size size = new Size(context: context);
  return Container(
    width: size.w(55),
    height: size.h(5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
    ),
    child: Card(
      elevation: 3,
      color: colorss.green,
      child: Center(
        child: Text(
          'Agregar un nuevo producto',
          style: GoogleFonts.roboto(
            color: colorss.white,
            fontSize: size.h(1.4),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

Container Circle_Counter(
    {required int done,
    required int total,
    required double hw,
    required double fs}) {
  double rr = 0;
  if (total > 0) {
    rr = done / total;
  }
  return Container(
    height: hw + 2,
    width: hw + 2,
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: hw,
          height: hw,
          child: new CircularProgressIndicator(
            strokeWidth: 4,
            value: 1,
            color: colorss.grey,
          ),
        ),
        Container(
          width: hw,
          height: hw,
          child: new CircularProgressIndicator(
            strokeWidth: 4,
            value: rr,
            color: colorss.green,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${done} / ",
              style: GoogleFonts.roboto(
                fontSize: fs,
                color: colorss.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${total}",
              style: GoogleFonts.roboto(
                  fontSize: fs,
                  color: colorss.green,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    ),
  );
}
