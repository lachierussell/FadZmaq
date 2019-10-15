import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/views/landing.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/models/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';

/// Sends a post request to the server
/// Shows snackbar on timeout or errorous status code
///
/// Asynchrounous, does not wait for a response
Future<http.Response> postAsync(BuildContext context, String url,
    {var json, bool useGet = false, bool useDelete = false}) async {
  url = AppConfig.of(context).server + url;

  // this is here so we can catch errors for the popup, but return the response as a null
  http.Response response;

  // swap depending on what we got in
  // TODO merge httpGet and httpPost
  Function swapFunction;
  if (useGet) {
    swapFunction = httpGet;
  } else if (useDelete) {
    swapFunction = httpDelete;
  } else {
    swapFunction = httpPost;
  }

  Future request;
  request = swapFunction(url, json: json).then((value) {
    if (value.statusCode == 200 || value.statusCode == 204) {
      // errorSnackRevised(context,"passed!: " + value.statusCode.toString() + "\n" + value.body);
      response = value;
      print("body: " + value.body);
    } else {
      errorSnackRevised("failed!: " + value.statusCode.toString());
    }
  }).catchError((error) {
    errorSnackRevised("failed!: " + error.toString());
  });

  await request;
  return response;
}

/// snackbar for errors
void errorSnackRevised(String s) {
  Flushbar flush;
  flush = Flushbar(
    message: s,
    icon: Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.blue[300],
    ),
    leftBarIndicatorColor: Colors.blue[300],
    mainButton: FlatButton(
      onPressed: () {
        flush.dismiss(true); // result = true
      },
      child: Text(
        "Okay",
        style: TextStyle(color: Colors.amber),
      ),
    ), // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
  )..show(mainScaffold.currentContext);
}

// void errorSnack(BuildContext context, String s) {
//   SnackBar snackBar = SnackBar(
//     content: Text(s),
//     duration: Duration(days: 1),
//     action: SnackBarAction(
//       label: 'Okay',
//       onPressed: () {},
//     ),
//   );

//   // mainScaffold.currentState.showSnackBar(snackBar);
//   Scaffold.of(mainScaffold.currentContext).showSnackBar(snackBar);
// }
