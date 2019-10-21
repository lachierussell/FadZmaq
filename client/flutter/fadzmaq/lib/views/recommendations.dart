import 'dart:math';
import 'package:fadzmaq/controllers/globalData.dart';
import 'package:fadzmaq/controllers/globals.dart';
import 'package:fadzmaq/controllers/imageCache.dart';
import 'package:fadzmaq/controllers/postAsync.dart';
import 'package:fadzmaq/models/globalModel.dart';
import 'package:fadzmaq/models/profile.dart';
import 'package:fadzmaq/models/recommendations.dart';
import 'package:fadzmaq/views/widgets/displayPhoto.dart';
import 'package:fadzmaq/views/widgets/recommendationEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fadzmaq/controllers/request.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage([Key key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerifyModel(
        model: Model.recommendations,
        builder: (context) {
          return VerifyModel(
              model: Model.userProfile,
              builder: (context) {
                return RecommendationsList();
              });
          ;
        });
  }
}

class RecommendationsList extends StatefulWidget {
  const RecommendationsList({Key key}) : super(key: key);

  @override
  RecommendationsListState createState() => RecommendationsListState();
}

class RecommendationsListState extends State<RecommendationsList> {
  List<ProfileContainer> recommendationsList;

  @override
  void didChangeDependencies() {
    if (recommendationsList == null) {
      RecommendationsData recommendationsData = getRecommendations(context);
      recommendationsList = recommendationsData.recommendations;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("build recommendations");

    if (recommendationsList.length > 0) {
      // never more than 10 entries shown
      int numEntries = min(11, recommendationsList.length);

      return RefreshIndicator(
        onRefresh: (() async {
          dynamic newModel = await loadModel(context, Model.recommendations);
          if (newModel.runtimeType == RecommendationsData &&
              newModel.recommendations != null) {
            setState(() {
              recommendationsList = newModel.recommendations;
            });
          }
        }),
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey,
              indent: 10,
              endIndent: 10,
            );
          },
          itemCount: numEntries,
          itemBuilder: _listItemBuilder,
        ),
      );
    } else {
      return Text(
        "\n\nNo Recommendations!\n\nTry adding more hobbies to share,\nor increase your search radius.",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      );
    }
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    if (index == 10)
      return SizedBox(
        height: 75,
        child: Center(
            child: Text(
          "To see more recommendations please like or pass\ncandidates from your current list",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        )),
      );
    if (recommendationsList[index].profile == null) return null;
    return RecommendationEntry(
        profile: recommendationsList[index].profile, recommendationList: this);
  }

  void removeItem(String id) {
    recommendationsList
        .removeWhere((container) => container.profile.userId == id);

    if (recommendationsList.length <= 15) {
      updateList();
    }
  }

  void updateList() async {
    http.Response response =
        await postAsync(context, Globals.recsURL, useGet: true);
    if (response == null) return;

    var rd = RecommendationsData.fromJson(json.decode(response.body));
    if (rd == null) return;

    GlobalModel globalModel = getModel(context);
    cacheRecommendationPhotos(globalModel, rd);

    List<ProfileContainer> newList = rd.recommendations;
    if (recommendationsList == null) return;

    // We don't reorder the list in rank (start or finish) as added
    // entries may end up with the same rank or higher as others
    // we expect incoming recommendations to be at the end of the list,
    // and we expect the order of the seen recommendations to remain unchanged
    for (ProfileContainer pc in newList) {
      if (!recommendationsList.contains(pc)) {
        recommendationsList.add(pc);
      }
    }
  }
}
