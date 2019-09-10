import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';

class MatchesTempApp extends StatelessWidget {
  const MatchesTempApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MatchesPage(),
    );
  }
}

class MatchesPage extends StatelessWidget {
  const MatchesPage([Key key]) : super(key: key);

  Widget _listItemBuilder(BuildContext context, int index) {
    return _listItem(context, _matchedProfiles[index]);
  }

  Widget _listItem(BuildContext context, MatchedProfile profile) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                profile.imageURL,
                height: 96,
                width: 96,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16),
              // alignment: Alignment.centerLeft,
              child: getMatchText(context, profile),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMatchText(BuildContext context, MatchedProfile profile) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          profile.name,
          style: Theme.of(context).textTheme.title,
        ),
        getHobbies(context, profile),
      ],
    );
  }

  Widget getHobbies(BuildContext context, MatchedProfile profile) {
    List<Widget> list = new List<Widget>();
    for (Hobby hobby in profile.hobbies) {
      list.add(getHobbyChip(context, hobby));
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

  Widget getHobbyChip(BuildContext context, Hobby hobby) {
    // return Chip(
    //   label: Text(hobby.name),
    //   backgroundColor: hobby.color,
    // );
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(32)),
      child: Container(
        color: hobby.color,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          child: new Text(hobby.name, style: Theme.of(context).textTheme.body1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Matches'),
        ),
        body: ListView.builder(
          itemCount: _matchedProfiles.length,
          // itemExtent: 100,
          itemBuilder: _listItemBuilder,
          // physics: BouncingScrollPhysics(),
        ));
  }
}

class MatchedProfile {
  const MatchedProfile({this.name, this.imageURL, this.hobbies});
  final String name;
  final String imageURL;
  final List<Hobby> hobbies;
}

class Hobby {
  const Hobby({this.name, this.color});
  final String name;
  final Color color;
}

List<MatchedProfile> _matchedProfiles = <MatchedProfile>[
  _davidTennant,
  _seanBean
];

final List<Hobby> _hobbies = <Hobby>[
  Hobby(name: "Hiking", color: Color(0xfffbb4ae)),
  Hobby(name: "Canoeing", color: Color(0xffb3cde3)),
  Hobby(name: "Fencing", color: Color(0xffccebc5)),
  Hobby(name: "Fishing", color: Color(0xffdecbe4)),
  Hobby(name: "Boxing", color: Color(0xfffed9a6)),
  Hobby(name: "Marathons", color: Color(0xffffffcc)),
  Hobby(name: "Archery", color: Color(0xffe5d8bd)),
  Hobby(name: "Fencing", color: Color(0xfffddaec)),
  Hobby(name: "Sailing", color: Color(0xfff2f2f2)),
];

List<Hobby> getRandomHobbies(int n) {
  List<Hobby> list = new List<Hobby>();
  var rng = new Random();
  for (int i = 0; i < n; i++) {
    var hob = _hobbies[rng.nextInt(_hobbies.length)];
    if (!list.contains(hob)) list.add(hob);
  }
  return list;
}

MatchedProfile _seanBean = MatchedProfile(
    name: "Sean Bean",
    imageURL:
        "https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/AV0A6306_Sean_Bean.jpg/468px-AV0A6306_Sean_Bean.jpg",
    hobbies: getRandomHobbies(5));

MatchedProfile _davidTennant = MatchedProfile(
    name: "David Tennant",
    imageURL:
        "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Good_Omens_panel_at_NYCC_%2860841%29a.jpg/1024px-Good_Omens_panel_at_NYCC_%2860841%29a.jpg",
    hobbies: getRandomHobbies(2));
