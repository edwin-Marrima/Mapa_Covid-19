

import 'package:flutter/material.dart';
import 'package:mapa_covid/login/login.dart';
import 'package:mapa_covid/registrar/cadastro.dart';
import 'package:mapa_covid/Main/principal.dart';
import 'package:mapa_covid/mapas/Mapas.dart';
void main() => runApp(MaterialApp(
  title: 'MapaCovid',
  debugShowCheckedModeBanner: false,
  initialRoute: '/Login',
    routes: <String,WidgetBuilder>{
      '/Login': (context)=> Login(),
      '/Cadastro': (context)=> Cadastro(),
      '/Principal': (context)=> Principal(),
      '/Mapeamento':(context)=> Mapeamento(),
    }
));

