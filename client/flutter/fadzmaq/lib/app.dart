import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/views/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/pages/homepage.dart';

import 'main.dart';
import 'pages/homepage.dart';
import 'pages/loginpage.dart';
import 'pages/profilepage.dart';
import 'pages/editprofilepage.dart';

Widget _defaultHome = new LoginPage();

class App extends StatelessWidget {
  // an explicit initialization method to set a default home and processes the
  // async function authentication.login
  App();
  Future init() async{
    bool _result = await appAuth.login();
    if (_result) {
      _defaultHome = new HomePage();
    }
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'App',
        home: _defaultHome,
        routes: <String, WidgetBuilder>{
          // Set routes for using the Navigator.
          '/home': (BuildContext context) => new HomePage(title: "Home"),
          '/login': (BuildContext context) => new LoginPage(),
          '/profilepage': (BuildContext context) => new ProfilePage(),
          '/editprofilepage': (BuildContext context) => new EditProfilePage()
        }
    );
  }
}


