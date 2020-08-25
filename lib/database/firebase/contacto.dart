import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapa_covid/Estatico.dart';
import 'package:mapa_covid/classes/classe.dart';

Firestore _dbFireStore  = Firestore.instance;
final String coleccao = 'contacto';
final String estado = 'estado';
final String nr_contactos = 'nr_contactos';
final String data ='data';
final String contacto = 'contacto';
final String latitude = 'latitude';
final String longitude = 'longitude';
class ContactoDataBase{
Contacto obj = Contacto();
String docID;

  Future<bool>AtualizaContacto(Contacto contacto) async{
    bool dado = false;
    print('fire estou');
    QuerySnapshot snapshot =   await _dbFireStore.collection(coleccao).where('contacto',isEqualTo:contacto.contacto).where('contacto_main',isEqualTo: Estatico.user.contacto).getDocuments();
    print('fire estou');
    for(DocumentSnapshot doc in snapshot.documents){
     dado= true;
    print('||||');
     Map<String,dynamic> map = Map();
     map['data'] = contacto.data;map['nr_contactos'] = contacto.nr_contactos+1;
       await _dbFireStore.collection(coleccao).document(doc.documentID).updateData(map);

      break;
    }
    return dado;
  }
  Future <bool> gravaContacto(Contacto contacto) async{
       await _dbFireStore.collection(coleccao).document().setData(obj.toMap(contacto));
  }

}