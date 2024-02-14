import 'package:flutter/material.dart';
import 'package:ocupacional/pages/home.dart';
import 'package:ocupacional/pages/login.dart';

import 'models/session_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Ocupacional',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.blue,
        ),
        //initialRoute: Login.id,
        routes: {
          Home.id : (context) => Home(),
          Login.id : (context) => Login(),
        },
        home: FutureBuilder(
          future: SessionManager.getLogin(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              /*
                return Container(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator()),
                );
                */
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasData) {
                  if(snapshot.data != false){
                    return Home();
                  }else{
                    return Login();
                    //return Text("aca se mostraria el home");
                  }
                  //return (snapshot.data == true)? Login() : Home();
                }
                return Container(); // error view
              default:
                return Container(); // error view
            }
          },
        ));
  }
}
