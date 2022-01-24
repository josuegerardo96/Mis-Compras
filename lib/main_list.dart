import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mis_compras/DB/db.dart';
import 'package:mis_compras/helpers/helpers.dart';
import 'package:mis_compras/master_list/master_list.dart';
import 'package:mis_compras/objects/producto.dart';
import 'package:provider/provider.dart';
import 'helpers/sign_in.dart';
import 'helpers/size.dart';
import 'helpers/the_provider.dart';

class main_list extends StatefulWidget {
  @override
  _main_listState createState() => _main_listState();
}

class _main_listState extends State<main_list> {
  final user = FirebaseAuth.instance.currentUser!;
  List<producto> productos = [];

  // Charge the Provider with the info
  Future<List<producto>> cargar_lista(BuildContext con) async {
    final carrito = Provider.of<Carrito>(context);
    if (carrito.getCarrito.isNotEmpty) {
      return carrito.getCarrito;
    } else {
      return carrito.cargarCarrito;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = new Size(context: context);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark));

    Carrito carrito = Provider.of<Carrito>(context);
    if (productos.isNotEmpty) {
      productos = carrito.getCarrito;
      return Final_Screen(size, carrito);
    } else {
      return FutureBuilder(
          future: cargar_lista(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              productos = snapshot.data as List<producto>;
              return Final_Screen(size, carrito);
            }
          });
    }
  }

  Scaffold Final_Screen(Size size, Carrito carrito) {
    return Scaffold(
      backgroundColor: colorss.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: size.h(2.5)),
            Align(alignment: Alignment.topLeft, child: menu(carrito)),
            SizedBox(height: size.h(1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Bienvenido',
                          style: GoogleFonts.amaranth(
                            fontSize: size.h(1.6),
                            color: colorss.black,
                          )),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        user.displayName.toString(),
                        style: GoogleFonts.amaranth(
                          color: colorss.black,
                          fontSize: size.h(3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Circle_Counter(
                      done: productos.where((e) => e.getState == true).length,
                      total: productos.length,
                      hw: size.h(9),
                      fs: size.h(1.6)),
                ],
              ),
            ),
            SizedBox(
              height: size.w(2),
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
                        db().insert(productos);
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
    );
  }

  Widget draw_product(int i, producto p, Size size) {
    return Padding(
      key: ValueKey(p),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onLongPress: () {
              setState(() {
                productos.removeAt(i);
                Provider.of<Carrito>(context, listen: false).setCarrito =
                    productos;
                db().insert(productos);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Se eliminó ${p.getName}",
                      style: GoogleFonts.roboto(color: colorss.red)),
                  duration: const Duration(seconds: 2),
                ));
              });
            },
            onTap: () {
              setState(() {
                p.setState = !p.getState;

                if (p.getState == true) {
                  final pro = productos.removeAt(i);
                  productos.add(pro);
                } else {
                  final pro = productos.removeAt(i);
                  productos.insert(0, pro);
                }

                if (productos
                        .where((e) => e.getState == true)
                        .toList()
                        .length ==
                    productos.length) {
                  _celebration();
                }
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
                  fontSize: size.h(2.0),
                  color: colorss.black,
                  textStyle: TextStyle(
                      decoration: p.getState == false
                          ? TextDecoration.none
                          : TextDecoration.lineThrough)),
              overflow: TextOverflow.ellipsis,
            ),
          )),
        ],
      ),
    );
  }

  //
  _celebration() {
    Size size = new Size(context: context);
    Dialog windowDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: size.h(25),
        width: size.h(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/celebration.png',
              width: size.h(10),
              height: size.h(10),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '¡Compras hechas!',
              style: GoogleFonts.roboto(
                color: colorss.black,
                fontSize: size.h(2),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: button_ok(context)),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => windowDialog);
  }

  PopupMenuButton menu(Carrito carrito) {
    return PopupMenuButton(
      onSelected: (v) {
        if (v == 1) {
          _add_product(context);
        } else if (v == 2) {
          setState(() {
            productos.removeWhere((e) => e.getState == true);
            db().insert(productos);
          });
        } else if (v == 3) {
          
          productos.clear();
          carrito.setCarrito = [];
          db().insert([]);
          
          setState(() {});

        } else if (v == 4) {
          final provider = Provider.of<Google_Sign_In>(context, listen: false);
          provider.logout();
        }
      },
      icon: Icon(
        Icons.more_vert_outlined,
        color: colorss.black,
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
              value: 1,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: colorss.green,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  popup_text('Agregar producto'),
                ],
              )),
          PopupMenuItem(
              value: 2,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.delete_outline_outlined,
                    color: colorss.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  popup_text('Eliminar hechos'),
                ],
              )),
          PopupMenuItem(
              value: 3,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart_rounded,
                    color: colorss.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  popup_text('Vaciar carrito'),
                ],
              )),
          PopupMenuItem(
              value: 4,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.logout_outlined,
                    color: colorss.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  popup_text('Salir'),
                ],
              )),
        ];
      },
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
                'No hay nada por comprar',
                style: GoogleFonts.roboto(
                  color: colorss.black,
                  fontSize: size.h(1.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () => _add_product(context),
                  child: button_add_element(context)),
            ]),
      ),
    );
  }
}
