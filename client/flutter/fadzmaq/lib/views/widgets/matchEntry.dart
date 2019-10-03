import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/views/profilepage.dart';
import 'package:fadzmaq/views/widgets/displayPhoto.dart';
import 'package:fadzmaq/views/widgets/hobbyChip.dart';
import 'package:flutter/material.dart';
import 'package:fadzmaq/models/matches.dart';

class MatchEntry extends StatelessWidget {
  final MatchProfileData profile;

  MatchEntry({
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return _matchEntry(context, profile);
  }
}

Widget _matchEntry(BuildContext context, MatchProfileData profile) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(url: "matches/" + profile.id)),
      );
    },
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: DisplayPhoto(
                url: profile.photo,
                dimension: 80,
              ),
            ),
          ),
          Expanded(
            child: Container(
              // color: Colors.green,
              padding: const EdgeInsets.only(left: 16),
              // alignment: Alignment.centerLeft,
              child: _getMatchText(context, profile),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _getMatchText(BuildContext context, MatchProfileData profile) {
  return new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        profile.name,
        // style: Theme.of(context).textTheme.title,
        style: nameStyle,
      ),
      HobbyChips(hobbies: profile.hobbyContainers, container: HobbyDirection.match,),
    ],
  );
}


final TextStyle nameStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);


