import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/controllers/globalData.dart';
import 'package:fadzmaq/models/globalModel.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/views/landing.dart';
import 'package:fadzmaq/views/profilepage.dart';
import 'package:fadzmaq/views/widgets/displayPhoto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// a pop up that occurs when a new match is made
Future<void> matchPopup(ProfileData profile) async {
  ProfileData userProfile = getUserProfile(mainScaffold.currentContext);

  return showDialog<void>(
    context: mainScaffold.currentContext,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('New Match with ' + profile.name + '!'),
        content: SingleChildScrollView(
          child: Center(
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text('Match with ' + profile.name),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: DisplayPhoto(
                    url: userProfile.photo,
                    dimension: Globals.matchThumbDim,
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.add, size: 40),
                SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: DisplayPhoto(
                    url: profile.photo,
                    dimension: Globals.matchThumbDim,
                  ),
                ),
              ],
            ),
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
                          url: "matches/" + profile.userId,
                          profile: profile,
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
