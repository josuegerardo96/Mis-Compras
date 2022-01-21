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
    Size size = new Size(context: context);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark
        
      )
    );

    return Scaffold(
      backgroundColor: colorss.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[


            SizedBox(height: size.h(2.5)),


            Align(
              alignment: Alignment.topLeft,
              child: menu()),


            Circle_Counter(
              done: productos.where((e) => e.getState == true).length,
              total: productos.length,
              hw: size.h(9),
              fs: size.h(1.6)
            ),

            SizedBox(
              height: size.w(4),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => cargar_lista(),
        label: Text("Actualizar lista"),
        backgroundColor: colorss.green,
        icon: Icon(Icons.refresh_outlined),
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
            onTap: () => _changeState(i),
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

  // Every time that the icon is checked
  _changeState(int i) {
    if (productos[i].getState == false) {
      productos[i].setState = true;
      final pro = productos.removeAt(i);
      productos.add(pro);
      db().insert(productos);
    } else {
      productos[i].setState = false;
      final pro = productos.removeAt(i);
      productos.insert(0, pro);
      db().insert(productos);
    }
    setState(() {});

    if (productos.where((e) => e.getState == true).toList().length ==
        productos.length) {
      _celebration();
    }
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

  PopupMenuButton menu() {
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
          final provider = Provider.of<Google_Sign_In>(context, listen: false);
          provider.logout();
        } else if (v == 4) {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => master_list())).then((v){setState(() {
                
              });});
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
