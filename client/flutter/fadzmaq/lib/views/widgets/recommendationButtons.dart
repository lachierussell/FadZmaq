import 'package:fadzmaq/controllers/postAsync.dart';
import 'package:fadzmaq/models/likeResult.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/views/widgets/matchDialog.dart';
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
    final String url = type == LikePass.like
        ? "like/" + profile.userId
        : "pass/" + profile.userId;
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
            // TODO this should be more specific information
            // Navigator.pop(context, profile.userId);
            Navigator.pop(context, type);
          },
        ),
      ),
    );
  }
}

void asyncMatchPopup(BuildContext context, ProfileData profile) async {
  print("asyncMatchPopup");
  // http.Response response = await postAsync(context, "like/" + profile.userId);

  // do a post request for like
  // build the model if there is a response
  // show popup if new match is true
  await postAsync(context, "like/" + profile.userId).then((response) {
    if (response != null) {
      // print("RESPONSE! " + response.body);
      LikeResult lr = LikeResult.fromJson(
          json.decode(response.body));

      if (lr.match == true && lr.matched != null && lr.matched.length > 0) {
        matchPopup(context, lr.matched.first.profile);
      }
    } else {
      // print("asyncMatchPopup NULL!");
    }
  });
}
