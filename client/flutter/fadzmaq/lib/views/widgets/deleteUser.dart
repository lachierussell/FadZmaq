import 'package:fadzmaq/controllers/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Alert diaglog to confirm deleting an account
void deleteDialog(BuildContext context) async {
  showDialog(
  context: context,
  barrierDismissible: false, // user must tap button for close dialog!
  builder: (BuildContext context) {
  return AlertDialog(
  title: Text('Are you sure?'),
  content: const Text(
  'Please be aware that this action will delete your data too, but you can still log in with this account next time.'),
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
                deleteUser(context);
              }),
        ],
      );
    },
  );
}
