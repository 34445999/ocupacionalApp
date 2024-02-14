import 'package:teleconsultorio/models/servicio.dart';
import 'package:teleconsultorio/models/sintoma.dart';

class Institucion{
  int _id;
  String _nombre;
  bool _publico;

  Institucion(this._id,this._nombre,this._publico);

  int get id => _id;
  set id(int id) => _id = id;

  String get nombre => _nombre;
  set nombre(String nombre) => _nombre = nombre;

  bool get publico => _publico;
  set publico(bool publico) => _publico = publico;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['nombre'] = nombre;
    data['publico'] = publico;
    return data;
  }
}
