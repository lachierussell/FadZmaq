import 'package:flutter/material.dart';

enum LikePass { like, pass }

/// Like and pass buttons for recommended profiles
class LikeButton extends StatelessWidget {
  final String id;
  final LikePass type;

  LikeButton({
    @required this.id,
    @required this.type,
  })  : assert(id != null),
        assert(type != null);

  @override
  Widget build(BuildContext context) {
    final String url = type == LikePass.like ? "like/" + id : "pass/" + id;
    final Color color = type == LikePass.like ? Colors.green : Colors.red;
    final IconData icon = type == LikePass.like ? Icons.done : Icons.clear;
    final double leftPad = type == LikePass.like ? 0 : 60;
    final double rightPad = type == LikePass.like ? 60 : 0;

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
            Navigator.pop(context, id);
          },
        ),
      ),
    );
  }
}
