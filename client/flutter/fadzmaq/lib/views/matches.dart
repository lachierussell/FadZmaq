import 'package:fadzmaq/controllers/imageCache.dart';
import 'package:fadzmaq/controllers/globalData.dart';
import 'package:fadzmaq/models/globalModel.dart';
import 'package:fadzmaq/models/profile.dart';
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
          return VerifyModel(
              model: Model.userProfile,
              builder: (context) {
                return MatchesList();
              });
        });
  }
}

class MatchesList extends StatefulWidget {
  @override
  _MatchesListState createState() => _MatchesListState();
}

class _MatchesListState extends State<MatchesList> {
  List<ProfileContainer> matchesList;

  @override
  void didChangeDependencies() {
    if (matchesList == null) {
      MatchesData matchesData = getMatches(context);
      matchesList = matchesData.matches;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // MatchesData matchesData = RequestProvider.of<MatchesData>(context);
    MatchesData matchesData = getMatches(context);
    // print(matchesData.toString());
    // print(matchesData.matches.toString());
    GlobalModel globalModel = getModel(context);
    cacheMatchPhotos(globalModel, matchesData);

    if (matchesList.length > 0) {
      return ListView.builder(
        itemCount: matchesList.length,
        itemBuilder: _listItemBuilder,
      );
    } else {
      return Text(
        "\n\nNo Matches!\n\nTry browsing your recommendations\nfor people you might like!",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      );
    }
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    // MatchesData matchesData = RequestProvider.of<MatchesData>(context);
    return MatchEntry(profile: matchesList[index].profile);
  }
}
