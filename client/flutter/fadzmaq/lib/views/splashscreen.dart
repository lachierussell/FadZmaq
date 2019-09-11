import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/views/homepage.dart';
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage(title: 'Flutter Demo Home Page')));
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
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

