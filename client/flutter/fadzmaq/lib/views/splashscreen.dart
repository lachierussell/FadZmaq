import 'package:fadzmaq/views/landing.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/views/preferences.dart';
import 'package:fadzmaq/views/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fadzmaq/models/app_config.dart';
import 'package:location/location.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // loadData();
    onDoneLoading();
  }

  // Future<Timer> loadData() async {
  //   return new Timer(Duration(seconds: 3), onDoneLoading);
  // }

  onDoneLoading() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    if (user != null) {

      var location = new Location();
      var currentLocation;
// Platform messages may fail, so we use a try/catch PlatformException.
        currentLocation = await location.getLocation();
        print(currentLocation['latitude']);
      print(currentLocation['longitude']);
       // var token = await user.getIdToken();
      post(AppConfig.of(context).server + "profile/ping", utf8.encode(json.encode(compileJson(_fbKey.currentState.value))));
      // printWrapped(token.token);

      // String url = "matches";
      // int code =
      //     await fetchResponseCode(config.server + url);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          // builder: (context) => UserPreferencesPage(),
          builder: (context) => LandingPage(),
        ),
      );
    } else {
      // TODO try for a silent google sign in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Map compileJson(var x) {
    Map map = {
      'hobbies': [{'container': discoverOrShare() , "hobbies": deriveResult(x) }
      ]};
    print(map);
    return map;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      child: Center(
          child: Icon(
        Icons.swap_horizontal_circle,
        color: Colors.white,
        size: 221,
      )
          // child: CircularProgressIndicator(
          //   valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          // ),
          ),
    );
  }
}
