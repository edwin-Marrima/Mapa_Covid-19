import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapa_covid/Main/home.dart';
import 'package:mapa_covid/mapas/Mapas.dart';

import '../Estatico.dart';
class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  int _currentIndex=0;
  List <Widget> pages = [
    Home(),
    Mapeamento(),
  ];
  Future<void> localizacao() async{
    Location location = Location();
    LocationData aa = await location.getLocation();
    Estatico.locationData = aa;
    print(Estatico.locationData.longitude);
    print(Estatico.locationData.latitude);
  }
  @override
  void initState() {
   localizacao();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(
            color: Colors.cyan[900]
        ),
        currentIndex: _currentIndex,
        items: [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            title: Text('Localização'),
          ),

        ],
        onTap:(index){
          setState(() {
            _currentIndex = index;
          });
        } ,

      ),

    );
  }
}
