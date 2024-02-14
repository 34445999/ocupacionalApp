import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ocupacional/models/session_manager.dart';
import 'package:http/http.dart' as http;

class InasistenciaService{

  Future<dynamic> createConsulta(List<Sintoma> sintomas, int institucion_id, String comentario, List<Estudio> estudios, int servicio_id) async {
    final Map<String, dynamic> errorJson = new Map<String, dynamic>();

    try {
      var url = Uri.parse('https://simed.med.unne.edu.ar/api/v2/consulta/store');
      String token = await SessionManager.getToken();
      String jsonSintomas = jsonEncode(sintomas);
      String jsonEstudios = jsonEncode(estudios);
      var response = await http.post(url, headers: {HttpHeaders.authorizationHeader: 'Bearer '+ token,}, body: {
        'sintomas' : jsonSintomas,
        'comentario' : comentario,
        'institucion_id' : institucion_id.toString(),
        'servicio_id' : servicio_id.toString(),
        'estudios' : jsonEstudios
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

  Future<dynamic> cancelConsulta(int consulta_id) async {
    final Map<String, dynamic> errorJson = new Map<String, dynamic>();

    try {
      var url = Uri.parse('https://simed.med.unne.edu.ar/api/consulta/cancel');
      String token = await SessionManager.getToken();
      var response = await http.post(url, headers: {HttpHeaders.authorizationHeader: 'Bearer '+ token,}, body: {
        'id' : consulta_id.toString()
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

  Future<dynamic> credentialsConsulta(int consulta_id) async {
    final Map<String, dynamic> errorJson = new Map<String, dynamic>();

    try {
      var url = Uri.parse('https://simed.med.unne.edu.ar/api/conectar');
      String token = await SessionManager.getToken();
      var response = await http.post(url, headers: {HttpHeaders.authorizationHeader: 'Bearer '+ token,}, body: {
        'consulta_id' : consulta_id.toString()
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

  Future<dynamic> listConsulta() async {
    final Map<String, dynamic> errorJson = new Map<String, dynamic>();

    try {
      var url = Uri.parse('https://simed.med.unne.edu.ar/api/consultas/cerradas/list');
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