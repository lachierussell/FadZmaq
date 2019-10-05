import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/views/widgets/matchDialog.dart';

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
    final String url = type == LikePass.like ? "like/" + profile.userId : "pass/" + profile.userId;
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
            // TODO this should be the result of a potential future
            if (type == LikePass.like) matchPopup(context, profile);
            Navigator.pop(context, profile.userId);
          },
        ),
      ),
    );
  }
}
