import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mis_compras/objects/producto.dart';

class db {
  final _user = FirebaseAuth.instance.currentUser;

  // Insert

  insert(List<producto> ps) async {
    final firebase = FirebaseFirestore.instance;
    firebase.collection('Compras').doc('lista').set({
      'Productos': FieldValue.arrayUnion(ps.map((e) => e.toMap()).toList()),
    });
  }

  Future<List<producto>> getList() async {
    final firebase = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firebase.collection('Compras').get();

    List listaProductos = snapshot.docs.map((e) {
      return e.data();
    }).toList();


    if(listaProductos.isNotEmpty){
      List productos = listaProductos[0]['Productos'];

      List<producto> productosFinales = productos
          .map((e) => producto.fromJSON(json: e as Map<String, dynamic>))
          .toList();

      return productosFinales;
    }else{
      return [];
    }
    
  }






  insertMaster(List<producto> ps) async {
    final firebase = FirebaseFirestore.instance;
    firebase.collection('ComprasMaster').doc('lista').set({
      'Productos': FieldValue.arrayUnion(ps.map((e) => e.toMap()).toList()),
    });
  }

  Future<List<producto>> getListMaster() async {
    final firebase = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firebase.collection('ComprasMaster').get();

    List listaProductos = snapshot.docs.map((e) {
      return e.data();
    }).toList();

    if(listaProductos.isNotEmpty){
      List productos = listaProductos[0]['Productos'];

      List<producto> productosFinales = productos
          .map((e) => producto.fromJSON(json: e as Map<String, dynamic>))
          .toList();

      return productosFinales;
    }else{
      return [];
    }
    
  }
}
