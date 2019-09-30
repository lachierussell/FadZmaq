import 'package:fadzmaq/controllers/request.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/models/app_config.dart';

void postAsync(BuildContext context, String url) async {
  url = AppConfig.of(context).server + url;

  int code;
  SnackBar snackBar;

  try {
    code = await fetchResponseCode(url);
    snackBar = SnackBar(
      content: Text('SnackBar: ' + code.toString()),
      duration: Duration(days: 1),
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {},
      ),
    );
  } catch (e) {
    snackBar = SnackBar(
      content: Text('SnackBar: ' + e.toString()),
      duration: Duration(days: 1),
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }

  // Find the Scaffold in the widget tree and use it to show a SnackBar.
  Scaffold.of(context).showSnackBar(snackBar);
}
