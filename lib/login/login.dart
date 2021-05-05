import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapa_covid/Estatico.dart';
import 'package:mapa_covid/Main/principal.dart';
import 'package:mapa_covid/classes/classe.dart';
import 'package:mapa_covid/conectividade/conectividade.dart';
import 'package:mapa_covid/Estatico/padroesDesign.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mapa_covid/database/firebase/loginPhone.dart';
import 'package:mapa_covid/database/subscribe.dart';
import 'package:string_validator/string_validator.dart';
import 'package:mapa_covid/Main/home.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}
final _auth =  FirebaseAuth.instance;
final TextEditingController codigo = TextEditingController();
class _LoginState extends State<Login> {
  Registrar registrar = Registrar();
  TextEditingController txt = TextEditingController();
  TextEditingController passwordd = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();
  String smsCode;
  String verificationID;
  bool process = false;
void conectividade(Function estado){
   Conectividade conectividade = Conectividade();
   conectividade.conectividade_dois((){if(mounted){estado();}});
 }
  void infoError(String content)=>
      showDialog(context: context,
          barrierDismissible: false,
          builder: (context)=>AlertDialog(
            title: Icon(Icons.mood_bad,color: Colors.black,size: 30,),
            content: Wrap(
              children: <Widget>[
                spinkit,
                Container(
                  //decoration: decoracao,
                  child:Text(content,softWrap: true,textAlign: TextAlign.center,
                    style: TextStyle(letterSpacing: 1.0,fontFamily: 'Tenali',color: Designer.corTextW,fontSize: 22),),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Fechar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          )
      );

Future<void> Verifica()async{
bool x =  await registrar.verificaExistencia(txt.text);
if(x){
  cadastroUsuarioLocal instancia  = cadastroUsuarioLocal();
  await instancia.dropDataBase();
  int retorno = await instancia.saveUser(Estatico.user);
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Home(),), (Route<dynamic> route) => false);
}else{
  Estatico.user.contacto = txt.text;
  Navigator.pushNamed(context,'/Cadastro');
}
}

  Future<void> Login(String number,Function funcao) async {
    process=true;
    funcao();
    final PhoneCodeAutoRetrievalTimeout autoRetrie = (String verId){
this.verificationID = verId;
    };
    final PhoneCodeSent codeSent =(String verId,[int  forceResendingToken]) async{//verificacao manuallll
                                          // this.verificationID = verId;
                                          showDialog(context: context,
                                              barrierDismissible: false,
                                              builder: (context)=>AlertDialog(
                                                title: Text('Ensira o codigo'),
                                                content: Container(
                                                  //decoration: decoracao,
                                                  child:Wrap(
                                                    children: <Widget>[
                                                      spinkit,
                                                      TextFormField(
                                                        keyboardType: TextInputType.number,
                                                        controller: codigo,
                                                        textAlign: TextAlign.center,
                                                        decoration: InputDecoration(
                                                          hintText: 'Insira o codigo recebido',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text("Enviar"),
                                                    onPressed: () async{
                                                      Navigator.of(context).pop();
                                                      AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verId, smsCode: codigo.text);
                                                      AuthResult result = await _auth.signInWithCredential(credential);
                                                      FirebaseUser user   = result.user;
                                                      process=false;
                                                      funcao();
                                                      if(user!=null){
                                                        process=false;
                                                        funcao();
                                                        print('Aceitou');
                                                        await Verifica();
                                                      }else{
                                                        process=false;
                                                        funcao();
                                                        infoError('Tentativa mal sucedida...!!!');
                                                        print('error');
                                                      }
                                                    },
                                                  ),
                                                ],
                                              )
                                          );
    };
    final PhoneVerificationCompleted verificationSucess = (AuthCredential auth) async{//ocorre quando a verificacao eh automatica
      process=false;
      funcao();
      print('verif ied');
      AuthResult result =  await _auth.signInWithCredential(auth);
      FirebaseUser user = result.user;
      if(user!=null){
        print('Aceitou');
        process=false;
        funcao();
        await Verifica();

      }
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
print(authException.toString()+"errror");
process=false;
funcao();
infoError('Tentativa mal sucedida...!!!');
        };
    _auth.verifyPhoneNumber(
        phoneNumber: "+258"+number,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationSucess,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoRetrie
    );



  }
  final spinkit = Center(child:SpinKitCubeGrid(
    color: Colors.orange[900],
    size: 40.0,
  ));
void dirigir()async{
  cadastroUsuarioLocal instancia = cadastroUsuarioLocal();
 // await instancia.dropDataBase();
  if(await instancia.getAllUsers()>0){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Home(),), (Route<dynamic> route) => false);
  }else{

  }

}
 @override
 void initState() {
   dirigir();
   conectividade((){setState(() {});});
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;


    var EmailInput = TextFormField(
        controller:  txt,  //pra poder ter ou por o valor no emailInput
      textAlign: TextAlign.center,
      maxLength: 9,
      validator: (String value){
      if(value.isEmpty){
        return 'Por favor, insira o seu contacto...';
      }else if(!isInt(value)){
        return 'Dados inválidos';
      }else if(value.length!=9){
        return 'Dados Incompletos ';
      }else if (!(value[0]!=8)){
        return 'Dados errados';
      }
    },
    autofocus: false,
    keyboardType: TextInputType.number,
    // textAlign: TextAlign.center, //alinhar o texto
    decoration: InputDecoration(
    errorStyle: TextStyle(
    letterSpacing: 0.5,
    ),
    hintText: 'Insira o seu contacto',
    //focusColor: Colors.amber,
    filled: true,
    fillColor: Colors.grey[390],
    labelStyle: TextStyle(
    color: Colors.black,
    ),
    errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red[600]),
    borderRadius: BorderRadius.circular(10.7),
    ),
    focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(10.7),
    ),
    focusedBorder:OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(10.7),
    ),
    enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
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
          Radius.circular(51),
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
            print(txt.text);
            if(_formKey.currentState.validate() && Estatico.rede) {
             await  Login(txt.text,(){setState(() {});});
           print('YAYAYYAYAYA');
             // _snackbar('Aguarde',Colors.cyan);


    //    await Future.delayed(Duration(seconds: 5));

            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Entrar')
            ],
          ),
        ),
      ),
    );
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Designer.corBackgroundW,
           body: SafeArea(
             child: SingleChildScrollView(
               reverse: true, //para subir automaticamente...
               child: SafeArea(
                    child: Column(
                        children: <Widget>[

                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 120, 20,0),
                            child: Text('Ajude a controlar',softWrap: true,textAlign: TextAlign.center,
                              style: TextStyle(letterSpacing: 1.0,fontFamily: 'IndieFlower',color: Designer.corTextW,fontSize: 30,fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20,0),
                            child: Text('o covid-19',softWrap: true,textAlign: TextAlign.center,
                              style: TextStyle(letterSpacing: 1.0,fontFamily: 'Tenali',color: Designer.corTextW,fontSize: 30),),
                          ),

                          !process?Icon(Icons.location_on):spinkit,
                          Divider(endIndent: 100,indent: 100,color: Colors.grey,),
                          Center(
                            child: Form(
                              key: _formKey,
                              child:Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child:Column(
                                children: <Widget>[

                                  Container(
                                    decoration: decoracao,
                                    margin: EdgeInsets.fromLTRB(10, 10,10, 0),
                                    padding: EdgeInsets.fromLTRB(0, 0,0, 10),
                                    child: Column(
                                      children: <Widget>[
                                        Text('Celular',style: TextStyle(letterSpacing: 1.0, fontFamily: 'Tenali',fontSize: 25),textAlign: TextAlign.center,),
                                       // Divider(endIndent: 100,indent: 100,color: Colors.grey,height: 0,),
                                        ExpansionTile(
                                          leading: Icon(Icons.person,color: Colors.cyan[900],),
                                          initiallyExpanded: false,
                                          title:EmailInput,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('Neste campo deve ser introduzido o seu contacto principal.'
                                                ,textAlign: TextAlign.justify,
                                                style: TextStyle(fontFamily: 'Montserrat'),),
                                            )
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Estatico.rede?Padding(
                                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                      child:buttonSubmit
                                  ):_networkProblem(),

                                ],
                              ),
                              ),
                            ),
                          ),

                        SizedBox(height: 40,)
                        ],
                      ),

               ),
             ),
           ),

    );
  }
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
            Text('Não foi possível obter o conteúdo. Talvez você tenha perdido a conexão? verifique o seu pacote de dados ou a sua conexão a internet.',textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
          ],
        ),
      )
    ],),
);