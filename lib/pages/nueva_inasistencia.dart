
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
  final List<Item> _data = [Item(index: 0,header: 'Síntomas', description: 'La selección de uno o mas síntomas es opcional.'),Item(index: 1,header: 'Servicios', description: 'Seleccioné uno de los servicios de salud ofrecidos por la institución.'),Item(index: 2,header: 'Estudios y/o exámenes médicos', description: 'La selección es opcional. Para que un nuevo archivo se lista deberá ser cargado previamente.')];

  //Usuario user;
  //_NuevaConsultaState(this.user);

  @override
  Widget build(BuildContext context) {
    //widget.user
    return Scaffold(
      appBar: AppBar(
        title: Text("Nueva consulta"),
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
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.header,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(item.description),
            );
          },
          body: _contenido(item.index),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  Widget _checkServicios() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.user.instituciones[0].servicios.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          //title: Text('Gujarat, India'),
          title: Text(widget.user.instituciones[0].servicios[index].descripcion),
          leading: Radio<Servicio>(
            value: widget.user.instituciones[0].servicios[index],
            groupValue: _selectService,
            onChanged: (value) {
              setState(() {
                _selectService = value!;
                //log('servicio seleccionado ${_selectService.id}');
              });
            },
          ),
        );
      },
    );
  }

  Widget _checkSintomas() {
    return Column(
      children: [
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              //title: Text('Gujarat, India'),
              title: Text(widget.user.instituciones[0].sintomas[index].nombre),
              value: widget.user.instituciones[0].sintomas[index].selected,
              onChanged: (bool? value) {
                setState(() {
                  widget.user.instituciones[0].sintomas[index].selected = !widget.user.instituciones[0].sintomas[index].selected;
                });
              } ,
            );
          },
        ),
        _comentarioTextField(),
      ],
    );
  }

  Widget _checkEstudios() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.user.estudios.length,
      itemBuilder: (BuildContext context, int index) {
        return CheckboxListTile(
          //title: Text('Gujarat, India'),
          title: Text(widget.user.estudios[index].archivo),
          value: widget.user.estudios[index].selected,
          onChanged: (bool? value) {
            setState(() {
              widget.user.estudios[index].selected = !widget.user.estudios[index].selected;
            });
          } ,
        );
      },
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
        if(_selectService.id == 2000){
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

  Widget _contenido(int index) {
    switch (index) {
      case 0:
        return _checkSintomas();
      case 1:
        return _checkServicios();
      case 2:
        return _checkEstudios();
      default:
        return Text('Erro al intentar recuperar los datos',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        );
    }
  }

  void _saveQuery() async {
    ConsultaService consultaService = ConsultaService();
    var data = await consultaService.createConsulta(widget.user.instituciones[0].sintomas,widget.user.instituciones[0].id,_comentario,widget.user.estudios,_selectService.id);
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
