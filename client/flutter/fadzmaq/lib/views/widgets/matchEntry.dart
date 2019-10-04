import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/views/profilepage.dart';
import 'package:fadzmaq/views/widgets/displayPhoto.dart';
import 'package:fadzmaq/views/widgets/hobbyChips.dart';
import 'package:flutter/material.dart';

class MatchEntry extends StatelessWidget {
  final ProfileData profile;

  MatchEntry({
    this.profile,
  });

  @override
  Widget build(BuildContext context) {

    UserProfileContainer upc =
        RequestProvider.of<UserProfileContainer>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(url: "matches/" + profile.userId, profile: profile, userData: upc, type: ProfileType.match)),
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
}

Widget _getMatchText(BuildContext context, ProfileData profile) {
  return new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        profile.name,
        // style: Theme.of(context).textTheme.title,
        style: nameStyle,
      ),
      SizedBox(height: 4,),
      HobbyChips(
        hobbies: profile.hobbyContainers,
        hobbyCategory: HobbyDirection.match,
      ),
    ],
  );
}

final TextStyle nameStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);
