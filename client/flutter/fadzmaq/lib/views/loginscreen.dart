import 'package:fadzmaq/views/splashscreen.dart';
import 'package:fadzmaq/views/widgets/roundButton.dart';
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

  bool _isButtonDisabled = false;

  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {}
    });
    _googleSignIn.signInSilently().whenComplete(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Center(child: Icon(Icons.account_box, size: 130)),
            SizedBox(height: 30),
            Center(
              child: RoundButton(
                  minWidth: 220,
                  height: 50,
                  fontSize: 18,
                  label: "Login With Google",
                  onPressed: _isButtonDisabled
                      ? null
                      : () async {
                          // Disable button while logging in
                          setState(() {
                            _isButtonDisabled = true;
                          });

                          FirebaseUser user = await _handleSignIn();

                          // Unsuccessful ungrey button
                          if (user == null) {
                            setState(() {
                              _isButtonDisabled = false;
                            });
                          }
                          // Success move to splash screen
                          else {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SplashScreen()),
                            );
                          }
                          return;
                        }),
            ),
          ],
        ),
      ),
    ));
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    if (googleAuth == null) return null;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    if (credential == null) return null;

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    return user;
  }
}
