import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class PreferenceTempApp extends StatelessWidget {
  const PreferenceTempApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const UserPreferencePage(),
    );
  }
}

class UserPreferencePage extends StatelessWidget {
  const UserPreferencePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Preference'),
      ),
      body: GetRequest<ProfileContainer>(
        url: "preference",
        builder: (context) {
          return new UserPreferencePage();
        },
      ),
    );
  }
}

class UserPreference extends StatelessWidget {

  UserPreference({@required this.onPressed});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.red,
      splashColor: Colors.greenAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 20.0,
        ),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.explore,
              color: Colors.green,
            ),
            const SizedBox(width: 8.0),
            const Text(
              "Delete Account",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}