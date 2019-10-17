import 'package:fadzmaq/controllers/globalData.dart';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/controllers/location.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/models/globalModel.dart';
import 'package:fadzmaq/views/editprofilepage.dart';
import 'package:fadzmaq/views/errorPage.dart';
import 'package:fadzmaq/views/landing.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:fadzmaq/views/localtionPermissionPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
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
    loadData();
  }

  loadData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();

    // Redirect to login page if no user
    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      return;
    }
    // Make sure we have location permissions
    else {
      if (await Location().hasPermission() == false) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PermissionPage()),
        );
        return;
      }

      // Make sure we have an account
      ConfigResource config = AppConfig.of(context);
      http.Response response;
      String url = Globals.profileURL;
      try {
        response = await httpGet(config.server + url);
      } catch (e) {
        print(e.toString());
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ErrorPage()),
        );
        return;
      }

      int code = 500;
      if (response != null) {
        code = response.statusCode;
      }

      // No account found - create one
      if (code == 404) {
        var names = user.displayName.split(" ");
        String name = names[0];

        // put together our post request for a new account
        String _json = '{"new_user":{"email":"' +
            user.email +
            '", "name":"' +
            name +
            '"}}';

        // post to account with our info
        http.Response response;
        response = await httpPost(config.server + "account", json: _json);

        // update our code
        code = response.statusCode;

        // If a non 2xx response, go to error page
        String codeType = code.toString()[0];
        if (codeType != "2") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ErrorPage()),
          );
          return;
        }

        // go to set up page for a new account
        // load onyl the user model and go to the edit profile page
        // we can still get client errors (usually on an emulator)
        // so still expect problems
        try {
          await sendLocation(context);
          await loadModel(context, Model.userProfile);
          // this is just a push, so we fall out the other side after
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditProfile()),
          );
        } catch (e) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ErrorPage()),
          );
          return;
        }
      }

      // A non 2xx response, go to error page
      String codeType = code.toString()[0];
      if (codeType != "2") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ErrorPage()),
        );
        return;
      }

      // to get here the user will have an account
      // and be succesfully receiving from the server

      // send location ping and load models
      // we can still get client errors (usually on an emulator)
      // so still expect problems
      try {
        await sendLocation(context);
        await firstLoadGlobalModels(context);
      } catch (e) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ErrorPage()),
        );
        return;
      }

      // everything is loaded, continue
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LandingPage()),
      );
    }
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
