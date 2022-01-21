
import 'package:flutter/cupertino.dart';

class Size{


  BuildContext context;
  Size({required this.context});

  h(double i) => MediaQuery.of(this.context).size.height * (i/100);
  w(double i) => MediaQuery.of(this.context).size.width * (i/100);

}