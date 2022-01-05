import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mis_compras/helpers.dart';
import 'package:mis_compras/main_list.dart';



void main(){
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: main_screen(),
    )
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: colorss.green,
    statusBarColor: colorss.green,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark
  ));

}


class main_screen extends StatefulWidget {
  @override
  _main_screenState createState() => _main_screenState();
}


class _main_screenState extends State<main_screen> {
  


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[


            login_image(),

            GestureDetector(
              onTap: (){
                go_main_list();
              },
              child: Padding(
                padding: EdgeInsets.only(top: 120),
                child: Center(
                  child: Container(
                    width: 265,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: colorss.grey)
                    ),
              
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        children: <Widget>[
              
                          Image.asset('assets/google.png', height: 30, width: 30,),
                          SizedBox(width: 10,),
                          Text(
                            "Iniciar sesión con Google",
                            style: GoogleFonts.amaranth(
                              color: colorss.grey,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }



  void go_main_list(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => main_list()));
  }




}