import 'package:fadzmaq/controllers/postAsync.dart';
import 'package:fadzmaq/models/globalModel.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void unmatch(BuildContext context, String uid) async {
  MatchesData matches = getMatches(context);

  ProfileContainer toRemove;
  for (ProfileContainer pc in matches.matches) {
    if (pc.profile.userId == uid) {
      toRemove = pc;
    }
  }

  if (toRemove != null) matches.matches.remove(toRemove);

  postAsync(context, "matches/" + uid, useDelete: true);

  Navigator.of(context).pop(true);
}

//show alert dialog
Future unmatchDialog(BuildContext context, String uid) async {
  return showDialog(
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
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
              child: const Text('ACCEPT'),
              onPressed: () {
                unmatch(context, uid);
                // Navigator.of(context).pop();
              }),
        ],
      );
    },
  );
}
