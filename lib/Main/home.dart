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

  List<Contacto> lista = [];
  Future<LocationData> localizacao() async{
    Location location = Location();
    LocationData aa = await location.getLocation();
    return aa;
  }
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
    LocationData posicao = await localizacao();
    print('Ola');
    Contacto contacto = Contacto(contacto_main: Estatico.user.contacto,contacto: nr_celular,data: dataa,nr_contactos: 1,
        latitude: posicao.latitude.toString(),longitude: posicao.longitude.toString(),estado: estado);
        lista.insert(0,contacto);
    await contactoDataBase.gravaContacto(contacto);
  }
  setState(() {});
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
  _listaEmpty()=>Padding(
    padding: EdgeInsets.all(15),
  child: !Estatico.rede?_networkProblem():spinkit,
  );
  Future<void> DownList()async{
    Conectividade conectividade = Conectividade();
    conectividade.conectividade_dois((){if(mounted){setState(() {});}});
    this.lista = await carrega.carregaContactosDataBase((){if(mounted){setState(() {});}});
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
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
                SizedBox(height: 30,),
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
                SizedBox(height: 25,),
              ],
            ),
          ),
        ),
      )
    );
  }
}
var decoracao = BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.all(Radius.circular(9)),
  boxShadow: [
    BoxShadow(
      color:Colors.grey.withOpacity(0.5),
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