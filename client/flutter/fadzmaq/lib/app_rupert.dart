import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/views/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/views/homepage_rupert.dart';

import 'main.dart';
import 'views/homepage.dart';

import 'views/profilepage.dart';
import 'views/editprofilepage.dart';


class AppRupert extends StatelessWidget {
  // an explicit initialization method to set a default home and processes the
  // async function authentication.login
  AppRupert();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'App',
        home: HomePageRupert(title: "Home"),
        routes: <String, WidgetBuilder>{
          // Set routes for using the Navigator.
          
          '/home': (BuildContext context) => new HomePageRupert(title: "Home"),
          '/profilepage': (BuildContext context) => new ProfilePage(),
          '/editprofilepage': (BuildContext context) => new EditProfilePage()
        }
    );
  }
}


