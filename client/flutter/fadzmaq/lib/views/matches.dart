import 'package:fadzmaq/controllers/cache.dart';
import 'package:fadzmaq/controllers/globalData.dart';
import 'package:fadzmaq/models/mainModel.dart';
import 'package:fadzmaq/views/widgets/matchEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fadzmaq/models/matches.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage([Key key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerifyModel(
        model: Model.matches,
        builder: (context) {
          return MatchesList();
        });
  }
}

class MatchesList extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    // MatchesData matchesData = RequestProvider.of<MatchesData>(context);
    MatchesData matchesData = getMatchData(context);
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
    // MatchesData matchesData = RequestProvider.of<MatchesData>(context);
    MatchesData matchesData = GlobalData.of(context).matches;
    return MatchEntry(profile: matchesData.matches[index].profile);
  }
}
