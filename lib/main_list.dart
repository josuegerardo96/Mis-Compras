import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mis_compras/DB/db.dart';
import 'package:mis_compras/helpers/helpers.dart';
import 'package:mis_compras/objects/producto.dart';
import 'package:provider/provider.dart';
import 'helpers/sign_in.dart';



class main_list extends StatefulWidget {

  @override
  _main_listState createState() => _main_listState();
}

class _main_listState extends State<main_list> {
  final user = FirebaseAuth.instance.currentUser!;
  List<producto> productos = [];
  
  @override
  void initState() {
    cargar_lista();
    super.initState();
  }


  cargar_lista() async {
    productos = await db().getList();
    setState(() {});
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
                children: <Widget>[
            
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(user.photoURL!),
                        ),
                        Spacer(),
                        Center(
                          child: Text(
                            "Market",
                            style: GoogleFonts.amaranth(
                              color:colorss.black,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        menu(),
                      
                      ],
                    ),
                  ),
            
                  counter(
                    done: productos.where((e) => e.getState == true).length.toString(), 
                    total: productos.length.toString(),
                  ),
            
                  SizedBox(height: 30,),
            
                  Expanded(
                    child: productos.length == 0 ? empty():
                    ReorderableListView.builder(
                      padding: EdgeInsets.only(bottom: kFloatingActionButtonMargin + 60),
                      onReorder: (oldIndex, newIndex) => setState(() {
                        final index = newIndex > oldIndex ? newIndex-1 : newIndex;
                        final p = productos.removeAt(oldIndex);
                        productos.insert(index, p);
                        db().insert(productos);
                      }),


                      itemCount: productos.length,
                      itemBuilder: (context, index){
                        return draw_product(index, productos[index]);
                      },
                    ),
                  ),
                ],
              ),

              floatingActionButton: FloatingActionButton.extended(
                onPressed: ()=>cargar_lista(), 
                label: Text("Actualizar lista"),
                backgroundColor: colorss.green,
                icon: Icon(Icons.refresh_outlined),) ,
              
      ),
    );
  }


  Widget draw_product(int i, producto p){
    return Padding(
      key: ValueKey(p),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        children: <Widget>[
          
          
          GestureDetector(
            onTap: () => _changeState(i),
            child: Icon(
              p.getState == false?
                Icons.radio_button_unchecked_outlined:
                Icons.check_circle_outline_outlined,
          
              color: p.getState == false?
                colorss.grey:
                colorss.green,
            ),
          ),


          SizedBox(width: 10,),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                p.getName.toString(),
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: colorss.black,
                  textStyle: TextStyle(
                    
                    decoration: p.getState == false ?
                                  TextDecoration.none:
                                  TextDecoration.lineThrough
                  )
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ) 
          ),
        ],
      ),
    );




  }

  _changeState(int i){

    if(productos[i].getState == false){
      productos[i].setState = true;
      final pro = productos.removeAt(i);
      productos.add(pro);
      db().insert(productos);
    }else{
      productos[i].setState = false;
      final pro = productos.removeAt(i);
      productos.insert(0,pro);
      db().insert(productos);
    }

    setState(() {});

    if(productos.where((e) => e.getState==true).toList().length == productos.length){
      _celebration();
    }
    
  }

   _celebration(){

    Dialog windowDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 250.0,
        width: 200.0,
      
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Image.asset(
              'assets/celebration.png',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 5,),

            Text(
              '¡Compras hechas!',
              style: GoogleFonts.roboto(
                color: colorss.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 30,),

            GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },            
              child: button_ok(context)),





          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => windowDialog);


  }

  PopupMenuButton menu(){

    return PopupMenuButton(
      onSelected: (v){
        if(v==1){
          _add_product(context);
        }else if(v==2){
          
          setState(() {
            productos.removeWhere((e) => e.getState==true);
            db().insert(productos);
          });

        }else if(v==3){
          final provider = Provider.of<Google_Sign_In>(context, listen: false);
          provider.logout();
        }

      },
      icon: Icon(Icons.more_vert_outlined, color: colorss.black,),
      itemBuilder: (BuildContext context){
        return [
          PopupMenuItem(
            value: 1,
            child: Row(
              children: <Widget>[

                Icon(Icons.add, color: colorss.green,),
                SizedBox(width: 10,),
                popup_text('Agregar producto'),
              ],
            )),
          

          PopupMenuItem(
            value: 2,
            child: Row(
              children: <Widget>[

                Icon(Icons.delete_outline_outlined, color: colorss.red,),
                SizedBox(width: 10,),
                popup_text('Eliminar hechos'),
              ],
            )),


            PopupMenuItem(
            value: 3,
            child: Row(
              children: <Widget>[

                Icon(Icons.logout_outlined, color: colorss.grey,),
                SizedBox(width: 10,),
                popup_text('Salir'),
              ],
            )),
            
        ];
      },
    );


  }

  _add_product(BuildContext context){

    TextEditingController texto = new TextEditingController();
    texto.text = "";

    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      builder: (context,){
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter myState){
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              color: Color(0xff737373),
              child: Container(
                height: 200,
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
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              counter: Offstage()),
                            keyboardType: TextInputType.multiline,
                            onChanged: (v) => myState((){}),
                            minLines: 1,
                            maxLines: 2,
                            maxLength: 35,
                            controller: texto,
                            autofocus: true,
                            cursorColor: colorss.green,
                            style: GoogleFonts.roboto(
                                  color: colorss.black, 
                                  fontSize: 14,
                              ),
                            
                          ),
                        ),
        
                        SizedBox(height: 5,),
        
        
                        Text(
                          texto.text.length.toString()+
                          '/35',
        
                          style: GoogleFonts.roboto(
                            color: colorss.grey,
                            fontSize: 10,
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
                          onTap: (){
        
                            if(texto.text.isNotEmpty){
                              productos.insert(0,producto(name: texto.text, state: false));
                              Navigator.pop(context); 
                              setState(() {});
                              db().insert(productos);
                            }
                            
                    
                          },
                    
                          child: button_add(context),
                        ),
                      ),
                    ),
            
                  ]
                ),
              ),
            ),
          );
          }
        );
      });



  }


  Widget empty(){
    return Center(
      child: Container(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150,),
            Image.asset('assets/relax.png', width: 100,height: 100,),
            SizedBox(height: 5,),
            Text(
              'No hay nada por comprar',
              style: GoogleFonts.roboto(
                color: colorss.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20,),

            GestureDetector(
              onTap: () => _add_product(context),
              child: button_add_element(context)),
          ]

          

        ),

      ),
    );
  }
}