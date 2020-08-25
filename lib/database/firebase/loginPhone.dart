

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapa_covid/Estatico.dart';
import 'package:mapa_covid/classes/classe.dart';

Firestore _dbFireStore  = Firestore.instance;
class Registrar{
usuario user = usuario();

  Future<bool> verificaExistencia(String number) async{
    bool dado = false;
    QuerySnapshot snapshot =   await _dbFireStore.collection('usuario').where('contacto',isEqualTo:number).getDocuments();
     for(DocumentSnapshot doc in snapshot.documents){
       dado =true;
       Estatico.user = usuario(nome:doc['nome'] ,contacto:doc['contacto'] ,contacto_alt:doc['contacto_alt'] ,estado: doc['estado']);
     }
 return dado; }



 Future <void> cadastrarUsuario(Map map) async{
    await _dbFireStore.collection('usuario').document().setData(map);
 }

}