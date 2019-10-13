import 'package:fadzmaq/controllers/postAsync.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteButton extends StatelessWidget {
  DeleteButton({@required this.onPressed});

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

void deleteUser(BuildContext context) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  GoogleSignIn _googleSignIn = GoogleSignIn();

  _googleSignIn.signOut();
  if (user == null) {
    throw ('No user');
  } else {
    user.delete().then((result) {
      return true;
    }).catchError((e) {
      return false;
    });
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
