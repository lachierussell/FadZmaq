import 'package:fadzmaq/controllers/globalData.dart';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/views/landing.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        await firstLoadGlobalModels(context);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            // builder: (context) => UserPreferencesPage(),
            builder: (context) => LandingPage(),
          ),
        );
      }
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
