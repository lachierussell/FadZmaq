import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/views/profilepage.dart';
import 'package:fadzmaq/views/widgets/displayPhoto.dart';
import 'package:fadzmaq/views/widgets/hobbyChip.dart';
import 'package:flutter/material.dart';

class RecommendationEntry extends StatelessWidget {
  final ProfileData profile;

  RecommendationEntry({
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return _recommendationEntry(context, profile);
  }
}

Widget _recommendationEntry(BuildContext context, ProfileData profile) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProfilePage(url: "matches/" + profile.userId, profile: profile),
        ),
      );
    },
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: DisplayPhoto(
                url: profile.photo,
                dimension: 160,
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

Widget _getMatchText(BuildContext context, ProfileData profile) {
  return new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Container(
        // color: Colors.black,
        child: Text(
          profile.name,
          // style: Theme.of(context).textTheme.title,
          style: _nameStyle,
        ),
      ),
      HobbyChips(hobbies:profile.hobbyContainers, container: "matched",),
    ],
  );
}



final TextStyle _nameStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w600,
);

