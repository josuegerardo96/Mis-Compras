import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mis_compras/helpers/helpers.dart';
import 'package:mis_compras/helpers/sign_in.dart';
import 'package:mis_compras/main_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';


Future main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: main_screen(),
    )
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark
  ));

}


class main_screen extends StatefulWidget {
  @override
  _main_screenState createState() => _main_screenState();
}


class _main_screenState extends State<main_screen> {
  


  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => Google_Sign_In(),
    child: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){

          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else if(snapshot.hasError){
            return Center(child: Text("Something went wrong"),);
          }else if(snapshot.hasData){
            return main_list();
          }else{
            return session_page(context);
          }
          
        },
    ),

  );






  Scaffold session_page(BuildContext context) {
    return Scaffold(
    body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
      
          login_image(),
    
          GestureDetector(
            onTap: (){
              final provider = Provider.of<Google_Sign_In>(context, listen: false);
              provider.googleLogin();
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
    ),
  );
  }



}