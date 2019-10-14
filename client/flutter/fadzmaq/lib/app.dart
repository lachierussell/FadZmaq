import 'package:fadzmaq/models/mainModel.dart';
import 'package:fadzmaq/views/createprofilescreen.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/views/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/views/preferences.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DataController(
      model: MainModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/preferences': (context) => UserPreferencesPage(),
          '/login': (context) => LoginScreen(),
          '/CreateProfile': (context) => CreateProfileScreen(),
          // '/profile': (context) => LoginScreen(),
        },
      ),
    );
  }
}
