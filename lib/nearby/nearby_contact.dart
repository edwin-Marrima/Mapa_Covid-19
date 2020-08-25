import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:location/location.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:geolocator/geolocator.dart';

class contactos extends StatefulWidget {
  @override
  _contactosState createState() => _contactosState();
}

class _contactosState extends State<contactos> {
  void localizacao() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
  }

  Firestore _firestore = Firestore.instance;
  final Strategy strategy = Strategy.P2P_STAR;
  String userName ='840233996';
  void descobrir_usuariosProximos() async{
    try {
      bool a = await Nearby().startDiscovery(
        userName,
        strategy,
        onEndpointFound: (String id,String userName, String serviceId) {
          // called when an advertiser is found
        },
        onEndpointLost: (String id) {
          //called when an advertiser is lost (only if we weren't connected to it )
        },
        serviceId: "com.yourdomain.appname", // uniquely identifies your app
      );
    } catch (e) {
      // platform exceptions like unable to start bluetooth or insufficient permissions
    }
  }
  @override
  void initState() {
    getPermissions();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

void getPermissions() {
  Nearby().askLocationAndExternalStoragePermission();
}