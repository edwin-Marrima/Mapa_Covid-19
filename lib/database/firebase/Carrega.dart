import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapa_covid/Estatico.dart';
import 'package:mapa_covid/classes/classe.dart';

import '../subscribe.dart';

Firestore _dbFireStore  = Firestore.instance;
final String coleccao = 'contacto';
final String estado = 'estado';
final String nr_contactos = 'nr_contactos';
final String data ='data';
final String contacto = 'contacto';
final String latitude = 'latitude';
final String longitude = 'longitude';

class Carrega{
  List<Contacto> lista = List();
  Contacto contacto =Contacto();
    Future<List<Contacto>> carregaContactosDataBase(Function funcao) async{

   try {
     QuerySnapshot snapshot = await _dbFireStore.collection('contacto').where(
         'contacto_main', isEqualTo: Estatico.user.contacto).getDocuments();
     print('cca');
     for (DocumentSnapshot doc in snapshot.documents) {
       print('vepen:' + doc.data['contacto']);
       QuerySnapshot snapshott = await _dbFireStore.collection('usuario').where(
           'contacto', isEqualTo: doc.data['contacto']).getDocuments();
       for (DocumentSnapshot dat in snapshott.documents) {
         print('vepenX:' + dat.data['nome']);
         contacto = contacto.toClass(doc.data);
         contacto.estado = dat.data['estado'];
         lista.add(contacto);
         _dbFireStore.collection('usuario').document(dat.documentID)
             .snapshots()
             .listen((dataa) {
           print(dataa.data);
           contacto.estado = dataa.data['estado'];
           funcao();
         });
         break;
       }
     }
   }catch(e){
     print(e.toString()+":ERROR carregar contacots");
   }
   funcao();
    return lista;
    }


    Future<bool> alterarEstado(bool estado) async{
      bool est = false;
      cadastroUsuarioLocal local = cadastroUsuarioLocal();
      QuerySnapshot snapshot = await _dbFireStore.collection('usuario').where('contacto',isEqualTo: Estatico.user.contacto).limit(1).getDocuments();
      for (DocumentSnapshot doc in snapshot.documents) {
            await _dbFireStore.collection('usuario').document(doc.documentID).updateData({'estado':estado?'true':'false'});
            est=true;
            local.updateEstadoUser();
      }

      return est;
    }
    Future <void> carregaEstado() async{
      QuerySnapshot snapshot =await _dbFireStore.collection('usuario').where('contacto',isEqualTo: Estatico.user.contacto).limit(1).getDocuments();
      for (DocumentSnapshot doc in snapshot.documents) {
        DocumentSnapshot snapshott = await _dbFireStore.collection('usuario').document(doc.documentID).get();
        Estatico.user.estado = snapshott['estado'];

      }

    }
}