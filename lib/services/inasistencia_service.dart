import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ocupacional/models/session_manager.dart';
import 'package:http/http.dart' as http;

class InasistenciaService{

  Future<dynamic> create(int institucion_id, String fecha, String ubicacion, String archivo) async {
    final Map<String, dynamic> errorJson = new Map<String, dynamic>();

    try {
      var url = Uri.parse('http://181.15.198.183/api/v2/consulta/store');
      String token = await SessionManager.getToken();
      var response = await http.post(url, headers: {HttpHeaders.authorizationHeader: 'Bearer '+ token,}, body: {
        'fecha' : fecha,
        'ubicacion' : ubicacion,
        'institucion_id' : institucion_id.toString(),
        'archivo' : archivo
      });
      switch (response.statusCode) {
        case 200:
        //return 200;
          var responseJson = json.decode(response.body);
          return responseJson;
        case 401:
        //return 401;
          SessionManager.setLogin(false);
          SessionManager.setToken("");

          errorJson['status'] = false;
          errorJson['code'] = 401;
          errorJson['message'] = 'El tiempo expiró, es necesario que inicie sesión nuevamente.';

          return errorJson;
        default:
        //return 500;
          errorJson['status'] = false;
          errorJson['code'] = 500;
          errorJson['message'] = 'Error, comuniquese con el administrador.';
          return errorJson;
      }
    } on SocketException {
      //return 500;
      errorJson['status'] = false;
      errorJson['code'] = 500;
      errorJson['message'] = 'Error, comuniquese con el administrador.';
      return errorJson;
    }
  }

  Future<dynamic> cancel(int inasistencia_id) async {
    final Map<String, dynamic> errorJson = new Map<String, dynamic>();

    try {
      var url = Uri.parse('http://181.15.198.183/api/consulta/cancel');
      String token = await SessionManager.getToken();
      var response = await http.post(url, headers: {HttpHeaders.authorizationHeader: 'Bearer '+ token,}, body: {
        'id' : inasistencia_id.toString()
      });
      switch (response.statusCode) {
        case 200:
          var responseJson = json.decode(response.body);
          return responseJson;
        case 401:
          SessionManager.setLogin(false);
          SessionManager.setToken("");

          errorJson['status'] = false;
          errorJson['code'] = 401;
          errorJson['message'] = 'El tiempo expiró, es necesario que inicie sesión nuevamente.';

          return errorJson;
        case 403:
          errorJson['status'] = false;
          errorJson['code'] = 403;
          errorJson['message'] = 'No es posible cancelar esta consulta.';
          return errorJson;
        default:
          errorJson['status'] = false;
          errorJson['code'] = 500;
          errorJson['message'] = 'Error, comuniquese con el administrador.';
          return errorJson;
      }
    } on SocketException {
      errorJson['status'] = false;
      errorJson['code'] = 500;
      errorJson['message'] = 'Error, comuniquese con el administrador.';
      return errorJson;
    }
  }

  Future<dynamic> show(int inasistencia_id) async {
    final Map<String, dynamic> errorJson = new Map<String, dynamic>();

    try {
      var url = Uri.parse('http://181.15.198.183/api/conectar');
      String token = await SessionManager.getToken();
      var response = await http.post(url, headers: {HttpHeaders.authorizationHeader: 'Bearer '+ token,}, body: {
        'consulta_id' : inasistencia_id.toString()
      });
      switch (response.statusCode) {
        case 200:
          var responseJson = json.decode(response.body);
          return responseJson;
        case 401:
          SessionManager.setLogin(false);
          SessionManager.setToken("");

          errorJson['status'] = false;
          errorJson['code'] = 401;
          errorJson['message'] = 'El tiempo expiró, es necesario que inicie sesión nuevamente.';

          return errorJson;
        default:
          errorJson['status'] = false;
          errorJson['code'] = 500;
          errorJson['message'] = 'Error, comuniquese con el administrador.';
          return errorJson;
      }
    } on SocketException {
      errorJson['status'] = false;
      errorJson['code'] = 500;
      errorJson['message'] = 'Error, comuniquese con el administrador.';
      return errorJson;
    }
  }

  Future<dynamic> list() async {
    final Map<String, dynamic> errorJson = new Map<String, dynamic>();

    try {
      var url = Uri.parse('http://181.15.198.183/api/consultas/cerradas/list');
      String token = await SessionManager.getToken();
      var response = await http.post(url, headers: {HttpHeaders.authorizationHeader: 'Bearer '+ token,});
      switch (response.statusCode) {
        case 200:
          var responseJson = json.decode(response.body);
          return responseJson;
        case 401:
          SessionManager.setLogin(false);
          SessionManager.setToken("");

          errorJson['status'] = false;
          errorJson['code'] = 401;
          errorJson['message'] = 'El tiempo expiró, es necesario que inicie sesión nuevamente.';

          return errorJson;
        default:
          errorJson['status'] = false;
          errorJson['code'] = 500;
          errorJson['message'] = 'Error, comuniquese con el administrador.';
          return errorJson;
      }
    } on SocketException {
      errorJson['status'] = false;
      errorJson['code'] = 500;
      errorJson['message'] = 'Error, comuniquese con el administrador.';
      return errorJson;
    }
  }
}