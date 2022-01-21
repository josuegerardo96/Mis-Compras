import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mis_compras/DB/db.dart';
import 'package:mis_compras/helpers/helpers.dart';
import 'package:mis_compras/helpers/size.dart';
import 'package:mis_compras/objects/producto.dart';



class master_list extends StatefulWidget {


  @override
  _master_listState createState() => _master_listState();
}

class _master_listState extends State<master_list> {
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController txt = new TextEditingController();
  List<producto> productos = [];
  

  @override
  void initState() {
    cargar_lista();
    super.initState();
  }

  cargar_lista() async {
    productos = await db().getListMaster();
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    Size size = new Size(context: context);
    return Scaffold(


      body: Container(
        child: SafeArea(
          child: Column(
        
            children: <Widget>[
        
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined, 
                        color: colorss.black,
                        size: size.h(2),
                      )
                    ),


                    Spacer(),


                    Text(
                      "Lista maestra",
                      style: GoogleFonts.amaranth(
                        color: colorss.black,
                        fontSize: size.h(3.2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),


                    Spacer(),

                    IconButton(
                      
                      onPressed: (){
                        if(productos.isNotEmpty){
                          List<producto> enviar = [];
                          for (producto p in productos) {
                            if(p.getState==true){
                              p.setState = false;
                              enviar.add(p);
                            }
                          }

                          if(enviar.isNotEmpty){
                            db().insert(enviar);
                          }
                        }
                        
                      }, 
                      icon: Icon(
                        Icons.cloud_circle_outlined,
                        color: colorss.black,
                        size: size.h(3),
                      ),
                    ),


                      

                    



                  ],
                ),
              ),




              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.h(4.0),
                    width: size.w(55),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorss.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: txt,
                      onChanged: (_) => setState(() {}),
                      cursorColor: colorss.green,
                      maxLength: 40,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.only(bottom: 17.5),
                        border: InputBorder.none,
                        
                        hintText: "Agregar producto",
                        hintStyle: GoogleFonts.roboto(
                          fontSize: size.h(1.5),
                          color: colorss.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10,), 

                  Container(
                    height: size.h(3),
                    width: size.h(3),
                    decoration: BoxDecoration(
                      color: colorss.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: GestureDetector(
                      onTap: (){
                        if(txt.text.isNotEmpty){
                          productos.add(producto(name: txt.text.trim(), state: false));
                          db().insertMaster(productos);
                          txt.text = "";
                          setState(() {
                            
                          });
                        }
                        
                      },
                      child: Center(
                        child: Icon(Icons.add, color: colorss.white, size: size.h(2),),
                      ),
                    ),
                  ),




                ],
              ),



              SizedBox(height: 20,),


              Expanded(
              child: productos.length == 0
                  ? empty()
                  : ReorderableListView.builder(
                      padding: EdgeInsets.only(
                          bottom: kFloatingActionButtonMargin + 60),
                      onReorder: (oldIndex, newIndex) => setState(() {
                        final index =
                            newIndex > oldIndex ? newIndex - 1 : newIndex;
                        final p = productos.removeAt(oldIndex);
                        productos.insert(index, p);
                        db().insertMaster(productos);
                      }),
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        return draw_product(index, productos[index], size);
                      },
                    ),
            ),




        
            ],
          ),
        ),
      ),


    );
  }
  



  Widget draw_product(int i, producto p, Size size) {
    return Padding(
      key: ValueKey(p),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 22.5),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onLongPress: (){
              productos.removeAt(i);
              db().getListMaster();
              setState(() {});
              db().insertMaster(productos);
              
            },
            onTap: (){
              if(productos[i].getState == true){
                productos[i].setState = false;
              }else{
                productos[i].setState = true;
              }
              setState(() {
                
              });
              
            },
            child: Icon(
              p.getState == false
                  ? Icons.radio_button_unchecked_outlined
                  : Icons.check_circle_outline_outlined,
              color: p.getState == false ? colorss.grey : colorss.green,
              size: size.h(2.5),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              p.getName.toString(),
              style: GoogleFonts.roboto(
                  fontSize: size.h(2.0),
                  color: colorss.black),
              overflow: TextOverflow.ellipsis,
            ),
          )),
        ],
      ),
    );
  }











  Widget empty() {
    Size size = new Size(context: context);
    return Center(
      child: Container(
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
              ),
              Image.asset(
                'assets/relax.png',
                width: size.h(10),
                height: size.h(10),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'No hay nada',
                style: GoogleFonts.roboto(
                  color: colorss.black,
                  fontSize: size.h(1.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
      ),
    );
  }











}