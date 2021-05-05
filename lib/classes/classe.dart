import 'package:mapa_covid/Estatico.dart';

class usuario{
  String nome;
  String contacto;
  String contacto_alt;
  String estado;
  usuario({this.contacto,this.nome,this.contacto_alt,this.estado});
  Map toMap(usuario user){
  Map<String,dynamic> map = Map();
    map['nome']           =   user.nome;
    map['contacto']       =   user.contacto;
    map['contacto_alt']   =   user.contacto_alt;
    map['estado']   =   user.estado;
    return map;
  }
  usuario toClass(Map map){
    return usuario(contacto: map['contacto'],contacto_alt: map['contacto_alt'] ,nome:  map['nome'],estado: map['estado']);
  }
}


class Contacto{

  String estado;
  int nr_contactos;
  String data;
  String contacto;
  String latitude;
  String longitude;
  String contacto_main;
  Contacto ({this.contacto,this.estado,this.data,this.latitude,this.longitude,this.contacto_main,this.nr_contactos});
  Map toMap(Contacto contacto){
    Map<String,dynamic> map = Map();
    map['nr_contactos'] = contacto.nr_contactos;
    map['data']  =contacto.data;
    map['contacto']  =contacto.contacto;
    map['latitude']  =contacto.latitude;
    map['longitude']  =contacto.longitude;
    map['contacto_main']  =contacto.contacto_main;
    return map;
  }
  Contacto toClass(Map map){
    return Contacto (contacto: map['contacto'], data: map['data'], latitude: map['latitude'],
        longitude: map['longitude'],contacto_main: Estatico.user.contacto,nr_contactos: map['nr_contactos']);
  }
}