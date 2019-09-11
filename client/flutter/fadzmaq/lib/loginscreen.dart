import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

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
                      onPressed: () {
                        _handleSignIn().then((FirebaseUser user) {
                          // print(user);
                        }).catchError((e) => print(e));
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
