import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mis_compras/helpers/helpers.dart';
import 'package:mis_compras/helpers/sign_in.dart';
import 'package:mis_compras/helpers/size.dart';
import 'package:mis_compras/helpers/the_provider.dart';
import 'package:mis_compras/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';


Future main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: main_screen(),
    )
  );
  });
  



  

}


class main_screen extends StatefulWidget {
  @override
  _main_screenState createState() => _main_screenState();
}


class _main_screenState extends State<main_screen> {
  


  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
        ChangeNotifierProvider<Carrito>(create: (context)=>Carrito()),
        ChangeNotifierProvider<Google_Sign_In>(create: (context)=>Google_Sign_In()),
      ],
    //create: (context) => Google_Sign_In(),
    child: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else if(snapshot.hasError){
            return Center(child: Text("Something went wrong"),);
          }else if(snapshot.hasData){
            return Home();
          }else{
            return session_page(context);
          }  
        },
    ),

  );


  Scaffold session_page(BuildContext context) {
    Size size = new Size(context: context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        
      )
    );


    return Scaffold(
    body: Stack(
      children: [


        Container(
          width:double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/market.jpg'),
              fit: BoxFit.cover,
            )
          ),
          
        ),



        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.4),
          
        ),


        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
              'Bienvenido a su',
              style: GoogleFonts.amaranth(
                fontSize: size.h(2.4),
                color: colorss.white
              ),
            ),

            SizedBox(height: 5,),


            Text(
              'LISTA DE COMPRAS',
              style: GoogleFonts.amaranth(
                fontSize: size.h(3.2),
                color: colorss.white
              ),
            ),


            SizedBox(height: 40,),




            GestureDetector(
              onTap: (){
                final provider = Provider.of<Google_Sign_In>(context, listen: false);
                provider.googleLogin();
              },
              child: Center(
                child: Container(
                  width: size.w(80),
                  height: size.h(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: colorss.white,
                  ),
              
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              
                      Image.asset('assets/google.png', height:size.h(3), width: size.h(3),),
                      SizedBox(width: 10,),
                      Text(
                        "Iniciar sesión con Google",
                        style: GoogleFonts.amaranth(
                          color: colorss.black,
                          fontSize: size.h(2.2),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    ),
  );
  }



}