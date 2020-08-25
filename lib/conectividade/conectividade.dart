import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:mapa_covid/Estatico.dart';
class Conectividade{
  Future<bool> conectividade_dois(Function NovoEstado) async{
    bool result  =await DataConnectionChecker().hasConnection;
    DataConnectionChecker().onStatusChange.listen((x) async{
      print("Entre");
      DataConnectionStatus dataConnectionStatus = await DataConnectionChecker().connectionStatus;
      var aa = await DataConnectionChecker().hasConnection;
      Estatico.rede= aa==true? true:false;
      NovoEstado();
      print("status:"+dataConnectionStatus.toString());
      print(aa==true? "True":"false");
    });
    if(result == true){
      print("tem megas");
    }else{
      print("Nao ha megas");
    }
    return result; }
}