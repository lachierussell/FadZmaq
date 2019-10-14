import 'package:fadzmaq/controllers/cache.dart';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/models/mainModel.dart';
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
    return LoadModel(
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
    MatchesData matchesData = DataController.of(context).matches;
    return MatchEntry(profile: matchesData.matches[index].profile);
  }
}
