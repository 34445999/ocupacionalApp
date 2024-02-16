
import 'institucion.dart';

class Inasistencia{
  int _id;
  String _fecha;
  String _ubicacion;
  String _archivo;
  String _estado;
  Institucion _institucion;

  Inasistencia(this._id,this._fecha,this._ubicacion,this._archivo,this._estado,this._institucion);

  int get id => _id;
  set id(int id) => _id = id;

  String get fecha => _fecha;
  set fecha(String fecha) => _fecha = fecha;

  String get ubicacion => _ubicacion;
  set ubicacion(String ubicacion) => _ubicacion = ubicacion;

  String get archivo => _archivo;
  set archivo(String archivo) => _archivo = archivo;

  String get estado => _estado;
  set estado(String estado) => _estado = estado;

  Institucion get institucion => _institucion;
  set institucion(Institucion institucion) => _institucion = institucion;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['fecha'] = fecha;
    data['ubicacion'] = ubicacion;
    data['archivo'] = archivo;
    return data;
  }
}