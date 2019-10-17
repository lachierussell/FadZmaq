import 'dart:async';
import 'dart:io';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

// this has to be a typeless future to pass errors
Future httpPost(String url, {var json}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = await auth.currentUser();
  IdTokenResult result = await user.getIdToken();

  try {
    if (json != null)
      return await http.post(url,
          headers: {"Authorization": result.token}, body: json);
    else
      return await http.post(url, headers: {"Authorization": result.token});
  } catch (e) {
    return e;
  }
}

/// returns a [http.Response] for a given [url]
/// async operation which includes authorisation headers for
/// the current user
/// this has to be a typeless future to pass errors
Future httpGet(String url, {var json}) async {
  //json not used in get request, is there to interchange with post request
  // TODO really these could be merged

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = await auth.currentUser();

  if (user == null) {
    throw Exception("User not logged in");
  }

  IdTokenResult result = await user.getIdToken();

  http.Response response;
  try {
    response = await http.get(
      url,
      headers: {"Authorization": result.token},
    );
  } on Exception catch (e) {
    throw e;
  }

  return response;
}

// this has to be a typeless future to pass errors
Future httpDelete(String url, {var json}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = await auth.currentUser();
  IdTokenResult result = await user.getIdToken();

  try {
    return await http.delete(url, headers: {"Authorization": result.token});
  } catch (e) {
    return e;
  }
}

enum RestType { get, post, delete }

Future _httpHandler(
  String url, {
  var json,
}) {}
