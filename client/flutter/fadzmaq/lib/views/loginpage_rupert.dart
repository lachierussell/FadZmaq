import 'package:fadzmaq/main.dart';
import 'package:flutter/material.dart';

class LoginPageRupert extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageRupertState();
}

class _LoginPageRupertState extends State<LoginPageRupert> {
  String _status = 'no-action';

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text('Login'),
    ),
    body: new Container(
      child: new Center(
        child: new RaisedButton(
            child: new Text(
                'Login for App (${this._status})'
            ),
            onPressed: () {
              setState(() => this._status = 'loading');

              appAuth.login().then((result) {
                if (result) {
                  Navigator.of(context).pushReplacementNamed('/home');
                } else {
                  setState(() => this._status = 'rejected');
                }
              });
            }
        ),
      ),
    ),
  );
}