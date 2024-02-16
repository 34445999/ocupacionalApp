import 'dart:developer';

import 'package:ocupacional/models/inasistencia.dart';
import 'package:ocupacional/models/institucion.dart';
import 'package:ocupacional/models/session_manager.dart';
import 'package:ocupacional/models/usuario.dart';
import 'package:ocupacional/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:ocupacional/services/inasistencia_service.dart';


import 'login.dart';
import 'nueva_inasistencia.dart';

class Home extends StatefulWidget {
  static String id = 'home';
  const Home({Key? key}) : super(key: key);


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Usuario objectUser;
  List<Inasistencia> consultas = [];

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _check());
  }

  void _check() async{
    AuthService authService = AuthService();
    var data = await authService.authenticateCheck();
    //log('Response status: ${data}');
    if(data['status'] == true) {
      consultas = [];
      var jsonUser = data['usuario'];
      var jsonUserInstitucion = jsonUser['users_instituciones'];
      var jsonPaciente = jsonUser['paciente'];
      var jsonInasistencias = data['inasistencias'];

      List<Institucion> instituciones = [];
      jsonUserInstitucion.forEach((data){
        Institucion objectInstitucion = Institucion.fromJson(data['institucion']);
        instituciones.add(objectInstitucion);
      });

      objectUser = Usuario(jsonUser['id'], jsonUser['name'], jsonUser['apellido'], jsonUser['email'], jsonUser['role_id'], instituciones);

      jsonInasistencias.forEach((data){
        Institucion objectInstitucion = instituciones.singleWhere((i) => (i.id == data['institucion_id']));
        Inasistencia objectInasistencia = Inasistencia(data['id'], data['fecha'], data['ubicacion'], data['archivo'], data['estado'], objectInstitucion);
        setState(() {
          consultas.add(objectInasistencia);
        });
      });
    }else{
      bool login = await SessionManager.getLogin();
      if(!login){
        Navigator.pushNamedAndRemoveUntil(
            context, Login.id, ModalRoute.withName(Login.id));
      }else{
        //log('el error se genera igual');
        _showMyDialog('A ocurrido un error inesperado.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio"),
        //centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: ListView.builder(itemCount: consultas.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      //click en cada elemento
                    },
                    title: Text(consultas[index].institucion.nombre),
                    subtitle: Text('Servicio: '+ 'var1'+'\n'+
                        'var2'+'\n'+
                        'Estado: '+consultas[index].estado
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          _alertCondicional('Confirma que desea cancelar está consulta?',consultas[index].id);
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                          icon: const Icon(Icons.video_call),
                          iconSize: 40.0,
                          color: (consultas[index].estado == "Disponible") ? Colors.green : Colors.white,
                          onPressed: () {
                            if(consultas[index].estado == "Disponible"){
                              log("unirse a la video ${consultas[index].id}");
                              /*
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Teleconsulta(id : consultas[index].id))
                              );
                              */
                            }
                          }
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(40.0, 10.0, 30.0, 10.0),
        //padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
                iconSize: 40.0,
                icon: const Icon(Icons.add_box_rounded),
                color: Colors.purple,
                onPressed: () {
                  _navigateNuevaInasistencia();
                }
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atención'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _navigateNuevaInasistencia() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NuevaInasistencia(user : objectUser)),
    );
    if(result != null) {
      if (result == 'true') {
        _check();
      }else{
        Navigator.pushNamedAndRemoveUntil(
            context, Login.id, ModalRoute.withName(Login.id));
      }
    }
  }

  Future<void> _alertCondicional(String message,int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atención'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: (){
                Navigator.pop(context);
                _cancelInasistencia(id);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelInasistencia(int id) async {
    InasistenciaService inasistenciaService = InasistenciaService();
    var data = await inasistenciaService.cancel(id);
    if(data['status'] == true) {
      _check();
    }else{
      if(data['code'] == 401){
        Navigator.pushNamedAndRemoveUntil(
            context, Login.id, ModalRoute.withName(Login.id));
      }else{
        _showMyDialog(data['message']);
      }
    }
  }
}
