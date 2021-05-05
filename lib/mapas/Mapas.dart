import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:location/location.dart';
import 'package:mapa_covid/Estatico.dart';
import 'package:geolocator/geolocator.dart';

import 'package:mapa_covid/conectividade/conectividade.dart';
List <Marker> Markers= List();
List <Circle> circulo = List();

class Mapeamento extends StatefulWidget {
  final Key _mapKey = UniqueKey();
  @override
  _MapeamentoState createState() => _MapeamentoState();
}

class _MapeamentoState extends State<Mapeamento> {

GoogleMapController _mapController ;
void net(){
  Conectividade conectividade = Conectividade();
  conectividade.conectividade_dois((){if(mounted){setState(() {});}});
}
final spinkit = Center(child:SpinKitCubeGrid(
  color: Colors.orange[900],
  size: 40.0,
));
@override
void initState() {

    Markers.add(Marker(
      markerId: MarkerId('aaasasas'),
      draggable: true,
      onTap: () {
        print('Marquer click');
      },
      position: LatLng(
          Estatico.locationData.latitude,Estatico.locationData.longitude),
      infoWindow: InfoWindow(title: 'Minha localização', snippet: 'Eu'),
    ));

try {
  for (int i = 0; i < Estatico.EstList.length; i++) {
    var a = double.parse(Estatico.EstList[i].latitude);
    var b = double.parse(Estatico.EstList[i].longitude);
      LatLng _center = LatLng( a,b);
      Markers.add(Marker(
      markerId: MarkerId('aaasasas'),
      draggable: false,
      onTap: () {print('Marquer click');},
      position: _center,
     infoWindow: InfoWindow(title: 'Local de contacto', snippet: (i+1).toString()),
    ));
    circulo.add(Circle(
        circleId: CircleId('aaaaa'),
        fillColor: Colors.cyan.withOpacity(0.3),
        radius: 1000.0,
        center: LatLng(a,b),
        onTap: (){}
    ));
  }
}catch(e){
  print(e);
}
  }
void _onMapCreated(GoogleMapController controller) {
  _mapController = controller;
  if(mounted){setState(() {});}
  int x=_mapController.mapId;
}
  @override
  Widget build(BuildContext context) {
    var sw = MediaQuery.of(context).size.width;
    var sh = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: _retornoAppBar(context),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
            child: !Estatico.rede?_networ():Estatico.locationData.toString()=='null'?spinkit:TheMap(key:widget._mapKey)
      ),
    );
  }
}
class TheMap extends StatefulWidget
{
  ///key is required, otherwise map crashes on hot reload
  TheMap({ @required Key key})
      :
        super(key:key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TheMap>
{
  GoogleMapController _mapController ;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }
  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target:  LatLng(Estatico.locationData.latitude,Estatico.locationData.longitude),
            zoom: 12.0,
          ),
          markers: Set.from(Markers),
            circles:Set.from(circulo),
        )
    );
  }
}
_retornoAppBar(BuildContext context){
  var sh = MediaQuery.of(context).size.height;
  return PreferredSize(
    preferredSize: Size.fromHeight(50),
    child: Container(
      color: Colors.transparent,
      alignment: Alignment.bottomCenter,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: FlatButton.icon(onPressed: (){Navigator.pop(context,{});},
                icon:Icon(Icons.arrow_back_ios),
                label: Text('Retroceder',style: TextStyle(fontSize: 12),)
            ),
          ),
        ],
      ),
    ),
  );
}
var decoracao = BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.all(Radius.circular(9)), boxShadow: [BoxShadow(color:Colors.grey.withOpacity(0.5), spreadRadius: 5, blurRadius: 7, offset: Offset(0,7),)],);

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