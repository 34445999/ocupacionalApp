import 'package:ocupacional/models/institucion.dart';

class Usuario{
  int _id;
  String _name;
  String _apellido;
  String _email;
  int _role;
  List<Institucion> _instituciones;
  Usuario(this._id,this._name,this._apellido,this._email,this._role,this._instituciones);

  int get id => _id;
  set id(int id) => _id = id;

  String get name => _name;
  set name(String name) => _name = name;

  String get apellido => _apellido;
  set apellido(String apellido) => _apellido = apellido;

  String get email => _email;
  set email(String email) => _email = email;

  int get role => _role;
  set role(int role) => _role = role;

  List<Institucion> get instituciones => _instituciones;
  set instituciones(List<Institucion> instituciones) => _instituciones = instituciones;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['apellido'] = apellido;
    data['email'] = email;
    data['role'] = role;
    return data;
  }
}