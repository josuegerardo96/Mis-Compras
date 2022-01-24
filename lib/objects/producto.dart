
class producto {

  String? name;
  bool? state;


  producto({
    required this.name,
    required this.state,
  });



  producto.fromJSON({required Map json}){
    this.name = json['name'];
    this.state = json['state'];
  }

  Map<String, dynamic> toMap(){
    return {
      'name' :this.name,
      'state':this.state,
    };
  }


  String? get getName => this.name;
  set setName(String name) => this.name = name;

  get getState => this.state;
  set setState(bool state) => this.state = state;



}
