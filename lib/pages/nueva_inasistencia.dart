
import 'package:flutter/material.dart';
import 'package:ocupacional/models/usuario.dart';
import 'package:ocupacional/services/inasistencia_service.dart';

class Item {
  Item({
    required this.index,
    required this.header,
    required this.description,
    this.isExpanded = false,
  });

  int index;
  String header;
  String description;
  bool isExpanded;
}

class NuevaInasistencia extends StatefulWidget {
  final Usuario user;
  const NuevaInasistencia({Key? key, required this.user}) : super(key: key);

  @override
  _NuevaInasistenciaState createState() => _NuevaInasistenciaState();
}

class _NuevaInasistenciaState extends State<NuevaInasistencia> {
  final _formKeyNewQuery = GlobalKey<FormState>();
  String _comentario = '';

  //Usuario user;
  //_NuevaConsultaState(this.user);

  @override
  Widget build(BuildContext context) {
    //widget.user
    return Scaffold(
      appBar: AppBar(
        title: Text("Nueva Licencia"),
        //centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKeyNewQuery,
              child: Column(
                children: <Widget>[
                  _buildPanel(),
                  SizedBox(height: 15.0,),
                  _buttonQuery(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      //children:
    );
  }


  Widget _comentarioTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Comentario sobre otros síntomas',
        ),
        onChanged: (value){
          _comentario = value;
        },
      ),
    );
  }

  Widget _buttonQuery() {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 15.0),
        child: Text('Generar consulta',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () {
        if(2000 == 2000){
          //log('no enviar post');
          _alertDialog('Debe seleccionar uno de los servicios listados en dicha sección.');
        }else{
          _saveQuery();
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10.0,
      color: Colors.purple,
    );
  }



  void _saveQuery() async {
    InasistenciaService inasistenciaService = InasistenciaService();
    var data = await inasistenciaService.create(widget.user.instituciones[0].id,'','','');
    if(data['status'] == true) {
      Navigator.pop(context,'true');
    }else{
      if(data['code'] == 500){
        _alertDialog(data['message']);
      }else{
        _alertDialog(data['message']);
        Navigator.pop(context,'false');
      }
    }
  }

  Future<void> _alertDialog(String message) async {
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
          ],
        );
      },
    );
  }
}
