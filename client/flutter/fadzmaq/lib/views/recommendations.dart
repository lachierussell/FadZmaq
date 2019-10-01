import 'dart:typed_data';

import 'package:fadzmaq/models/hobbies.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/recommendations.dart';

import 'package:fadzmaq/views/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fadzmaq/controllers/request.dart';

import 'dart:math';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';


// TODO unify this
class ProfilePic extends StatelessWidget {
  final String url;

  ProfilePic({
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    print(url);

    return SizedBox(
      height: 80,
      width: 80,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        // placeholder: (context, url) => new CircularProgressIndicator(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
      ),
    );
  }
}

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage([Key key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetRequest<RecommendationsData>(
        url: "user/recs",
        builder: (context) {
          return RecommendationsList();
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

class RecommendationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RecommendationsData recommendationsData = RequestProvider.of<RecommendationsData>(context);
    print(recommendationsData.toString());
    print(recommendationsData.recommendations.toString());

    return ListView.builder(
      // itemCount: _matchedProfiles.length,
      itemCount: recommendationsData.recommendations.length,
      itemBuilder: _listItemBuilder,
    );
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    RecommendationsData recommendationsData = RequestProvider.of<RecommendationsData>(context);
    return _listItem(context, recommendationsData.recommendations[index].user);
  }

  Widget _listItem(BuildContext context, ProfileData profile) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(url: "matches/" + profile.userId)),
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
                child: getProfileText(context, profile),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getProfileText(BuildContext context, ProfileData profile) {
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

  Widget getHobbies(BuildContext context, ProfileData profile) {
    // return Text("to be done");

    List<Widget> list = new List<Widget>();
    // print(profile.hobbyContainers.toString());
    if (profile.hobbyContainers != null) {
      for (HobbyContainer hc in profile.hobbyContainers) {
        print(hc.container.toString());
        if (hc.container == "matched") {
          for (HobbyData hobby in hc.hobbies) {
            list.add(getHobbyChip(context, hobby));
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

  Widget getHobbyChip(BuildContext context, HobbyData hobby) {
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
}

final TextStyle nameStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

final TextStyle hobbyStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
);
