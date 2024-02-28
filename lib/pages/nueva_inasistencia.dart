
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ocupacional/models/institucion.dart';
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
  _NuevaInasistenciaState createState() => _NuevaInasistenciaState(user.instituciones);
}

class _NuevaInasistenciaState extends State<NuevaInasistencia> {
  final _formKeyNewQuery = GlobalKey<FormState>();
  bool serviceEnabled = false;
  Institucion _selectedInstitucion = Institucion(0,'Selecione la institución',false);
  List<Institucion> objectInstituciones;

  TextEditingController _fechaController = TextEditingController();
  String _motivos = '';
  int _dias = 1;
  bool _consentimiento = false;
  File? _file = null;
  String _fileName = '';
  String _fileType = '';
  String _ubicacion = '';

  _NuevaInasistenciaState(this.objectInstituciones);

  @override
  void initState(){
    _permissionPosition();
  }

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
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKeyNewQuery,
                child: Column(
                  children: <Widget>[
                    DropdownButtonFormField<Institucion>(
                      value: objectInstituciones[0],
                      onChanged: (value) {
                        setState(() {
                          _selectedInstitucion = value!;
                        });
                      },

                      items: objectInstituciones.map<DropdownMenuItem<Institucion>>((Institucion institucion) {
                        return DropdownMenuItem(
                          value: institucion,
                          child: Text(institucion.nombre),
                        );
                      }).toList(),

                      decoration: InputDecoration(
                        labelText: 'Institución',
                      ),
                    ),

                    SizedBox(height: 20.0),

                    TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el motivo de la Licencia';
                        }
                        return null;
                      },
                      onChanged: (value){
                        setState(() {
                          _motivos = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Motivos',
                      ),
                    ),

                    SizedBox(height: 20.0),

                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Ingrese la fecha de la licencia",
                          icon: Icon(Icons.calendar_today)
                      ),
                      controller: _fechaController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context, initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(DateTime.now().year+1)
                        );
                        if(pickedDate != null ){
                          print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                          //String formattedDate = pickedDate.toString().substring(1,10);
                          print(formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            //_fecha = formattedDate; //set output date to TextField value.
                            _fechaController.text = formattedDate;
                          });
                        }else{
                          print("Seleccioné una fecha");
                        }
                      },
                    ),

                    SizedBox(height: 20.0),

                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor la cantidad de días';
                        }
                        return null;
                      },
                      onChanged: (value){
                        setState(() {
                          _dias = value as int;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Días',
                      ),
                    ),

                    SizedBox(height: 30.0),

                    TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: (_fileName.isNotEmpty) ? TextStyle(color: Colors.green) : TextStyle(color: Colors.blue),
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
                        shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      onPressed: () {
                        _uploadFile();
                      },
                      icon: Icon(Icons.upload_file,),
                      label: Text('Subir comprobante'),
                    ),
                    Text((_fileName.isNotEmpty) ? _fileName : '', textAlign: TextAlign.center),

                    SizedBox(height: 25.0),

                    CheckboxListTile(
                      title: Text('Confirmo el pedido de licencia'),
                      value: _consentimiento,
                      onChanged: (value) {
                        setState(() {
                          _consentimiento = value!;
                        });
                      },
                    ),

                    SizedBox(height: 20.0),

                    _buttonQuery(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _uploadFile() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png','jpg', 'pdf'],
    );

    if (result != null) {

      PlatformFile file = result.files.first;
      String? path = file.path;
      setState(() {
        _file = File(path!);
        _fileName = file.name;
        _fileType = file.extension!;
      });
      /*
      EstudioService estudioService = EstudioService();
      var data = await estudioService.uploadFile(_file!,_name,_type);

      if(data['status'] == true) {
        Estudio obj = Estudio.fromJson(data['estudio']);
        setState(() {
          objectEstudios.add(obj);
        });
      }else{
        if(data['code'] == 401){
          Navigator.pop(context,'false');
        }else{
          _alertDialog(data['message']);
        }
      }
      */
    }
  }

  Widget _buttonQuery() {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 15.0),
        child: Text('ENVIAR SOLICITUD',
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

  Future<void> _permissionPosition() async {
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled(); //isLocationServiceEnabled()
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _alertDialog('El servicio de localización esta desactivado.');
      //return Future.error('Location services are disabled.');
      //return serviceEnabled;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _alertDialog('El permiso de localización fue denegado.');
        //return Future.error('Location permissions are denied');
        //return serviceEnabled;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      //return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      _alertDialog("Los permisos de ubicación están denegados permanentemente, no podemos solicitar permisos.");
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    //return await Geolocator.getCurrentPosition();
    setState(() {
      serviceEnabled = true;
    });
    //return serviceEnabled;
  }
}
