import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/views/profilepage.dart';
import 'package:fadzmaq/views/widgets/displayPhoto.dart';
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
      _getHobbies(context, profile),
    ],
  );
}

Widget _getHobbies(BuildContext context, ProfileData profile) {
  // return Text("to be done");

  List<Widget> list = new List<Widget>();
  // print(profile.hobbyContainers.toString());
  if (profile.hobbyContainers != null) {
    for (HobbyContainer hc in profile.hobbyContainers) {
      // print(hc.container.toString());
      if (hc.container == "matched") {
        for (HobbyData hobby in hc.hobbies) {
          list.add(_getHobbyChip(context, hobby));
        }
      }
    }
  }
  return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: new Wrap(
      spacing: 4,
      runSpacing: 4,
      children: list,
    ),
  );
}

Widget _getHobbyChip(BuildContext context, HobbyData hobby) {
  // return Chip(
  //   label: Text(hobby.name),
  //   backgroundColor: hobby.color,
  // );
  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(32)),
    child: Container(
      color: Color(0xfff2f2f2),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          // child: new Text(hobby.name, style: Theme.of(context).textTheme.body1),
          child: new Text(hobby.name, style: _hobbyStyle)),
    ),
  );
}

final TextStyle _nameStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w600,
);

final TextStyle _hobbyStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
);
