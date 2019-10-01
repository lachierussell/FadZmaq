import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/views/profilepage.dart';
import 'package:fadzmaq/views/widgets/displayPhoto.dart';
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
              // child: Image.network(
              //   profile.photo,
              //   height: 80,
              //   width: 80,
              //   fit: BoxFit.cover,
              // ),
              // child: FadeInImage.assetNetwork(
              //   image: profile.photo,
              //   placeholder: 'assets/images/placeholder-person.jpg',
              //   height: 80,
              //   width: 80,
              //   fit: BoxFit.cover,
              // ),
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
      _getHobbies(context, profile),
    ],
  );
}

Widget _getHobbies(BuildContext context, MatchProfileData profile) {
  // return Text("to be done");

  List<Widget> list = new List<Widget>();
  // print(profile.hobbyContainers.toString());
  if (profile.hobbyContainers != null) {
    for (HobbyContainer hc in profile.hobbyContainers) {
      print(hc.container.toString());
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
          child: new Text(hobby.name, style: hobbyStyle)),
    ),
  );
}

final TextStyle nameStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

final TextStyle hobbyStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
);
