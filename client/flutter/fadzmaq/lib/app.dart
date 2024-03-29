import 'package:fadzmaq/models/globalModel.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/views/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/views/preferences.dart';
import 'package:fadzmaq/controllers/globalData.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlobalData(
      container: GlobalModelContainer(),
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
          // '/profile': (context) => LoginScreen(),
        },
      ),
    );
  }
}
