
import 'institucion.dart';

class Inasistencia{
  int _id;
  String _fecha;
  String _direccion;
  String _ubicacion;
  String _archivo;
  int _dias;
  String _estado;
  String _motivo;
  Institucion _institucion;

  Inasistencia(this._id,this._direccion,this._fecha,this._ubicacion,this._archivo,this._estado,this._dias,this._motivo,this._institucion);

  int get id => _id;
  set id(int id) => _id = id;

  String get fecha => _fecha;
  set fecha(String fecha) => _fecha = fecha;

  String get direccion => _direccion;
  set direccion(String direccion) => _direccion = direccion;

  String get ubicacion => _ubicacion;
  set ubicacion(String ubicacion) => _ubicacion = ubicacion;

  String get archivo => _archivo;
  set archivo(String archivo) => _archivo = archivo;

  int get dias => _dias;
  set dias(int dias) => _dias = dias;

  String get estado => _estado;
  set estado(String estado) => _estado = estado;

  String get motivo => _motivo;
  set motivo(String motivo) => _motivo = motivo;

  Institucion get institucion => _institucion;
  set institucion(Institucion institucion) => _institucion = institucion;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['direccion'] = direccion;
    data['fecha'] = fecha;
    data['ubicacion'] = ubicacion;
    data['archivo'] = archivo;
    data['estado'] = estado;
    data['motivo'] = motivo;
    return data;
  }
}