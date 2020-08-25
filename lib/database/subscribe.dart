import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mapa_covid/Estatico.dart';
import 'package:mapa_covid/classes/classe.dart';
final String TabelaUsuario = "UserTable";
final String nome = 'nome';
final String contacto = 'contacto';
final String contacto_alt='contacto_alt';
final String estado='estado';
class cadastroUsuarioLocal{
  usuario obj =  usuario();
  Database _db;


  Future <Database> get db async{
    if(_db!=null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }

  Future <Database> initDb() async{
    final databasePath =await getDatabasesPath();
    final path = join(databasePath,"usuario.db");

    return await openDatabase(path,version: 1,onCreate: (Database db, int newerVersion) async{
      await db.execute(
         'CREATE TABLE $TabelaUsuario($nome VARCHAR(50) NOT NULL,$contacto VARCHAR(20) NOT NULL ,$contacto_alt VARCHAR(20) NOT NULL,$estado VARCHAR(20) NOT NULL)'


      );

    });
  }

  Future <int> saveUser(usuario user)async{
    int retorno = 0;
    Map <String,dynamic> map = Map();
    map = obj.toMap(user);
    Database dbUser =await db;
    try {
      retorno = await dbUser.insert(TabelaUsuario, map);

    }catch(e){
      print(e.toString());
      return retorno;
    }
  return retorno;
  }
  Future <void> updateEstadoUser() async{
    Database dbUser =await db;
    try{
      await dbUser.rawUpdate('update $TabelaUsuario set $estado=?',[Estatico.user.estado]);
    }catch(e){
      print("UPDATE_USER_LOCAL ERROR"+e.toString());
    }
  }

  Future <int> getAllUsers() async{
    Database dbUser =await db;
    List listMap;
    try {
      listMap = await dbUser.rawQuery("SELECT * FROM $TabelaUsuario");
      for (Map map in listMap) {
        Estatico.user = obj.toClass(map);
        break;
      }
      print(listMap.length.toString() + ":tamanho");
    }catch(e){print("get all users error: "+e.toString());}
    return listMap.length;
  }

  Future <void> dropDataBase()async{
    Database dbUser =await db;
    try {
      await dbUser.execute("delete from $TabelaUsuario");
    }catch(err){print("Error droping databases.."+err.toString());}
  }
}
