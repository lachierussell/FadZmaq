import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/views/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/views/homepage_rupert.dart';

import 'main.dart';
import 'views/homepage.dart';
import 'views/loginpage_rupert.dart';
import 'views/profilepage.dart';
import 'views/editprofilepage.dart';

Widget _defaultHome = new LoginPageRupert();

class AppRupert extends StatelessWidget {
  // an explicit initialization method to set a default home and processes the
  // async function authentication.login
  AppRupert();
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
          
          '/home': (BuildContext context) => new HomePageRupert(title: "Home"),
          '/login': (BuildContext context) => new LoginPageRupert(),
          '/profilepage': (BuildContext context) => new ProfilePage(),
          '/editprofilepage': (BuildContext context) => new EditProfilePage()
        }
    );
  }
}


