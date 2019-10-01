import 'package:fadzmaq/controllers/request.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:http/http.dart' as http;

/// Sends a post request to the server
/// Shows snackbar on timeout or errorous status code
///
/// Asynchrounous, does not wait for a response
void postAsync(BuildContext context, String url, {var json}) async {
  url = AppConfig.of(context).server + url;

  httpPost(url).then(( value) {
    errorSnack(context, "snack: " + value.statusCode.toString());
  }).catchError((error) {
    errorSnack(context, "snack: " + error.toString());
  });
}

void errorSnack(BuildContext context, String s) {
  SnackBar snackBar = SnackBar(
    content: Text(s),
    duration: Duration(days: 1),
    action: SnackBarAction(
      label: 'Okay',
      onPressed: () {},
    ),
  );

  Scaffold.of(context).showSnackBar(snackBar);
}
