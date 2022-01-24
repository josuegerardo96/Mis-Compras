

import 'package:flutter/cupertino.dart';
import 'package:mis_compras/DB/db.dart';
import 'package:mis_compras/objects/producto.dart';

class Carrito with ChangeNotifier{

  List<producto> carrito = [];
  List<producto> fullCarrito = [];

  // CARRITO ----------------------------------------------------
  Future<List<producto>> get cargarCarrito async{
    this.carrito = await db().getList();
    return this.carrito;
  }
  
  List<producto> get getCarrito => this.carrito;
  
  set setCarrito(List<producto> carrito){
    this.carrito = carrito;
    notifyListeners();
    db().insert(this.carrito);
  }




  //  FULL CARRITO ----------------------------------------------
  Future<List<producto>> get cargarFullCarrito async{
    this.fullCarrito = await db().getListMaster();
    return this.fullCarrito;
  }

  List<producto> get getFullCarrito => this.fullCarrito;

  set setFullCarrito(List<producto> fullCarrito){

    this.fullCarrito = fullCarrito;
    notifyListeners();
    db().insertMaster(this.fullCarrito);
  }








}