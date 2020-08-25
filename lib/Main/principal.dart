import 'package:flutter/material.dart';
import 'package:mapa_covid/Main/home.dart';
class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  int _currentIndex=0;
  List <Widget> pages = [
    Home(),
    Home(),
  ];
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
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text(''),
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
