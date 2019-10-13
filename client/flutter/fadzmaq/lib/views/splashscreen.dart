import 'package:fadzmaq/controllers/cache.dart';
import 'package:fadzmaq/views/landing.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fadzmaq/controllers/request.dart';
import 'dart:convert';
import 'package:fadzmaq/models/app_config.dart';
import 'package:location/location.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // var token = await user.getIdToken();
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

      // var token = await user.getIdToken();
      // printWrapped(token.token);
      httpPost(AppConfig.of(context).server + "profile/ping",
          json: utf8.encode(json.encode(compileJson(currentLocation))));
      // String url = "matches";
      // int code =
      //     await fetchResponseCode(config.server + url);

      // TODO this should all be put after the login screen
      await cacheImages(context);

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

  Map compileJson(LocationData locationData) {
    String lat = locationData.latitude.toStringAsFixed(2);
    String long = locationData.longitude.toStringAsFixed(2);

    Map map = {
      'location': {
        'lat': lat,
        "long": long,
      }
    };
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
