
class Inasistencia{
  int _id;
  String _fecha;
  String _ubicacion;
  String _archivo;

  Inasistencia(this._id,this._fecha,this._ubicacion,this._archivo);

  int get id => _id;
  set id(int id) => _id = id;

  String get fecha => _fecha;
  set fecha(String fecha) => _fecha = fecha;

  String get ubicacion => _ubicacion;
  set ubicacion(String ubicacion) => _ubicacion = ubicacion;

  String get archivo => _archivo;
  set archivo(String archivo) => _archivo = archivo;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['fecha'] = fecha;
    data['ubicacion'] = ubicacion;
    data['archivo'] = archivo;
    return data;
  }
}