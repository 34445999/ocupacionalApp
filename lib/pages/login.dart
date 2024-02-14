import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ocupacional/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';


class Login extends StatefulWidget {
  static String id = 'login';
  //const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKeyLogin = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        body: Center(
          child: Form(
            key: _formKeyLogin,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Image.asset('images/LinkMed.png',
                    height: 250.0,
                  ),
                ),
                SizedBox(height: 15.0,),
                _userTextField(),
                SizedBox(height: 15.0,),
                _passwordTextField(),
                SizedBox(height: 20.0,),
                _bottonLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _userTextField() {
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'ejemplo@correo.com',
                labelText: 'correo electronico',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese su correo electronico';
                }
                return null;
              },
              onChanged: (value){
                _username = value;
              },
            ),
          );
        }
    );
  }

  Widget _passwordTextField(){
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                hintText: 'Contraseña',
                labelText: 'Contraseña',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese su contraseña';
                }
                return null;
              },
              onChanged: (value){
                _password = value;
              },
            ),
          );
        }
    );
  }

  Widget _bottonLogin(){
    return StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return RaisedButton(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                child: Text('Iniciar Sesion',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 10.0,
              color: Colors.amber,
              onPressed: (){
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKeyLogin.currentState!.validate()) {
                  _authenticate();
                }
              }
          );
        }
    );
  }

  void _authenticate() async{
    final form = _formKeyLogin.currentState;
    //String token = await SessionManager.getToken();
    //log(token);
    if (form!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Procesando la información')),
      );
      AuthService authService = AuthService();
      int verificar = await authService.authenticateUser(_username, _password);
      switch (verificar) {
        case 200:
          Navigator.pushNamedAndRemoveUntil(
              context, Home.id, ModalRoute.withName(Home.id));
          break;
        case 401:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciales incorrecta')),
          );
          break;
        case 500:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error:Comuniquese con el administrador.')),
          );
          break;
      }
    } else {
      form.save();
    }
  }
}


