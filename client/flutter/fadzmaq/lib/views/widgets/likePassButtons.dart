import 'package:fadzmaq/controllers/postAsync.dart';
import 'package:fadzmaq/models/globalModel.dart';
import 'package:fadzmaq/models/likeResult.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/views/widgets/matchDialog.dart';
import 'package:fadzmaq/controllers/globalData.dart';
import 'dart:convert';

enum LikePass { like, pass }

/// Like and pass buttons for recommended profiles
class LikeButton extends StatelessWidget {
  final ProfileData profile;
  final LikePass type;

  LikeButton({
    @required this.profile,
    @required this.type,
  })  : assert(profile != null),
        assert(type != null);

  @override
  Widget build(BuildContext context) {
    final Color color = type == LikePass.like ? Colors.green : Colors.red;
    final IconData icon = type == LikePass.like ? Icons.done : Icons.clear;
    final double leftPad = type == LikePass.like ? 0 : 50;
    final double rightPad = type == LikePass.like ? 50 : 0;

    return Padding(
      padding: EdgeInsets.fromLTRB(leftPad, 0, rightPad, 20),
      child: Container(
        width: 90,
        height: 90,
        child: FloatingActionButton(
          child: Icon(
            icon,
            color: color,
            size: 60,
          ),
          backgroundColor: Colors.white,
          heroTag: null,
          onPressed: () {
            // return the result of this button press to recommendations page
            Navigator.pop(context, type);
          },
        ),
      ),
    );
  }
}

/// Makes an async request and prepares a popup on certain response conditions
void asyncMatchPopup(BuildContext context, ProfileData profile) async {
  print("asyncMatchPopup");
  // http.Response response = await postAsync(context, "like/" + profile.userId);
  MatchesData matches;
  try {
    matches = getMatches(context);
  } catch (e) {
    await loadModel(context, Model.matches);
    matches = getMatches(context);
  }

  // do a post request for like
  // build the model if there is a response
  // show popup if new match is true
  await postAsync(context, "like/" + profile.userId).then((response) {
    if (response != null) {
      // print("RESPONSE! " + response.body);
      LikeResult lr = LikeResult.fromJson(json.decode(response.body));

      if (lr.match == true && lr.matched != null && lr.matched.length > 0) {
        matches.addToMatchesModel(lr.matched[0]);
        matchPopup(lr.matched.first.profile);
      }
    } else {}
  });
}
