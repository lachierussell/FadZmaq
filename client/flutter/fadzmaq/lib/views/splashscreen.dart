import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/views/preferences.dart';
import 'package:fadzmaq/views/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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
    if(user != null){
      // var token = await user.getIdToken();
      // printWrapped(token.token);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserPreferencesPage()));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orangeAccent,
      child: Center(
        child: Icon(
          Icons.swap_horizontal_circle,
          size: 221,
          )
        // child: CircularProgressIndicator(
        //   valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
        // ),
      ),
    );
  }
}

