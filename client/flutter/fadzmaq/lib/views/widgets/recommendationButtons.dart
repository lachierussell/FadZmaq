import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/matches.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final String id;

  LikeButton({
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Container(
          width: 90,
          height: 90,
          child: FloatingActionButton(
            child: Icon(
              Icons.done,
              size: 60,
            ),
            backgroundColor: Colors.green,
            heroTag: null,
            onPressed: () {
              Navigator.pop(context, id);
            },
          )

          // child: RawMaterialButton(
          //   elevation: 0,
          //   shape: CircleBorder(),
          //   onPressed: (){},
          //   fillColor: Colors.redAccent,
          //   child: Icon(Icons.ac_unit),
          // ),
          ),
    );
  }
}
