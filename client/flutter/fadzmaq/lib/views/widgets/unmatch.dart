import 'package:fadzmaq/controllers/postAsync.dart';
import 'package:fadzmaq/views/matches.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;


void unmatch(BuildContext context) async {

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => MatchesList()));
  }

//show alert dialog
Future<void> unmatchDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Are you sure?'),
        content: const Text(
            'Please be aware that if you unmatch this user you will not be able to see infomation of this user.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
              child: const Text('ACCEPT'),
              onPressed: () {
                unmatch(context);
                // Navigator.of(context).pop();
              }),
        ],
      );
    },
  );
}
