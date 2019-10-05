import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/views/profilepage.dart';
import 'package:fadzmaq/views/widgets/displayPhoto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<void> matchPopup(BuildContext context, ProfileData profile) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('New Match!'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Match with ' + profile.name),
              DisplayPhoto(url: profile.photo, dimension: 50,),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Keep Browsing'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('View Profile'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                          // just view our own profile for now
                          url: "profile",
                          type: ProfileType.match,
                        )),
              );
            },
          ),
        ],
      );
    },
  );
}
