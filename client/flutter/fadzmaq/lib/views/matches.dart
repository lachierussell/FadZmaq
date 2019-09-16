import 'package:fadzmaq/views/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/matches.dart';
import 'dart:math';

import 'package:flutter/services.dart';

class MatchesTempApp extends StatelessWidget {
  const MatchesTempApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MatchesPage(),
    );
  }
}

// TODO unify this
class ProfilePic extends StatelessWidget {
  final String url;

  ProfilePic({
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    print(url);

    // TODO this will fail on an image 404
    // flutter is dumb so this is hard to fix
    if (url != null && url != "") {
      return FadeInImage.assetNetwork(
        image: url,
        placeholder: 'assets/images/placeholder-person.jpg',
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'assets/images/placeholder-person.jpg',
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      );
    }
  }
}

class MatchesPage extends StatelessWidget {
  const MatchesPage([Key key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetRequest<MatchesData>(
        url: "matches",
        builder: (context) {
          return MatchesList();
        });

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Matches'),
    //   ),
    //   body: GetRequest<MatchesData>(
    //     url: "matches",
    //     builder: (context) {
    //       return MatchesList();
    //     },
    //   ),
    // );
  }
}

class MatchesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MatchesData matchesData = RequestProvider.of<MatchesData>(context);
    print(matchesData.toString());
    print(matchesData.matches.toString());

    return ListView.builder(
      // itemCount: _matchedProfiles.length,
      itemCount: matchesData.matches.length,
      itemBuilder: _listItemBuilder,
    );
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    MatchesData matchesData = RequestProvider.of<MatchesData>(context);
    return _listItem(context, matchesData.matches[index]);
  }

  Widget _listItem(BuildContext context, MatchProfileData profile) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(url: "matches/" + profile.id)),
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
                child: ProfilePic(url: profile.photo),
              ),
            ),
            Expanded(
              child: Container(
                // color: Colors.green,
                padding: const EdgeInsets.only(left: 16),
                // alignment: Alignment.centerLeft,
                child: getMatchText(context, profile),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getMatchText(BuildContext context, MatchProfileData profile) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          profile.name,
          // style: Theme.of(context).textTheme.title,
          style: nameStyle,
        ),
        getHobbies(context, profile),
      ],
    );
  }

  Widget getHobbies(BuildContext context, MatchProfileData profile) {
    // return Text("to be done");

    List<Widget> list = new List<Widget>();
    List<Hobby> hobsTemp = getRandomHobbies(2);
    // for (Hobby hobby in profile.hobbies) {
    for (Hobby hobby in hobsTemp) {
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
            // child: new Text(hobby.name, style: Theme.of(context).textTheme.body1),
            child: new Text(hobby.name, style: hobbyStyle)),
      ),
    );
  }
}

final TextStyle nameStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

final TextStyle hobbyStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

// class MatchedProfile {
//   const MatchedProfile({this.name, this.imageURL, this.hobbies});
//   final String name;
//   final String imageURL;
//   final List<Hobby> hobbies;
// }

class Hobby {
  const Hobby({this.name, this.color});
  final String name;
  final Color color;
}

// List<MatchedProfile> _matchedProfiles = <MatchedProfile>[
//   _david,
//   _sean,
//   _jeffrey,
//   _rachel,
//   _sam,
//   _ryan,
//   _rooney,
//   _david,
//   _sean,
//   _jeffrey,
//   _rachel,
//   _sam,
//   _ryan,
//   _rooney,
//   _david,
//   _sean,
//   _jeffrey,
//   _rachel,
//   _sam,
//   _ryan,
//   _rooney,
// ];

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

// MatchedProfile _sean = MatchedProfile(
//     name: "Sean Bean",
//     imageURL:
//         "https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/AV0A6306_Sean_Bean.jpg/468px-AV0A6306_Sean_Bean.jpg",
//     hobbies: getRandomHobbies(5));

// MatchedProfile _david = MatchedProfile(
//     name: "David Tennant",
//     imageURL:
//         "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Good_Omens_panel_at_NYCC_%2860841%29a.jpg/1024px-Good_Omens_panel_at_NYCC_%2860841%29a.jpg",
//     hobbies: getRandomHobbies(2));

// MatchedProfile _rooney = MatchedProfile(
//     name: "Rooney Mara",
//     imageURL:
//         "https://upload.wikimedia.org/wikipedia/commons/1/10/Rooney_Mara_at_The_Discovery_premiere_during_day_2_of_the_2017_Sundance_Film_Festival_at_Eccles_Center_Theatre_on_January_20%2C_2017_in_Park_City%2C_Utah_%2832088061480%29_%28cropped%29.jpg",
//     hobbies: getRandomHobbies(2));

// MatchedProfile _jeffrey = MatchedProfile(
//     name: "Jeffrey Wright",
//     imageURL:
//         "https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Jeffrey_Wright_by_Gage_Skidmore_3.jpg/800px-Jeffrey_Wright_by_Gage_Skidmore_3.jpg",
//     hobbies: getRandomHobbies(2));

// MatchedProfile _sam = MatchedProfile(
//     name: "Sam Neill",
//     imageURL:
//         "https://upload.wikimedia.org/wikipedia/commons/thumb/6/61/Sam_Neill_2010.jpg/435px-Sam_Neill_2010.jpg",
//     hobbies: getRandomHobbies(2));

// MatchedProfile _ryan = MatchedProfile(
//     name: "Ryan Gosling",
//     imageURL:
//         "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/Ryan_Gosling_%2836034827222%29_%28cropped%29.jpg/428px-Ryan_Gosling_%2836034827222%29_%28cropped%29.jpg",
//     hobbies: getRandomHobbies(2));

// MatchedProfile _rachel = MatchedProfile(
//     name: "Rachel McAdams",
//     imageURL:
//         "https://upload.wikimedia.org/wikipedia/commons/3/3e/Rachel_McAdams%2C_2016_%28cropped%29.jpg",
//     hobbies: getRandomHobbies(2));
