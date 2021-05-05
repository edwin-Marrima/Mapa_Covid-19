import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapa_covid/classes/classe.dart';
import 'package:mapa_covid/ciclo/ContactosCiclo.dart';
import 'package:mapa_covid/database/subscribe.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:mapa_covid/database/firebase/contacto.dart';
import 'package:mapa_covid/Estatico.dart';
import 'package:mapa_covid/database/firebase/Carrega.dart';
import 'package:mapa_covid/conectividade/conectividade.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController txt = TextEditingController();
  final Strategy strategy = Strategy.P2P_CLUSTER;
  Carrega carrega = Carrega();
  ContactoDataBase contactoDataBase = ContactoDataBase();
  String latitude='null';
  String longitude='null';
  String dados ='cc';
  String contacto;
  bool a=false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Contacto> lista = [];

Future<void> infoAdiciona(String userContact) async{
   bool existencia = false;
   var x = DateTime.now();
   String hora = x.hour.toString()+":"+x.minute.toString();
  final df = new DateFormat('dd-MM-yyyy');
 String dataa= df.format(new DateTime.now()).toString()+"/"+hora;

  String nr_celular;
  String estado;
  nr_celular = userContact.substring(0,9);
  estado = userContact[userContact.length-1]=='0'?'false':'true';
  print('contacto...'+nr_celular);
  for(int i=0;i<lista.length;i++){
    if(lista[i].contacto==nr_celular && lista[i].contacto_main==Estatico.user.contacto){
      print('dentro'+i.toString());
      lista[i].nr_contactos = lista[i].nr_contactos+1;
      lista[i].data = dataa;
      lista[i].estado = estado;
      Contacto contacto = lista[i];
      lista.removeAt(i);lista.insert(0, contacto);
      await contactoDataBase.AtualizaContacto(contacto);
      existencia =true;
      break;
    }
  }
  if(!existencia) {
    print('Ola');
    Contacto contacto = Contacto(contacto_main: Estatico.user.contacto,contacto: nr_celular,data: dataa,nr_contactos: 1,
        latitude: Estatico.locationData.latitude.toString(),longitude:Estatico.locationData.longitude.toString(),estado: estado);
        lista.insert(0,contacto);
    await contactoDataBase.gravaContacto(contacto);
  }
  setState(() {});
   Estatico.EstList = this.lista;
  }
  Future<void> descobrir_usuariosProximos() async{
    await Nearby().stopDiscovery();
    try {
       a = await Nearby().startDiscovery(
        this.contacto,
        strategy,
        onEndpointFound: (id,userName,serviceId)async {
          dados = userName +"/"+id+"/"+serviceId+"WAAA";
          print(dados);
          await infoAdiciona(userName);

        },
        onEndpointLost: (id) {
          print('xxxxx');
          dados = "WAAA";
          setState(() {});
          //called when an advertiser is lost (only if we weren't connected to it )
        },
        //serviceId: "AAAAAA", // uniquely identifies your app
      );
      print('Discovery ${a.toString()}');
    } catch (e) {
      // platform exceptions like unable to start bluetooth or insufficient permissions
      print(e.toString()+"descovery");
    }
  }


  void conexao() async{
    getPermissions();
    localizacao();
    await Nearby().stopAdvertising();
    try {
      bool a = await Nearby().startAdvertising(
        this.contacto,
        strategy,
        onConnectionInitiated: null,
        onConnectionResult: (id, status) {
          print(status);
        },
        onDisconnected: (id) {
          print('Disconnected $id');
        },
      );

      print('ADVERTISING ${a.toString()}');
    } catch (e) {
      print(e);
    }
    descobrir_usuariosProximos();

  }
  final spinkit = Center(child:SpinKitDoubleBounce(
    color: Colors.orange[900],
    size: 40.0,
  ));
  Future<void> localizacao() async{
    Location location = Location();
    LocationData aa = await location.getLocation();
    Estatico.locationData = aa;
    print(Estatico.locationData.longitude);
    print(Estatico.locationData.latitude);
  }
  _listaEmpty()=>Padding(
    padding: EdgeInsets.all(15),
  child: !Estatico.rede?_networkProblem():spinkit,
  );
  Future<void> DownList()async{
    Conectividade conectividade = Conectividade();
    conectividade.conectividade_dois((){if(mounted){setState(() {});}});
    this.lista = await carrega.carregaContactosDataBase((){if(mounted){setState(() {});}});
    Estatico.EstList = this.lista;
    setState(() {});
    conexao();
    setState(() {});
  }

  @override
  void initState() {
    this.contacto = Estatico.user.contacto;
    if(Estatico.user.estado=='false'){this.contacto = this.contacto + " 0"; }else{this.contacto = this.contacto + " 1";}
   // this.contacto = this.contacto + " " +
    print(this.contacto);
   // Estatico.user = usuario(estado: 'true',contacto: '840000000',contacto_alt: '840233996',nome: 'Edwin Marrima');
    DownList();
  }
  _snackbar(String text,Color fundo){
    final snackbar = new SnackBar(
      content:  Text(text,
        style: TextStyle(
          color: Colors.cyan[100],
          letterSpacing: 1.1,
        ),),

      backgroundColor: fundo,
      duration: Duration(seconds: 5),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
  @override
  Widget build(BuildContext context) {
    var sw = MediaQuery.of(context).size.width;
    var sh = MediaQuery.of(context).size.height;
    return Scaffold(
      key:  _scaffoldKey,
      backgroundColor: Colors.white,
      body:  SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Center(
                      child: Container(
                        width: sw*0.96,
                        decoration: _decoracao,
                        child: Column(
                          children: <Widget>[

                           Text(Estatico.user.nome ,style: TextStyle(letterSpacing: 1.0,fontFamily: 'Tenali',fontWeight:FontWeight.bold,color: Colors.black,fontSize: 32)),
                            Text(Estatico.user.estado=='false'?'Não infetado':'Contaminado' ,style: TextStyle(letterSpacing: 1.0,fontFamily: 'Montserrat',color: Colors.black,fontSize: 15)),

                            Switch(
                              value: Estatico.user.estado=='false'?false:true,
                              onChanged: (value)async{
                                Estatico.user.estado = value?'true':'false';
                                if(value){this.contacto =Estatico.user.contacto;this.contacto=this.contacto+" 1";}
                                else{this.contacto =Estatico.user.contacto;this.contacto=this.contacto+" 0";}
                                setState(() {});
                                if(await carrega.alterarEstado(value)){}
                                else{Estatico.user.estado = !value?'true':'false';
                                cadastroUsuarioLocal local = cadastroUsuarioLocal();
                                local.updateEstadoUser();
                                }
                              setState(() {});
                              },
                            )
                          ],
                        ),
                      ),
                    ),

                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Buscando  ' ,style: TextStyle(letterSpacing: 1.0,fontFamily: 'Montserrat',color: Colors.black,fontSize: 15)),
                      Container(height: 10,width: 15,
                          child: CircularProgressIndicator(backgroundColor: Colors.red,)),
                      Text('  contactos' ,style: TextStyle(letterSpacing: 1.0,fontFamily: 'Montserrat',color: Colors.black,fontSize: 15)),
                    ],
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: decoracao,
                    height: 400,
                    child: SingleChildScrollView(
                      child: Column(
                        children: lista.length==0? <Widget>[_listaEmpty()]
                        :lista.map((dados)=> ClicloCont(
                          contacto: dados,
                        )).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 13,),

                ],
              ),
            ),
          ),
        ),
 bottomSheet: Container(
   margin: EdgeInsets.fromLTRB(7, 0, 7,3),
   width: sw,
   height: 50,
  decoration: _decoracao,
   child: FlatButton(
     child: Container(
       child: Column(
         children: <Widget>[
           Icon(Icons.location_on,color: Colors.cyan[900],),
           Text('Mapeamento',style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold),),
         ],
       ),
     ),
     onPressed: () async{
       if(Estatico.locationData.toString()=='null'){
         showD(context,'O serviço de geocalização esta provavelmente'
             ' desativado ou a aplicação não possui autorização para aceder a localização'
             ' do dispositivo.');
       }else if(!Estatico.rede){

         showD(context,'Verifique o seu pacote de dados ou a sua conexão a internet.');
       }else{
         await Navigator.of(context).pushNamed('/Mapeamento',arguments: {});
       }

     },
   ),
 ),
    );
  }
}
void showD(BuildContext context,String txt){
  showDialog(context: context,
      barrierDismissible: false,
      builder: (context)=>Container(
        child: AlertDialog(
          title: Text('Tentativa mal sucedida',style: TextStyle(letterSpacing: 1.0,fontFamily: 'Montserrat',color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
          content: Container(
            //decoration: decoracao,
            child:Wrap(
              children: <Widget>[
                Text(txt,style: TextStyle(letterSpacing: 1.0,fontFamily: 'Montserrat',color: Colors.black,fontSize: 15),textAlign: TextAlign.justify,),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Fechar"),
              onPressed: () async{
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      )
  );
}

var decoracao = BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(9)),
  boxShadow: [
    BoxShadow(
      color:Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0,7),
    )
  ],
);
var _decoracao = BoxDecoration(
gradient: LinearGradient(
begin:  Alignment.topLeft,
end: Alignment.bottomRight,
stops: [0.3,1],
colors:[
Colors.grey,
Colors.red,

],
),
borderRadius: BorderRadius.all(
Radius.circular(15),
),
boxShadow: [
BoxShadow(
color:Colors.grey.withOpacity(0.7),
spreadRadius: 5,
blurRadius: 7,
offset: Offset(0,7),
)
],
);
void getPermissions()async {
 await Nearby().askLocationAndExternalStoragePermission();
}
_EmptyList(Function function)=>  Container(
  decoration: decoracao,
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: <Widget>[

          Text('Boa noticia, nenhum contacto foi registrado…',style: TextStyle(fontFamily: 'Montserrat',color: Colors.redAccent,fontWeight: FontWeight.bold)),
        SizedBox(height: 2,),
           Text('Compartilhe este aplicativo com as pessoas mais próximas e ajude as autoridades Moçambicanas na luta contra o covid-19',style: TextStyle(fontFamily: 'Montserrat')),
        SizedBox(height: 10,),
        Text('Por um Moçambique melhor',style: TextStyle(fontFamily: 'Montserrat')),
        SizedBox(height: 10,),
          IconButton(
          icon: Icon(Icons.refresh),
            onPressed: () async{
                await function();
            },
        )
      ],

    ),
  ),
);
_networkProblem()=>  Container(
  decoration: decoracao,
  child: Wrap(
    children: <Widget>[
      _networ(),
    ],

  ),
);
_networ()=>Container(
  child: Column(

    children: <Widget>[
      Icon(Icons.wifi,size: 120,color: Colors.grey,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Sem conexão de Internet',style: TextStyle(fontFamily: 'Montserrat',fontSize: 17),),
        ],
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(40, 5, 40, 10),
        child: Wrap(
          children: <Widget>[
            Text('Não foi possível obter o conteúdo. Talvez você tenha perdido a conexão? verifique o seu pacote de dados ou a sua conexão a internet.',textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
          ],
        ),
      )
    ],),
);