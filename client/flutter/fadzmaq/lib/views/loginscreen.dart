import 'package:fadzmaq/models/app_config.dart';
import 'package:fadzmaq/views/editprofilepage.dart';
import 'package:fadzmaq/views/landing.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:fadzmaq/controllers/request.dart';

import 'package:http/http.dart' as http;

import 'createprofilescreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isButtonDisabled = false;

  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();

    _signout();
    

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        //
      }
    });
    _googleSignIn.signInSilently().whenComplete(() => {
          //
        });
  }


  Future<FirebaseUser> _handleSignIn() async {
    setState(() {
      _isButtonDisabled = true;
    });

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    var token = await user.getIdToken();
    // print("\nidToken: \"" + token.toString() + "\"\n");
    // debugPrint("token: \"" + token.token + "\"");
    printWrapped(token.token);
    // print("signed in " + user.displayName + "\n");
    return user;
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void _signout() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    ConfigResource config = AppConfig.of(context);

    return Scaffold(
        // backgroundColor: Theme.of(context).accentColor,
        // appBar: AppBar(
        //   title: Text("Login"),
        // ),
        body: Center(
      child: Container(
        alignment: Alignment.bottomCenter,
        constraints: BoxConstraints(
            maxHeight: 300.0,
            maxWidth: 200.0,
            minWidth: 150.0,
            minHeight: 150.0),
        child: ListView(
          children: <Widget>[
            Center(
              child: Icon(
                Icons.account_box,
                size: 130,
              ),
            ),
            Center(
              child: _isButtonDisabled
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      child: (Text("Login With Google")),
                      onPressed: () async {
                        // _handleSignIn().then((FirebaseUser user) {
                        // print(user);

                        // TODO add a future builder in here so we show a loading circle during log in

                        FirebaseUser user = await _handleSignIn();
                        // await sleep1();

                        if (user != null) {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          FirebaseUser user = await auth.currentUser();
                          IdTokenResult result = await user.getIdToken();

                          // a quick check to the server to see if we have an account already
                          // fetch response code will use Firebase Authentication to send our token
                          String url = "matches";
                          // TODO check for timeout here
                          http.Response response = await httpGet(config.server + url);
                          int code = response.statusCode;

                          String resonse = response.body.toString();

                          print("A " + '$code' + " " + '$resonse');

                          // 401: no user account
                          if (code == 404) {
                            // TODO make this better, its a bit of a hack at the moment

                            // Get our id token from firebase
                            FirebaseAuth auth = FirebaseAuth.instance;
                            FirebaseUser user = await auth.currentUser();
                            
                            var names = user.displayName.split(" ");
                            String name = names[0];

                            // put together our post request for a new account
                            String _json = '{"new_user":{"email":"' +
                                user.email +
                                '", "name":"' +
                                name +
                                '"}}';

                            // print(json);
                            // post to account with our auth
                            http.Response response = await httpPost(
                              config.server + "account",json:_json
                            );

                            // update our code
                            code = response.statusCode;

                            String resonsee = response.body.toString();

                            print("B " + '$code' + " " + '$resonsee');

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                // builder: (context) => UserPreferencesPage(),
                                builder: (context) => LandingPage(),
                              ),
                            );
                          }

                          // success with the server
                          // go to main page (perferences at the moment)
                          if (code == 200) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                // builder: (context) => UserPreferencesPage(),
                                builder: (context) => LandingPage(),
                              ),
                            );
                          }

                          // TODO error check here
                        }
                        // }).catchError((e) => print(e));
                      }),
            ),
          ],
        ),
      ),
    ));
  }

  // TODO remove me
  Future sleep1() {
    return new Future.delayed(const Duration(seconds: 2), () => "2");
  }
}
