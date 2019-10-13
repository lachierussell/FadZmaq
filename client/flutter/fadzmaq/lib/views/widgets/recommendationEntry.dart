import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/controllers/postAsync.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/views/profilepage.dart';
import 'package:fadzmaq/views/recommendations.dart';
import 'package:fadzmaq/views/widgets/displayPhoto.dart';
import 'package:fadzmaq/views/widgets/hobbyChips.dart';
import 'package:fadzmaq/views/widgets/recommendationButtons.dart';
import 'package:flutter/material.dart';

/// Entry in the recommendation list
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

  /// Await a response from the profile (like / pass buttons)
  /// If there is a response either way remove the entry from the list
  /// This needs to be a async as it waits for the page to return
  _navigateAwait(BuildContext context, ProfileData profile) async {
    UserProfileContainer upc =
        RequestProvider.of<UserProfileContainer>(context);

    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final LikePass type = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          url: "matches/" + profile.userId,
          profile: profile,
          userData: upc,
          type: ProfileType.recommendation,
        ),
      ),
    );

    // make changes according to the result
    // in this case remove the recommendation we have just liked/disliked
    if (type == LikePass.like) {
      asyncMatchPopup(context, profile);
      recommendationList.removeItem(profile.userId);
    } else if (type == LikePass.pass) {
      postAsync(context, "pass/" + profile.userId);
      recommendationList.removeItem(profile.userId);
    }
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
                  dimension: Globals.recThumbDim,
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
