import 'package:location/location.dart';
import 'package:mapa_covid/classes/classe.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_covid/classes/classe.dart';


class Estatico{
  static usuario user = usuario();
  static bool rede = true;
  static LocationData locationData;
  static List <Marker> allMarkers= List();
  static List<Contacto> EstList = List();
}