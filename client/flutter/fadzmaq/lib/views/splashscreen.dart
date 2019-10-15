import 'package:fadzmaq/controllers/globalData.dart';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/views/landing.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/views/widgets/localtionPermissionPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

  onDoneLoading() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();

    if (user != null) {
      // TODO refactor this
      ConfigResource config = AppConfig.of(context);
      http.Response response;
      String url = Globals.matchesURL;
      // TODO check for timeout here
      try {
        response = await httpGet(config.server + url);
      } catch (e) {
        print(e.toString());
      }

      int code = 500;
      if (response != null) {
        code = response.statusCode;
      }

      if (code == 401) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            // builder: (context) => UserPreferencesPage(),
            builder: (context) => LoginScreen(),
          ),
        );
      } else {
        //     await fetchResponseCode(config.server + url);
        Location location = new Location();
        // don't request permission here

        bool hasPermission = await location.hasPermission();
        if (hasPermission) {
          LocationData currentLocation = await location.getLocation();

          httpPost(AppConfig.of(context).server + "profile/ping",
              json: utf8.encode(json.encode(compileJson(currentLocation))));
        }

        await firstLoadGlobalModels(context);

        if (hasPermission) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LandingPage()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => PermissionPage()),
          );
        }
      }
    } else {
      // TODO try for a silent google sign in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
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
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.swap_horizontal_circle,
            color: Colors.white,
            size: 221,
          ),
          SizedBox(height: 10),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      )),
    );
  }
}
