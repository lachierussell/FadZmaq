import 'package:fadzmaq/controllers/cache.dart';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/views/widgets/matchEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:fadzmaq/models/matches.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage([Key key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetRequest<MatchesData>(
        url: Globals.matchesURL,
        builder: (context) {
          return GetRequest<UserProfileContainer>(
              url: Globals.profileURL,
              builder: (context) {
                return MatchesList();
              });
        });
  }
}

class MatchesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MatchesData matchesData = RequestProvider.of<MatchesData>(context);
    // print(matchesData.toString());
    // print(matchesData.matches.toString());

    cacheMatchPhotos(context, matchesData);

    print("build matches");

    return ListView.builder(
      itemCount: matchesData.matches.length,
      itemBuilder: _listItemBuilder,
    );
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    MatchesData matchesData = RequestProvider.of<MatchesData>(context);
    return MatchEntry(profile: matchesData.matches[index].profile);
  }
}
