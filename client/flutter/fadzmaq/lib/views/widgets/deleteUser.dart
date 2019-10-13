import 'package:fadzmaq/controllers/postAsync.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

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

  final GoogleSignInAuthentication googleAuth =
      await _googleSignIn.currentUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  try {
    await user.reauthenticateWithCredential(credential);
  } catch (e) {
    return;
  }

  http.Response response = await postAsync(context, "acount", useDelete: true);

  // Our account on the server has been deleted
  if (response.statusCode == 200) {
    user.delete();
    _googleSignIn.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
