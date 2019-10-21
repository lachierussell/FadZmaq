import 'package:fadzmaq/controllers/postAsync.dart';
import 'package:fadzmaq/models/globalModel.dart';
import 'package:fadzmaq/views/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

void logOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  _googleSignIn.signOut();
  cleanModel(context);

  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
}

void deleteUser(BuildContext context) async {
  http.Response response = await postAsync(context, "account", useDelete: true);

  // Our account on the server has been deleted
  if (response != null && response.statusCode == 204) {
    // Deleting a firebase account is not currently supported by flutter
    // uncomment the below when a patch is available
    // https://github.com/flutter/flutter/issues/37681

    GoogleSignIn googleSignIn = GoogleSignIn();

    // FirebaseAuth auth = FirebaseAuth.instance;
    // FirebaseUser user = await auth.currentUser();

    // GoogleSignInAccount googleUser = googleSignIn.currentUser;
    // if (googleUser == null) googleUser = await googleSignIn.signInSilently();
    // if (googleUser == null) googleUser = await googleSignIn.signIn();
    // if (googleUser == null) {
    //   print("googleUser null");
    //   return;
    // }

    // final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // final AuthCredential credential = GoogleAuthProvider.getCredential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );

    // await user.reauthenticateWithCredential(credential);

    // await user.delete();
    await googleSignIn.signOut();

    cleanModel(context);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
