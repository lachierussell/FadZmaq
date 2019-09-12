import 'package:fadzmaq/models/app_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:fadzmaq/views/preferences.dart';
import 'package:fadzmaq/controllers/request.dart';

import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        // Navigator.pushNamed(context, "/UwaAll");
      }
    });
    _googleSignIn.signInSilently().whenComplete(() => {
          // Navigator.pushNamed(context, "/UwaAll")
        });
  }

  Future<FirebaseUser> _handleSignIn() async {
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

  @override
  Widget build(BuildContext context) {
    ConfigResource config = AppConfig.of(context);

    return Scaffold(
        backgroundColor: Colors.orangeAccent,
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
                  child: RaisedButton(
                      child: (Text("Login With Google")),
                      onPressed: () async {
                        // _handleSignIn().then((FirebaseUser user) {
                        // print(user);
                        FirebaseUser user = await _handleSignIn();
                        await sleep1();
                        if (user != null) {
                          String url = "matches";
                          int code =
                              await fetchResponseCode(config.server + url);

                          if (code == 401) {
                            // TODO make this better, its a bit of a hack at the moment

                            FirebaseAuth auth = FirebaseAuth.instance;
                            FirebaseUser user = await auth.currentUser();
                            IdTokenResult result = await user.getIdToken();

                            String json =
                                '{"new_user":{"email":"lachie@gmail-com", "name":"lachie"}}';
                            http.Response response = await http.post(
                              config.server + "account",
                              headers: {"Authorization": result.token},
                              body: json,
                            );

                            code = response.statusCode;
                          }

                          if (code == 200) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserPreferencesPage()));
                          }
                        }
                        // }).catchError((e) => print(e));
                      }),
                ),
              ],
            ),
          ),
        ));
  }

  Future sleep1() {
    return new Future.delayed(const Duration(seconds: 2), () => "2");
  }
}
