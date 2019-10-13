import 'package:fadzmaq/controllers/postAsync.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;


void deleteUser(BuildContext context) async {
  http.Response response = await postAsync(context, "account", useDelete: true);

  // Our account on the server has been deleted
  if (response != null && response.statusCode == 200) {
    GoogleSignIn googleSignIn = GoogleSignIn();

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();

    user.delete();
    googleSignIn.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
