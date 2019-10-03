import 'package:fadzmaq/views/createprofilescreen.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/views/splashscreen.dart';
import 'package:fadzmaq/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/views/preferences.dart';


// void main() {
//   runApp(App());
// }

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: HomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => SplashScreen(),
        '/preferences': (context) => UserPreferencesPage(),

        // When navigating to the "/second" route, build the SecondScreen widget.
        '/login': (context) => LoginScreen(),
        '/CreateProfile': (context) => CreateProfileScreen(),
        // '/profile': (context) => LoginScreen(),
      },
    );
  }
}