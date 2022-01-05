import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mis_compras/helpers.dart';



class main_list extends StatefulWidget {

  @override
  _main_listState createState() => _main_listState();
}

class _main_listState extends State<main_list> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              child: Row(
                children: <Widget>[
                  Icon(Icons.arrow_back_ios_new_outlined, color: colorss.black,),
                  Spacer(),
                  Center(
                    child: Text(
                      "   Market",
                      style: GoogleFonts.amaranth(
                        color:colorss.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  menu(),
                
                ],
              ),
            ),

            counter(done: '12', total: '20'),

            SizedBox(height: 20,),

            Expanded(
              child: Container(),
            ),







          ],
    
          
        ),
      ),
    );
  }





  PopupMenuButton menu(){

    return PopupMenuButton(
      onSelected: (v){

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



}