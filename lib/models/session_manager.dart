import 'package:shared_preferences/shared_preferences.dart';

class SessionManager{

  static setLogin(bool login) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('KEY_LOGIN', login);
  }

  static Future<bool> getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool res = await prefs.getBool('KEY_LOGIN') ?? false;
    return res;
  }

  static setEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('KEY_EMAIL', email);
  }

  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String res = await prefs.getString('KEY_EMAIL') ?? "";
    return res;
  }

  static setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('KEY_TOKEN', token);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String res = prefs.getString('KEY_TOKEN') ?? "";
    return res;
  }

  static setOtherToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('KEY_OTHER_TOKEN', token);
  }

  static Future<String> getOtherToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String res = prefs.getString('KEY_OTHER_TOKEN') ?? "";
    return res;
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("KEY_TOKEN");
    prefs.setBool('KEY_LOGIN', false);
  }
}