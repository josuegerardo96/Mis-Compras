// ignore_for_file: override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mis_compras/DB/db.dart';
import 'package:mis_compras/helpers/helpers.dart';
import 'package:mis_compras/helpers/the_provider.dart';
import 'package:mis_compras/main_list.dart';
import 'package:mis_compras/master_list/master_list.dart';
import 'package:mis_compras/helpers/size.dart';
import 'package:mis_compras/objects/producto.dart';
import 'package:provider/provider.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {

  // Define the list of screens
  int currentTab = 0;
  final List<Widget> screens = [
    main_list(),
    master_list(),
  ];

  // Define the change page
  Widget currentPage = main_list();
  final PageStorageBucket bucket = PageStorageBucket();



  @override
  Widget build(BuildContext context) {

    // Start the provider
    final carrito = Provider.of<Carrito>(context);
    Size size = new Size(context: context);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark
      )
    );




    return WillPopScope(
      onWillPop: () async {
        getting_out();
        return true;
      },
      child: Scaffold(
        body: PageStorage(
          bucket: bucket,
          child:  currentPage,
        ),
      
      
        floatingActionButton: GestureDetector(
          onDoubleTap: (){
            
    
            // Just for update the actual list
            if(currentTab == 1){
    
    
              List<producto> sel = carrito.getFullCarrito.where((e) => e.getState == true).toList();
              if(sel.length > 0){
                for (producto i in carrito.getFullCarrito) {
                  if(i.getState == true){
                    i.setState = false;
                  }
                }
                carrito.setFullCarrito = carrito.getFullCarrito;
                carrito.setCarrito = carrito.getCarrito + sel;
                db().insert(carrito.getCarrito);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Se actualizó la lista", style: GoogleFonts.roboto(color: Colors.yellow[900])),
                  duration: const Duration(seconds: 2),
                ));
    
    
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("La lista está vacía, seleccione algo", style: GoogleFonts.roboto(color: colorss.red)),
                  duration: const Duration(seconds: 2),
                ));
              }
    
    
            }
            
    
    
          },
          onLongPress: (){
            if(currentTab == 0){
              _add_product(context, currentTab, carrito);
            }
            
            if(currentTab == 1){
    
              List<producto> sel = carrito.getFullCarrito.where((e) => e.getState == true).toList();
              if(sel.length > 0){
                for (producto i in carrito.getFullCarrito) {
                  if(i.getState == true){
                    i.setState = false;
                  }
                }
    
                carrito.setFullCarrito = carrito.getFullCarrito;
                db().insert(sel);
                carrito.setCarrito = sel;
    
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Lista enviada al carrito", style: GoogleFonts.roboto(color: colorss.green)),
                  duration: const Duration(seconds: 2),
                ));
    
    
                // Insert message of create
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("La lista está vacía, seleccione algo", style: GoogleFonts.roboto(color: colorss.red)),
                  duration: const Duration(seconds: 2),
                ));
              }
            }
            
    
          },
    
    
          child: FloatingActionButton(
            child: Icon(currentTab == 0 ? Icons.refresh_outlined:Icons.add),
            backgroundColor: colorss.green,
            onPressed: () async {
              if(currentTab == 0){
              // Update the carrito

              bool internet = await InternetConnectionChecker().hasConnection;
              if(internet){
                carrito.setCarrito = await db().getList();
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("No tiene INTERNET", style: GoogleFonts.roboto(color: colorss.red)),
                  duration: const Duration(seconds: 2),
                ));
              }
              
      
      
            }else if(currentTab == 1){
              // Add element into master list
              _add_product(context, currentTab, carrito);
    
            }
            },
        
            
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      
      
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 60,
            child: Row(
              children: <Widget>[
      
      
                Spacer(flex: 1,),
                
                MaterialButton(
                  onPressed: () async{
                    


                    setState(() {
                      currentPage = main_list();
                      currentTab = 0;
                    });
                  },
                  minWidth: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart_outlined, 
                        color: currentTab == 0 ? colorss.green:colorss.grey,
                        size: size.h(2.4),),
                      Text(
                        'Carrito', 
                        style: GoogleFonts.roboto(
                          color: currentTab == 0 ? colorss.green:colorss.grey,
                          fontSize: size.h(1.4),
                        ),
                      )
                    ],
                  ),
      
                ),
      
      
                Spacer(flex: 3,),
      
      
      
                MaterialButton(
                  onPressed: (){
                    setState(() {
                      currentPage = master_list();
                      currentTab = 1;
                    });
                  },
                  minWidth: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.format_list_bulleted_outlined, 
                        color: currentTab == 1 ? colorss.green:colorss.grey,
                        size: size.h(2.4),
                      ),
                      Text(
                        'Lista maestra', 
                        style: GoogleFonts.roboto(
                          color: currentTab == 1 ? colorss.green:colorss.grey,
                          fontSize: size.h(1.4),
                        ),
                      )
                    ],
                  ),
      
                ),
      
                Spacer(flex: 1,),
              ],
            ),
          ),
        ),
      ),
    );
  }





  _add_product(BuildContext context, int currentTab, Carrito carrito) {
    TextEditingController texto = new TextEditingController();
    texto.text = "";
    Size size = new Size(context: context);
    
    

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (
          context,
        ) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter myState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                color: Color(0xff737373),
                child: Container(
                  height: size.h(20),
                  decoration: BoxDecoration(
                    color: colorss.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .65,
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    counter: Offstage()),
                                keyboardType: TextInputType.multiline,
                                onChanged: (v) => myState(() {}),
                                minLines: 1,
                                maxLines: 2,
                                maxLength: 35,
                                controller: texto,
                                autofocus: true,
                                cursorColor: colorss.green,
                                style: GoogleFonts.roboto(
                                  color: colorss.black,
                                  fontSize: size.h(1.6),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              texto.text.length.toString() + '/35',
                              style: GoogleFonts.roboto(
                                color: colorss.grey,
                                fontSize: size.h(1),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: EdgeInsets.only(top: 20, right: 10),
                            width: MediaQuery.of(context).size.width * .35,
                            child: GestureDetector(
                              onTap: () {
                                if(currentTab == 1){
                                   if (texto.text.isNotEmpty) {
                                      carrito.setFullCarrito = carrito.getFullCarrito + [producto(name: texto.text, state: false)];
                                      Navigator.pop(context);
                                      setState(() {});
                                      db().insertMaster(carrito.getFullCarrito);
                                   }
                                }else if(currentTab == 0){
                                  if (texto.text.isNotEmpty) {
                                      carrito.setCarrito = carrito.getCarrito + [producto(name: texto.text, state: false)];
                                      Navigator.pop(context);
                                      setState(() {});
                                      db().insert(carrito.getCarrito);
                                   }
                                }
                               
                              },
                              child: button_add(context),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            );
          });
        });
  }




  getting_out() {
    Size size = new Size(context: context);
    Dialog windowDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: size.h(35),
        width: size.h(35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/cart_full.png',
              width: size.h(10),
              height: size.h(10),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '¿De verdad desea salir de la aplicación?',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  color: colorss.black,
                  fontSize: size.h(2.4),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  SystemNavigator.pop();
                },
                child: button_ok(context)),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => windowDialog);
  }



  

}