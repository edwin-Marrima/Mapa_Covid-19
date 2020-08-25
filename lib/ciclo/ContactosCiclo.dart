import 'package:flutter/material.dart';
import 'package:mapa_covid/classes/classe.dart';
class ClicloCont extends StatelessWidget {
  Contacto contacto;
  String estado;
  String numero;
  ClicloCont({this.contacto});

  @override
  Widget build(BuildContext context) {
    if(contacto.estado=='false'){estado='Não infetado';}else{estado='Contaminado';}
    numero = _organiza(contacto.contacto);
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 2),
      decoration: _decoracao(contacto.estado=='false'?Colors.white:Colors.redAccent),
      child: Column(
        children: <Widget>[
          ListTile(
           title: Text('Contacto: '+numero,style: TextStyle(letterSpacing: 1.0,fontFamily: 'Montserrat',color: Colors.black,fontSize: 15,)),
            subtitle: Text(estado,style: TextStyle(letterSpacing: 1.0,fontFamily: 'Montserrat',color: Colors.black,fontSize: 14)),
            trailing: Text(contacto.data),
          ),
        ],
      ),
    );
  }
}
String _organiza(String nr){
  return nr[0].toString()+"******"+nr[7].toString()+nr[8].toString();
}
_decoracao(Color cor) => BoxDecoration(color: cor, borderRadius: BorderRadius.all(Radius.circular(9)),
  boxShadow: [
    BoxShadow(
      color:Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0,7),
    )
  ],
);