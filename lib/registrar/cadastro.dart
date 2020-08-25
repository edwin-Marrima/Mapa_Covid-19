import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mapa_covid/Estatico.dart';
import 'package:mapa_covid/Estatico/padroesDesign.dart';
import 'package:mapa_covid/Main/principal.dart';
import 'package:mapa_covid/classes/classe.dart';
import 'package:mapa_covid/conectividade/conectividade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mapa_covid/database/firebase/loginPhone.dart';
import 'package:mapa_covid/database/subscribe.dart';
import 'package:string_validator/string_validator.dart';
class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

final _auth =  FirebaseAuth.instance;
final TextEditingController codigo = TextEditingController();

class _CadastroState extends State<Cadastro> {

  TextEditingController txt = TextEditingController();
  TextEditingController passwordd = TextEditingController();
  TextEditingController number_1 = TextEditingController();
  TextEditingController number_2 = TextEditingController();
  TextEditingController pass_1 = TextEditingController();
  TextEditingController pass_2 = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  String smsCode;
  String verificationID;
  bool progress =false;
  bool sucesso = false;


  Future <void> conectividade(Function estado){
    Conectividade conectividade = Conectividade();
    conectividade.conectividade_dois((){if(mounted){estado();}});
  }


  @override
  void initState() {
    // TODO: implement initState
    number_1.text = Estatico.user.contacto;
    conectividade((){setState(() {});});
  }
  final spinkit = Center(child:SpinKitCubeGrid(
    color: Colors.orange[900],
    size: 40.0,
  ));

        Future<void>loginc() async{
          progress=true;
          setState(() {});
          Registrar obj = Registrar();
          usuario obj_1 = usuario();
          cadastroUsuarioLocal instancia  = cadastroUsuarioLocal();
          await obj.cadastrarUsuario(obj_1.toMap(usuario(nome: txt.text,contacto_alt: number_2.text,contacto:Estatico.user.contacto,estado: 'false')));
          int retorno = await instancia.saveUser(usuario(nome: txt.text,contacto_alt: number_2.text,contacto: Estatico.user.contacto,estado: 'false'));
          print(retorno);
          Estatico.user = usuario(nome: txt.text,contacto_alt: number_2.text,contacto: number_1.text,estado: 'false');
          progress=false;
          setState(() {});
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Principal(),), (Route<dynamic> route) => false);

        }
  @override
  Widget build(BuildContext context) {
    var decoracao = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(11)),
      boxShadow: [
        BoxShadow(
          color:Colors.grey.withOpacity(0.7),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0,7),
        )
      ],
    );
    var NomeCompleto = TextFormField(
      controller:  txt,  //pra poder ter ou p// or o valor no emailInput
      validator: (String value){
        if(value.isEmpty){
          return 'Por favor, introduza o seu nome completo...';
        }if (isEmail(value)){
          return 'Dados inválidos';
        }else if (isInt(value)){
          return 'Dados inválidos';
        }else if (!numer(value)){
          return 'Dados inválidos';
        }else if(!numer_1(value)){
          return 'Dados inválidos';
        }
      },
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      // textAlign: TextAlign.center, //alinhar o texto
      textAlign: TextAlign.center,
      decoration: InputDecoration(

        errorStyle: TextStyle(
          letterSpacing: 0.5,
        ),
        hintText: 'Introduza o seu nome completo',
        //focusColor: Colors.amber,
        filled: true,
        fillColor: Colors.grey[100],
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[600]),
          borderRadius: BorderRadius.circular(10.7),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.7),
        ),
        focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10.7),
        ),

      ),
    );
    var contacto_1= TextFormField(
      controller:  number_1,  //
      maxLength: 9,// pra poder ter ou por o valor no emailInput
      validator: (String value){
        if(value.isEmpty){
          return 'Campo vazio...';
        }else if(!isInt(value)){
          return 'Dados inválidos';
        }else if(value.length!=9){
          return 'Dados inválidos!';
        }else if(value[0]!='8'){
          return 'Dados inválidos...';
        }
      },
      autofocus: false,
      keyboardType: TextInputType.number,
      // textAlign: TextAlign.center, //alinhar o texto
      textAlign: TextAlign.center,
      decoration: InputDecoration(

        errorStyle: TextStyle(
          letterSpacing: 0.5,
        ),
        hintText: 'Introduza o seu número de celular',
        //focusColor: Colors.amber,
        filled: true,
        fillColor: Colors.grey[100],
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[600]),
          borderRadius: BorderRadius.circular(10.7),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.7),
        ),
        focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10.7),
        ),

      ),
    );
    var contacto_2 = TextFormField(
      controller:  number_2,  //pra poder ter ou por o valor no emailInput
      validator: (String value){
        if(value.isEmpty){
          return 'Campo vazio...';
        }else if(!isInt(value)){
         return 'Dados inválidos';
        }else if(value.length!=9){
          return 'Dados inválidos!';
        }else if(value[0]!='8'){
          return 'Dados inválidos...';
        }
      },
      autofocus: false,
      keyboardType: TextInputType.number,
      maxLength: 9,
      // textAlign: TextAlign.center, //alinhar o texto
      textAlign: TextAlign.center,
      decoration: InputDecoration(

        errorStyle: TextStyle(
          letterSpacing: 0.5,
        ),
        hintText: 'Introduza o seu número de celular alternativo',
        //focusColor: Colors.amber,
        filled: true,
        fillColor: Colors.grey[100],
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[600]),
          borderRadius: BorderRadius.circular(10.7),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.7),
        ),
        focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10.7),
        ),

      ),
    );

    final buttonSubmit =  Container(
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
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
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color:Colors.grey.withOpacity(0.7),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0,7),
          )
        ],
      ),
      child: SizedBox.expand(
        child: FlatButton(
          onPressed: () async{
            if(_formKey.currentState.validate()) {
              loginc();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Continuar')
            ],
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: _retornoAppBar(context),
      body: SingleChildScrollView(
        reverse: true,
        child: SafeArea(
           child: Container(
             child: Column(
               children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Criar conta!',style: TextStyle(letterSpacing: 1.0, fontFamily: 'Tenali',fontSize: 25),)
                    ],
                  ),
                 Form(
                     key: _formKey,
                     child: Column(
                       children: <Widget>[
                         Container(
                           decoration: decoracao,
                           margin: EdgeInsets.fromLTRB(10, 10,10, 0),
                           padding: EdgeInsets.fromLTRB(0, 0,0, 10),
                           child: Column(
                             children: <Widget>[
                               Text('Nome',style: TextStyle(letterSpacing: 1.0, fontFamily: 'Tenali',fontSize: 25),textAlign: TextAlign.center,),
                               Divider(endIndent: 100,indent: 100,color: Colors.grey,height: 0,),
                               ExpansionTile(
                                 leading: Icon(Icons.person,color: Colors.cyan[900],),
                                 initiallyExpanded: false,
                                 title:NomeCompleto,
                                 children: <Widget>[
                                   Text('Neste campo deve ser introduzido o seu contacto principal.')
                                 ],
                               ),

                             ],
                           ),
                         ),
                        Container(
                          decoration: decoracao,
                          margin: EdgeInsets.fromLTRB(10, 10,10, 0),
                          padding: EdgeInsets.fromLTRB(0, 0,0, 10),
                          child: Column(
                            children: <Widget>[
                              Text('Contacto',style: TextStyle(letterSpacing: 1.0, fontFamily: 'Tenali',fontSize: 25),textAlign: TextAlign.center,),
                              Divider(endIndent: 100,indent: 100,color: Colors.grey,height: 0,),
                              ExpansionTile(
                                leading: Icon(Icons.phone,color: Colors.cyan[900],),
                                initiallyExpanded: false,
                                title:contacto_1,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Neste campo deve ser introduzido o seu contacto principal.'
                                         ,textAlign: TextAlign.justify,
                                      style: TextStyle(fontFamily: 'Montserrat'),),
                                  )
                                ],
                              ),
                              ExpansionTile(
                                initiallyExpanded: false,
                                leading: Icon(Icons.phone,color: Colors.cyan[900],),
                                title:contacto_2,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Neste campo deve ser introduzido o seu contacto alternativo, '
                                        'em caso de impossibilidade de comunicação com o contacto principal o contacto alternativo será usado. ',textAlign: TextAlign.justify,
                                    style: TextStyle(fontFamily: 'Montserrat'),),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),

                       ],
                     ),
                 ),
                 progress?spinkit:Text(''),
                 SizedBox(height: 15,),
                 Estatico.rede?Padding(
                   padding: const EdgeInsets.fromLTRB(20, 0, 20,0),
                   child: buttonSubmit,
                 ):_networkProblem(),
                 SizedBox(height: 20,)
               ],
             ),
           ),
        ),
      ),

    );
  }
}
bool numer(String value){
  bool retorno =true;
   for(int i=0;i<value.length;i++){
     if(RegExp(r'^-?[0-9]+$').hasMatch(value[i])){
        retorno =false;
     }
   }
   return retorno;
}
bool numer_1(String value){
  bool retorno =true;
  for(int i=0;i<value.length;i++){
    if(isIn(value[i], "~!@#%^&*()_+`<>?:|},.;’[]`~!@#%^&*()_+`<>?”:|}”,.;’[]`")){
      retorno =false;
    }
  }
  return retorno;
}
_retornoAppBar(BuildContext context){
  var sh = MediaQuery.of(context).size.height;
  return PreferredSize(
    preferredSize: Size.fromHeight(50),
    child: Container(
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
var decoracao = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(11)),
  boxShadow: [
    BoxShadow(
      color:Colors.grey.withOpacity(0.7),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0,7),
    )
  ],
);
_networkProblem()=>  Container(
  decoration: decoracao,
  child: Wrap(
    children: <Widget>[
      _networ(),
      Container(
        decoration: decoracao,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          ],
        ),
      ),
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
            Text('Não é possível efetuar o cadastro. Talvez você tenha perdido a conexão? verifique o seu pacote de dados ou a sua conexão a internet.',textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
          ],
        ),
      )
    ],),
);