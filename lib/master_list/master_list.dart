import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mis_compras/DB/db.dart';
import 'package:mis_compras/helpers/helpers.dart';
import 'package:mis_compras/helpers/size.dart';
import 'package:mis_compras/helpers/the_provider.dart';
import 'package:mis_compras/objects/producto.dart';
import 'package:provider/provider.dart';

class master_list extends StatefulWidget {
  @override
  _master_listState createState() => _master_listState();
}

class _master_listState extends State<master_list> {
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController txt = new TextEditingController();
  List<producto> productos = [];

  Future<List<producto>> cargar_lista(BuildContext con) async {
    final carrito = Provider.of<Carrito>(context);
    if (carrito.getFullCarrito.isNotEmpty) {
      return carrito.getFullCarrito;
    } else {
      return Provider.of<Carrito>(context).cargarFullCarrito;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = new Size(context: context);


    


    if (productos.isNotEmpty) {
      productos = Provider.of<Carrito>(context).getFullCarrito;
      return Final_fullList_screen(size);
    } else {
      return FutureBuilder(
          future: cargar_lista(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              productos = snapshot.data as List<producto>;
              return Final_fullList_screen(size);
            }
          });
    }
  }

  Scaffold Final_fullList_screen(Size size) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size.h(5),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Lista',
                            style: GoogleFonts.amaranth(
                              fontSize: size.h(2),
                              color: colorss.black,
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          'Total',
                          style: GoogleFonts.amaranth(
                            color: colorss.black,
                            fontSize: size.h(4.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Spacer(
                      flex: 3,
                    ),
                    Text(
                      productos
                              .where((e) => e.getState == true)
                              .toList()
                              .length
                              .toString() +
                          ' / ' +
                          productos.length.toString(),
                      style: GoogleFonts.amaranth(
                        color: colorss.green,
                        fontSize: size.h(3.2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
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
            onLongPress: () {
              setState(() {
                productos.removeAt(i);
                Provider.of<Carrito>(context, listen: false).setFullCarrito = productos;
                db().insertMaster(productos);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Se eliminó el ${p.getName}", style: GoogleFonts.roboto(color: colorss.red)),
                  duration: const Duration(seconds: 2),
                ));
              });
              
            },
            onTap: () {
              setState(() {
                p.setState = !p.getState;
              });
            },
            child: Icon(
              p.getState == false
                  ? Icons.check_box_outline_blank_outlined
                  : Icons.check_box_outlined,
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
                  fontSize: size.h(2.0), color: colorss.black),
              overflow: TextOverflow.ellipsis,
            ),
          )),
        ],
      ),
    );
  }

  _add_product(BuildContext context) {
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
                                if (texto.text.isNotEmpty) {
                                  productos.add(
                                      producto(name: texto.text, state: false));
                                  Navigator.pop(context);
                                  setState(() {});
                                  db().insert(productos);
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
