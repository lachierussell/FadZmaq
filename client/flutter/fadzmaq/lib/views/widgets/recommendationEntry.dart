import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/views/profilepage.dart';
import 'package:fadzmaq/views/recommendations.dart';
import 'package:fadzmaq/views/widgets/displayPhoto.dart';
import 'package:fadzmaq/views/widgets/hobbyChip.dart';
import 'package:flutter/material.dart';

class RecommendationEntry extends StatelessWidget {
  final ProfileData profile;
  final RecommendationsListState recommendationList;

  const RecommendationEntry({
    Key key,
    this.profile,
    this.recommendationList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _recommendationEntry(context, profile);
  }

  _navigateAwait(BuildContext context, ProfileData profile) async {
    UserProfileContainer upc =
        RequestProvider.of<UserProfileContainer>(context);

    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final userId = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          url: "matches/" + profile.userId,
          profile: profile,
          userData: upc,
        ),
      ),
    );

    // make changes according to the result
    // in this case remove the recommendation we have just liked/disliked
    recommendationList.removeItem(userId);
  }

  Widget _recommendationEntry(BuildContext context, ProfileData profile) {
    return GestureDetector(
      onTap: () {
        _navigateAwait(context, profile);
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
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
      SizedBox(height: 6),
      HobbyChips(
        hobbies: profile.hobbyContainers,
        hobbyCategory: HobbyDirection.match,
      ),
    ],
  );
}

final TextStyle _nameStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w600,
);
